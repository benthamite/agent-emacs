# Agent Emacs

An Emacs set up for one job: running AI coding agents — [Claude Code](https://code.claude.com) and [Codex](https://developers.openai.com/codex) — side by side, with every session one keystroke away.

It is built around the [`agent`](https://github.com/benthamite/agent) package and comes with the defaults Emacs should have had all along: no backup clutter, a theme that follows your system's light or dark mode, the usual Mac shortcuts, modern completion, and files that refresh when an agent changes them.

It runs as its own Emacs instance, so it does not touch any Emacs configuration you already have.

## Install (macOS)

1. Install Emacs 30 or later, Git and Node. [Emacs+](https://github.com/d12frosted/homebrew-emacs-plus) is recommended; its prebuilt app installs in about a minute on an Apple Silicon Mac with macOS 15 or later:

   ```sh
   brew trust d12frosted/emacs-plus
   brew tap d12frosted/emacs-plus
   brew install --cask emacs-plus-app
   brew install git node
   ```

   If Homebrew already had an older `gcc`, also run `brew upgrade gcc`. Emacs+ compiles packages natively with its `libgccjit`, which needs the `gcc` of the same version; a mismatch shows up as `error invoking gcc driver` warnings on the first start.

   If you will use Codex, also run `brew install coreutils`. agent-log builds the Codex session catalog with `timeout` or `gtimeout`, which macOS lacks; without them its session browser and search list no Codex sessions.

   Any other Emacs 30 or later installed as `/Applications/Emacs.app` works too, such as `brew install --cask emacs`, but only Emacs+ can hide the window's title bar.

   Optionally, install the fonts Agent Emacs is designed around. Without them it uses Menlo and a mode line without icons.

   ```sh
   brew install --cask font-iosevka font-symbols-only-nerd-font
   ```

2. Install the agents you want to use:

   ```sh
   curl -fsSL https://claude.ai/install.sh | bash   # Claude Code
   npm install -g @openai/codex                     # Codex
   ```

   Log in to each once from a terminal (`claude`, then `codex`).

3. Get Agent Emacs and start it:

   ```sh
   git clone https://github.com/benthamite/agent-emacs ~/.config/agent-emacs
   ~/.config/agent-emacs/bin/agent-emacs
   ```

The first start downloads and builds the packages, which takes a few minutes. When it is done, Agent Emacs runs `M-x agent-setup`, which checks that the agents are installed. Agent Emacs never edits your Claude Code settings: the hooks that tell Emacs when a session is waiting for you are passed only to the sessions it starts, so `claude` in a terminal is unaffected. Setup also offers to link three skills into `~/.claude/skills` and `~/.codex/skills`: `handoff`, which the menu's handoff command needs, and two that let one session read or message another. It asks first, and never replaces a skill of yours with the same name. You can run `M-x agent-setup` again at any time.

To start Agent Emacs from Spotlight or the Dock, create an app around the launcher, for example with Automator ("Run Shell Script": `~/.config/agent-emacs/bin/agent-emacs`).

## Use

| Keys | What it does |
|------|--------------|
| `C-c a` | Agent menu: start, resume, switch and close sessions |
| `C-c s` | Switch to a session |
| `C-c w` | Jump to the next session waiting for you |
| `C-c c` | Claude Code commands |
| `C-x g` | Git status (Magit) |
| `C-x p f` | Open a file in the current project |

`C-c` means Control-c; `M-x` means Option-x. `C-g` cancels anything. Cmd-C, Cmd-V, Cmd-Z and Cmd-S work as in any Mac app. Under Emacs+ the window has no title bar; Cmd-Q quits. After a prefix such as `C-x`, wait a moment and a list of what can follow appears. `M-x agent-emacs-welcome` shows the key overview again.

Agent Emacs starts with the window split into two columns, so that two sessions fit side by side: the left one is empty, ready for your first session, and the right one lists the main keys. Sessions also appear as tabs along the top, coloured when they are waiting for input, and you get a notification when an agent finishes.

## Update

```sh
cd ~/.config/agent-emacs && git pull
```

Then restart Agent Emacs. Package versions are pinned in `lockfile.el`, so everyone runs the versions this configuration was tested with. When an update changes those versions, the next start installs them afresh, which takes a few minutes, and removes the old ones.

## Develop

`test/smoke-test.sh` installs Agent Emacs from scratch in a throwaway home directory and checks that every package is at its locked commit, that startup is clean and that `agent-setup` passes. After changing packages, regenerate the lock file from a tested install with `M-x elpaca-write-lock-file`, and update the Elpaca commit pinned in `init.el` to the one it records.

## Customize

Put your own settings in `~/.config/agent-emacs/user.el`. It is loaded last and ignored by git, so updates never conflict with it. For example, to use several Claude accounts:

```elisp
(setq agent-claude-accounts '(("personal" . "~/.claude-personal")
                              ("work"     . "~/.claude-work")))
```

See the [`agent` manual](https://github.com/benthamite/agent) for every option.

## Control sessions from your phone

Agent Emacs can serve a page that lists your sessions and lets you read their output, reply, send keys, and start, restart or exit sessions from your phone. It is off by default. It works over [Tailscale](https://tailscale.com), which must be installed and logged in on both the Mac and the phone, in the same tailnet.

1. Add this line to `~/.config/agent-emacs/user.el` and restart Agent Emacs:

   ```elisp
   (agent-remote-mode 1)
   ```

2. Find the Mac's Tailscale address with `tailscale ip -4` (it starts with `100.`).
3. On the phone, open `http://<that address>:8787/` in a browser, or install the [Android app](https://github.com/benthamite/agent/releases/latest/download/agent-remote.apk) and enter the address when it asks.

Only devices in your tailnet can reach the page, and there is no other login, so never share your tailnet with people you would not hand your Mac to. The Android app is built from the `android/` directory of the [`agent`](https://github.com/benthamite/agent) package; see its manual to build it yourself.

## What is included

- **Agents**: [agent](https://github.com/benthamite/agent), [claude-code.el](https://github.com/stevemolitor/claude-code.el), [monet](https://github.com/stevemolitor/monet) (lets Claude Code open diffs and files in Emacs), [codex](https://github.com/benthamite/codex), [agent-log](https://github.com/benthamite/agent-log) (readable logs of past sessions), [eat](https://codeberg.org/akib/emacs-eat) (terminal).
- **Editing**: [vertico](https://github.com/minad/vertico), [orderless](https://github.com/oantolin/orderless), [marginalia](https://github.com/minad/marginalia), [corfu](https://github.com/minad/corfu), [consult](https://github.com/minad/consult), [magit](https://magit.vc), [markdown-mode](https://github.com/jrblevin/markdown-mode), [alert](https://github.com/jwiegley/alert).
- **Appearance**: [doom-modeline](https://github.com/seagle0128/doom-modeline) (mode line, including each session's model, effort and account), [spacious-padding](https://github.com/protesilaos/spacious-padding), the tinted Modus themes.
- **Built in**: Modus themes, which-key, project.el, recent files, history and cursor-position saving.

Everything is in two short files, [`early-init.el`](early-init.el) and [`init.el`](init.el).
