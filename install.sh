#!/bin/sh
# Install or update Agent Emacs on a Mac.  Run it with:
#
#   curl -fsSL https://raw.githubusercontent.com/benthamite/agent-emacs/main/install.sh | sh
#
# Running it again updates Agent Emacs.  It installs only what is missing,
# so it never replaces an Emacs, agent or font you already have.
#
# For testing, these variables override where things go:
#   AGENT_EMACS_REPO   repository to clone
#   AGENT_EMACS_DIR    where the configuration lives
#   AGENT_EMACS_APPS   folder for the Agent Emacs app
#   AGENT_EMACS_BIN    folder for the agent-emacs command
#   AGENT_EMACS_NO_START=1  do not start Agent Emacs at the end
set -eu

repo=${AGENT_EMACS_REPO:-https://github.com/benthamite/agent-emacs}
dir=${AGENT_EMACS_DIR:-$HOME/.config/agent-emacs}
apps=${AGENT_EMACS_APPS:-$HOME/Applications}
bin=${AGENT_EMACS_BIN:-$HOME/.local/bin}
emacs_app=/Applications/Emacs.app

say() { printf '\n==> %s\n' "$*"; }
die() { printf '\nAgent Emacs: %s\n' "$*" >&2; exit 1; }

# Ask a yes-or-no question on the terminal, even when this script is piped
# into sh.  Without a terminal the answer is no.
ask() {
  printf '%s [Y/n] ' "$1"
  answer=n
  { read -r answer </dev/tty; } 2>/dev/null || { echo; return 1; }
  case $answer in [Nn]*) return 1 ;; *) return 0 ;; esac
}

[ "$(uname)" = Darwin ] || die "this installer is for macOS."
command -v brew >/dev/null 2>&1 ||
  die "Homebrew is needed first.  Install it from https://brew.sh, then run this command again."

install_emacs() {
  if [ -d "$emacs_app" ]; then
    version=$("$emacs_app/Contents/MacOS/Emacs" --batch --eval '(princ emacs-major-version)' 2>/dev/null || echo 0)
    [ "$version" -ge 30 ] ||
      die "$emacs_app is Emacs $version; Agent Emacs needs Emacs 30 or later."
    return
  fi
  # Emacs Plus offers a prebuilt app only for Apple Silicon and macOS 15 or
  # later; elsewhere, the standard Emacs app works too.
  if [ "$(uname -m)" = arm64 ] && [ "$(sw_vers -productVersion | cut -d. -f1)" -ge 15 ]; then
    say "Installing Emacs Plus"
    # Homebrew 7 and later loads other people's taps only once trusted.
    if brew help trust >/dev/null 2>&1; then
      brew trust --tap d12frosted/emacs-plus
    fi
    brew install --cask d12frosted/emacs-plus/emacs-plus-app
  else
    say "Installing Emacs"
    brew install --cask emacs
  fi
}

# Emacs Plus compiles packages with the gcc it was built against, so an older
# gcc left from before makes every package fail to compile.
update_gcc() {
  if brew list --cask emacs-plus-app >/dev/null 2>&1 &&
     [ -n "$(brew outdated --formula --quiet gcc 2>/dev/null)" ]; then
    say "Updating gcc to match Emacs Plus"
    brew upgrade gcc
  fi
}

install_missing() {
  casks=
  command -v claude >/dev/null 2>&1 || casks="$casks claude-code"
  command -v codex >/dev/null 2>&1 || casks="$casks codex"
  font_installed Iosevka || casks="$casks font-iosevka"
  font_installed SymbolsNerdFont || casks="$casks font-symbols-only-nerd-font"
  if [ -n "$casks" ]; then
    say "Installing$casks"
    # shellcheck disable=SC2086
    brew install --cask $casks
  fi
  # Codex's session history needs `timeout', which macOS lacks.
  if ! command -v gtimeout >/dev/null 2>&1 && ! command -v timeout >/dev/null 2>&1; then
    say "Installing coreutils"
    brew install coreutils
  fi
}

font_installed() {
  for font in "$HOME"/Library/Fonts/"$1"* /Library/Fonts/"$1"*; do
    [ -e "$font" ] && return 0
  done
  return 1
}

get_configuration() {
  if [ -d "$dir/.git" ]; then
    say "Updating Agent Emacs in $dir"
    git -C "$dir" pull --ff-only
  elif [ -e "$dir" ]; then
    die "$dir exists but is not a copy of Agent Emacs; move it away and run this again."
  else
    say "Downloading Agent Emacs to $dir"
    mkdir -p "$(dirname "$dir")"
    git clone "$repo" "$dir"
  fi
}

# An app in ~/Applications, so Agent Emacs can be started from Spotlight,
# Launchpad or the Dock like any other app.
make_app() {
  app="$apps/Agent Emacs.app"
  mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources"
  cat >"$app/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key><string>Agent Emacs</string>
  <key>CFBundleIdentifier</key><string>io.github.benthamite.agent-emacs</string>
  <key>CFBundleExecutable</key><string>agent-emacs</string>
  <key>CFBundleIconFile</key><string>Emacs</string>
  <key>CFBundlePackageType</key><string>APPL</string>
</dict>
</plist>
EOF
  printf '#!/bin/sh\nexec "%s/bin/agent-emacs" "$@"\n' "$dir" >"$app/Contents/MacOS/agent-emacs"
  chmod +x "$app/Contents/MacOS/agent-emacs"
  cp "$emacs_app/Contents/Resources/Emacs.icns" "$app/Contents/Resources/"
}

# The agent-emacs command, for starting it from a terminal.  Only where
# the shell already looks for commands: changing the user's PATH is not
# this installer's business.
link_command() {
  case ":$PATH:" in
    *":$bin:"*) ln -sf "$dir/bin/agent-emacs" "$bin/agent-emacs" ;;
  esac
}

# A locked screen hides every Emacs window, and App Nap then slows Emacs
# so much that the phone page times out until the screen is unlocked.
# The setting belongs to the Emacs app, so it covers every Emacs started
# from it, and takes effect at its next launch.
disable_app_nap() {
  id=$(defaults read "$emacs_app/Contents/Info" CFBundleIdentifier 2>/dev/null) || return 0
  defaults write "$id" NSAppSleepDisabled -bool YES
}

log_in() {
  if command -v claude >/dev/null 2>&1 && ! claude auth status >/dev/null 2>&1 &&
     ask "Log in to Claude Code now?"; then
    claude auth login </dev/tty || true
  fi
  if command -v codex >/dev/null 2>&1 && ! codex login status >/dev/null 2>&1 &&
     ask "Log in to Codex now?"; then
    codex login </dev/tty || true
  fi
}

install_emacs
update_gcc
install_missing
get_configuration
make_app
link_command
disable_app_nap
log_in

say "Agent Emacs is installed.  Start it from Spotlight or Launchpad (\"Agent Emacs\")."
if [ "${AGENT_EMACS_NO_START:-}" != 1 ]; then
  echo "Starting it now.  The first start builds its packages, which takes a few minutes."
  "$dir/bin/agent-emacs"
fi
