# Agent Emacs

An Emacs set up for one job: running AI coding agents — [Claude Code](https://code.claude.com) and [Codex](https://developers.openai.com/codex) — side by side, with every session one keystroke away.

It is built around the [`agent`](https://github.com/benthamite/agent) package and comes with the defaults Emacs should have had all along: no backup clutter, a theme that follows your system's light or dark mode, the usual Mac shortcuts, modern completion, and files that refresh when an agent changes them.

It runs as its own Emacs instance, so it does not touch any Emacs configuration you already have.

## Install (macOS)

With [Homebrew](https://brew.sh) installed, run this in a terminal:

```sh
curl -fsSL https://raw.githubusercontent.com/benthamite/agent-emacs/main/install.sh | sh
```

It installs whatever is missing, asks to log you in to Claude Code and Codex, and starts Agent Emacs. The first start builds its packages, which takes a few minutes. After that, open Agent Emacs from Spotlight or Launchpad, or run `agent-emacs` in a terminal.

<details>
<summary>What the installer does</summary>

- Installs [Emacs+](https://github.com/d12frosted/homebrew-emacs-plus) on an Apple Silicon Mac with macOS 15 or later, and the standard Emacs app elsewhere. An Emacs 30 or later already in `/Applications` is kept.
- Installs Claude Code, Codex, `coreutils` and the Iosevka and Symbols Nerd fonts, unless you already have them.
- Puts Agent Emacs in `~/.config/agent-emacs`, an `Agent Emacs` app in `~/Applications`, and the `agent-emacs` command in `~/.local/bin` when that folder is on your `PATH`.

On its first start, Agent Emacs offers to link three skills into `~/.claude/skills` and `~/.codex/skills`: `handoff`, which the menu's handoff command needs, and two that let one session read or message another. It never replaces a skill of yours with the same name, and it never edits your Claude Code settings.
</details>

## Use

Agent Emacs opens split into two columns: the left one for your first session, the right one listing the main keys (`M-x agent-emacs-welcome` shows them again). Sessions appear as tabs along the top, coloured while they wait for you, and a notification tells you when an agent finishes.

Keys are written the Emacs way:

| Written as | Modifier | Mac key | Example |
|------------|----------|---------|---------|
| `C-` | Control | Control | `C-s` searches this file |
| `M-` | Meta | Option | `M-x` runs any command by name |
| `H-` | Hyper | Left Command | `H-c` copies, as Cmd-C does in any Mac app |
| `s-` | Super | Right Command | `s-c` finishes a commit message |
| `S-` | Shift | Shift | `S-RET` starts a new line in a prompt |

- **Selecting text** works as in any Mac app: Shift with the arrow keys, adding Option to go by word or Cmd to go to the end of the line or file, or drag with the mouse. Typing replaces the selection.
- **Esc cancels** anything. In a terminal it goes to the program instead. If Emacs itself stops responding, press `C-g`.
- **Not sure what comes next?** Type a key such as `C-x` and pause: a list of every key that can follow pops up.
- **Quit** with `C-x C-c`.

The right Option key still types accented characters.

## Your first hour

1. Press `H-f`, open any file in the project you want to work on, and press `H-e n`. The session starts in that file's project, or in its folder if it is not in a project. There is no folder prompt, so open something in the right place first.
2. Type your request and press `RET` to send it; `S-RET` starts a new line instead. A tab along the top shows the session's state; the green colour means it stopped and is waiting for you, whether it needs an answer or finished some time ago.
3. Press `H-e w` to reach the next session waiting for you, or `H-e s` to choose one.
4. To finish, press `H-e x`. It runs your closing skills, if you set any, and then closes the session.

Two things surprise most people at first:

- **Past chats open read-only.** `H-e l` opens the history menu, for browsing and searching past chats. To continue one, press `H-e r`, which resumes a session.
- **Keys in a chat go to the agent.** The editing keys work as in a Mac text field: Option and Cmd arrows, Cmd-Backspace, Cmd-V, Cmd-Z, and a single Esc to interrupt. Clicking on the line with the cursor moves the cursor there.

## Update

Run the install command again, then restart Agent Emacs. Package versions are pinned in `lockfile.el`, so everyone runs the versions this configuration was tested with. When an update changes those versions, the next start installs them afresh, which takes a few minutes, and removes the old ones.

## Customize

Put your own settings in `~/.config/agent-emacs/user.el`. It is loaded last and ignored by git, so updates never conflict with it. For example, to use several Claude accounts:

```elisp
(setq agent-claude-accounts '(("personal" . "~/.claude-personal")
                              ("work"     . "~/.claude-work")))
```

The launcher starts Emacs from a clean environment, so sessions do not inherit variables from the terminal app you ran it in. `PATH`, `CODEX_HOME` and `CLAUDE_CONFIG_DIR` come from your login shell.

See the [`agent` manual](https://github.com/benthamite/agent) for every option.

## Control sessions from your phone

Agent Emacs can serve a page that lists your sessions and lets you read their output, reply, send keys, and start, restart or exit sessions from your phone. It is off by default. It works over [Tailscale](https://tailscale.com), which must be installed and logged in on both the Mac and the phone, in the same tailnet.

1. Add this line to `~/.config/agent-emacs/user.el` and restart Agent Emacs:

   ```elisp
   (agent-remote-mode 1)
   ```

2. Find the Mac's Tailscale address with `tailscale ip -4` (it starts with `100.`).
3. On the phone, open `http://<that address>:8787/` in a browser, or install the [Android app](https://github.com/benthamite/agent/releases/download/android-v1.3/agent-remote.apk) and enter the address when it asks.

Only devices in your tailnet can reach the page, and there is no other login, so never share your tailnet with people you would not hand your Mac to. The Android app is built from the `android/` directory of the [`agent`](https://github.com/benthamite/agent) package; see its manual to build it yourself.

## What is included

- **Agents**: [agent](https://github.com/benthamite/agent), [claude-code.el](https://github.com/stevemolitor/claude-code.el), [monet](https://github.com/stevemolitor/monet) (lets Claude Code open diffs and files in Emacs), [codex](https://github.com/benthamite/codex), [agent-log](https://github.com/benthamite/agent-log) (readable logs of past sessions), [eat](https://codeberg.org/akib/emacs-eat) (terminal).
- **Editing**: [vertico](https://github.com/minad/vertico), [orderless](https://github.com/oantolin/orderless), [marginalia](https://github.com/minad/marginalia), [corfu](https://github.com/minad/corfu), [consult](https://github.com/minad/consult), [magit](https://magit.vc), [markdown-mode](https://github.com/jrblevin/markdown-mode), [alert](https://github.com/jwiegley/alert).
- **Appearance**: [doom-modeline](https://github.com/seagle0128/doom-modeline) (mode line, including each session's model, effort and account), [spacious-padding](https://github.com/protesilaos/spacious-padding), [nerd-icons-dired](https://github.com/rainstormstudio/nerd-icons-dired) (icons in Dired), the tinted Modus themes.
- **Built in**: Modus themes, which-key, project.el, recent files, history and cursor-position saving.

The whole configuration is in [`early-init.el`](early-init.el) and [`init.el`](init.el).

## Develop

`test/smoke-test.sh` installs Agent Emacs from scratch in a throwaway home directory and checks that every package is at its locked commit, that startup is clean and that `agent-setup` passes. After changing packages, regenerate the lock file from a tested install with `M-x elpaca-write-lock-file`, and update the Elpaca commit pinned in `init.el` to the one it records. `install.sh` reads the `AGENT_EMACS_*` variables listed at its top, to install into throwaway folders.
