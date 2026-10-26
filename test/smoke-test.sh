#!/bin/sh
# Install Agent Emacs from scratch in a throwaway HOME and check that it
# starts cleanly.  Needs network access; takes a few minutes.
#
# Checks: every package in lockfile.el is installed at its locked commit,
# startup leaves no warnings, the agent and appearance modes are on, and
# agent-setup reports nothing missing other than programs absent from this
# machine.
set -eu

repo=$(cd "$(dirname "$0")/.." && pwd)
work=$(mktemp -d "${TMPDIR:-/tmp}/agent-emacs-smoke.XXXXXX")
name="agent-emacs-smoke-$$"
emacs=${EMACS:-emacs}
emacsclient=${EMACSCLIENT:-emacsclient}

cleanup() {
  "$emacsclient" -s "$name" -e '(kill-emacs)' >/dev/null 2>&1 || true
  rm -rf "$work"
}
trap cleanup EXIT

mkdir -p "$work/home" "$work/dist/var"
cp "$repo/early-init.el" "$repo/init.el" "$repo/lockfile.el" "$work/dist/"
# Skip the interactive first-run prompt; agent-setup is run below.
touch "$work/dist/var/setup-done"

# Unset the tools' config homes too: agent-setup links its skills into
# them, and inherited values would point at the real ones.
env -u CLAUDE_CONFIG_DIR -u CODEX_HOME HOME="$work/home" \
  "$emacs" --fg-daemon="$name" --init-directory "$work/dist" \
  >"$work/daemon.log" 2>&1 &

ready=
i=0
while [ $i -lt 900 ]; do
  ready=$("$emacsclient" -s "$name" -e \
    '(and (bound-and-true-p elpaca-after-init-time) t)' 2>/dev/null || true)
  [ "$ready" = t ] && break
  sleep 1
  i=$((i + 1))
done
if [ "$ready" != t ]; then
  echo "FAIL: Agent Emacs did not finish starting"; tail -20 "$work/daemon.log"
  exit 1
fi

result=$("$emacsclient" -s "$name" -e '
(let ((problems nil))
  (dolist (entry (with-temp-buffer
                   (insert-file-contents (expand-file-name "lockfile.el" user-emacs-directory))
                   (read (current-buffer))))
    (let* ((id (car entry))
           (ref (plist-get (plist-get (cdr entry) :recipe) :ref))
           (dir (and (elpaca-get id) (elpaca<-source-dir (elpaca-get id))))
           (head (and (file-directory-p dir)
                      (let ((default-directory dir))
                        (string-trim (shell-command-to-string "git rev-parse HEAD"))))))
      (unless (equal head ref)
        (push (format "%s at %s, locked %s" id head ref) problems))))
  (when-let* ((warnings (get-buffer "*Warnings*")))
    (push (with-current-buffer warnings (buffer-string)) problems))
  (dolist (mode (quote (agent-claude-mode agent-codex-mode agent-tab-bar-mode
                       tab-bar-mode doom-modeline-mode spacious-padding-mode
                       global-corfu-mode)))
    (unless (symbol-value mode) (push (format "%s is off" mode) problems)))
  (cl-letf (((symbol-function (quote y-or-n-p)) (lambda (&rest _) t)))
    (save-window-excursion (agent-setup)))
  (with-current-buffer "*agent-setup*"
    (goto-char (point-min))
    (while (re-search-forward "^  ✗ \\(.*\\)$" nil t)
      (let ((line (match-string 1)))
        (unless (member line (list "claude not found" "codex not found"))
          (push line problems)))))
  (if problems (string-join (nreverse problems) "\n") "ok"))')

if [ "$result" = '"ok"' ]; then
  echo "PASS: Agent Emacs installed and started cleanly"
else
  echo "FAIL:"; printf '%b\n' "$result"
  exit 1
fi
