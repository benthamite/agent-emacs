;;; init.el --- Agent Emacs: an Emacs for working with AI coding agents -*- lexical-binding: t -*-

;;; Commentary:

;; A small, opinionated Emacs configuration built around the `agent'
;; package: Claude Code and Codex sessions inside Emacs, with sane
;; defaults so that Emacs itself stays out of the way.
;;
;; Personal settings go in `user.el' next to this file; it is loaded
;; last and is not tracked by git.

;;; Code:

;;;; Package manager

;; The official Elpaca installer (https://github.com/progfolio/elpaca),
;; pinned to the commit recorded in lockfile.el.  The full clone (:depth
;; nil) is needed to check out a commit that is not the branch tip.
(defvar elpaca-installer-version 0.12)
(defconst agent-emacs-lock-file (expand-file-name "lockfile.el" user-emacs-directory)
  "Lock file recording the package versions this configuration was tested with.")

(defconst agent-emacs-packages-root (expand-file-name "elpaca/" user-emacs-directory)
  "Directory holding one package directory per lock file version.")

;; Packages are installed in a directory named after the lock file's
;; contents.  Elpaca never moves installed packages to new locked commits,
;; so an update that changes the lock file installs into a fresh directory.
(defvar elpaca-directory
  (expand-file-name
   (if (file-exists-p agent-emacs-lock-file)
       (substring (with-temp-buffer
                    (insert-file-contents-literally agent-emacs-lock-file)
                    (secure-hash 'sha1 (current-buffer)))
                  0 12)
     "unlocked")
   agent-emacs-packages-root))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-sources-directory (expand-file-name "sources/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref "3f02e31ef6d4fb661e8708995391337e8994dde7" :depth nil :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca-activate)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-sources-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; Install the exact package versions this configuration was tested with.
(when (file-exists-p agent-emacs-lock-file)
  (setq elpaca-lock-file agent-emacs-lock-file))

(defun agent-emacs-remove-old-packages ()
  "Delete package directories left by earlier lock file versions."
  (dolist (directory (directory-files agent-emacs-packages-root t "\\`[^.]"))
    (unless (or (not (file-directory-p directory))
                (file-equal-p directory elpaca-directory))
      (delete-directory directory t))))

(add-hook 'elpaca-after-init-hook #'agent-emacs-remove-old-packages)

(elpaca elpaca-use-package
  (elpaca-use-package-mode))
(elpaca-wait)

(setq use-package-always-ensure t)

;;;; Where Emacs keeps its own files

(defconst agent-emacs-var-directory
  (expand-file-name "var/" user-emacs-directory)
  "Directory for state Emacs writes: backups, auto-saves, history.")

(make-directory (expand-file-name "auto-save/" agent-emacs-var-directory) t)

(setq custom-file (expand-file-name "custom.el" agent-emacs-var-directory)
      backup-directory-alist `(("." . ,(expand-file-name "backups/" agent-emacs-var-directory)))
      auto-save-file-name-transforms `((".*" ,(expand-file-name "auto-save/" agent-emacs-var-directory) t))
      auto-save-list-file-prefix (expand-file-name "auto-save/sessions-" agent-emacs-var-directory)
      create-lockfiles nil
      recentf-save-file (expand-file-name "recentf" agent-emacs-var-directory)
      savehist-file (expand-file-name "history" agent-emacs-var-directory)
      save-place-file (expand-file-name "places" agent-emacs-var-directory)
      project-list-file (expand-file-name "projects" agent-emacs-var-directory)
      transient-history-file (expand-file-name "transient/history.el" agent-emacs-var-directory)
      transient-levels-file (expand-file-name "transient/levels.el" agent-emacs-var-directory)
      transient-values-file (expand-file-name "transient/values.el" agent-emacs-var-directory))

;;;; Sane defaults

(use-package emacs
  :ensure nil
  :custom
  (ring-bell-function #'ignore)
  (use-short-answers t)
  (initial-scratch-message nil)
  (confirm-kill-emacs #'yes-or-no-p)
  (sentence-end-double-space nil)
  (require-final-newline t)
  (indent-tabs-mode nil)
  (tab-width 4)
  (fill-column 80)
  (scroll-conservatively 101)
  (scroll-margin 2)
  (mouse-wheel-progressive-speed nil)
  (enable-recursive-minibuffers t)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (help-window-select t)
  (kill-do-not-save-duplicates t)
  (save-interprogram-paste-before-kill t)
  (global-auto-revert-non-file-buffers t)
  (auto-revert-verbose nil)
  (dired-kill-when-opening-new-dired-buffer t)
  (dired-dwim-target t)
  (vc-follow-symlinks t)
  :config
  ;; Agents edit files behind Emacs's back: show their changes at once.
  (global-auto-revert-mode 1)
  (delete-selection-mode 1)
  (recentf-mode 1)
  (savehist-mode 1)
  (save-place-mode 1)
  (column-number-mode 1)
  (pixel-scroll-precision-mode 1)
  (context-menu-mode 1)
  (repeat-mode 1)
  (which-key-mode 1)
  (when (file-exists-p custom-file)
    (load custom-file nil t)))

;;;; macOS

(when (eq system-type 'darwin)
  ;; Option is Meta and Command is Super, so the usual Command shortcuts
  ;; (Cmd-C, Cmd-V, Cmd-Z, Cmd-S, Cmd-Q) work.  The right Option key is
  ;; left to macOS for typing accented and special characters.
  (setq mac-option-modifier 'meta
        mac-command-modifier 'super
        mac-right-option-modifier 'none)
  ;; macOS `ls' does not support --dired.
  (setq dired-use-ls-dired nil))

;; Apps launched from the Dock do not see the PATH set in the shell, so
;; `claude', `codex', `node' and `git' would not be found.  Ask the
;; user's login shell for its PATH and use it.
(defconst agent-emacs-shell-variables '("PATH" "CODEX_HOME" "CLAUDE_CONFIG_DIR")
  "Variables to take from the user's login shell, where they are set.")

(defun agent-emacs-import-shell-environment ()
  "Set `agent-emacs-shell-variables' from the user's interactive login shell.
Also set `exec-path' from PATH."
  (let* ((shell (or (getenv "SHELL") "/bin/zsh"))
         (script (mapconcat (lambda (name)
                              (format "printf '__ENV__%s=%%s\\n' \"$%s\"" name name))
                            agent-emacs-shell-variables "; "))
         (output (with-temp-buffer
                   (when (zerop (call-process shell nil t nil "-l" "-i" "-c" script))
                     (buffer-string)))))
    (dolist (name agent-emacs-shell-variables)
      (when (and output
                 (string-match (format "__ENV__%s=\\(.*\\)" name) output)
                 (not (string-empty-p (match-string 1 output))))
        (setenv name (match-string 1 output))))
    (setq exec-path (append (parse-colon-path (getenv "PATH"))
                            (list exec-directory)))))

(when (memq window-system '(mac ns))
  (agent-emacs-import-shell-environment))

;;;; Appearance

(defun agent-emacs-system-dark-p ()
  "Return non-nil when the operating system uses a dark appearance."
  (and (eq system-type 'darwin)
       (equal (string-trim
               (shell-command-to-string
                "defaults read -g AppleInterfaceStyle 2>/dev/null"))
              "Dark")))

;; The Modus themes ship with Emacs.  Their tinted variants soften the
;; background, and the intense preset colours the mode line.
(require-theme 'modus-themes)

(setq modus-themes-common-palette-overrides
      `((fringe unspecified)
        (bg-prose-block-delimiter bg-inactive)
        (fg-prose-block-delimiter gray)
        ,@modus-themes-preset-overrides-intense))

(defun agent-emacs-match-system-theme ()
  "Load the light or dark Modus theme to match the system appearance."
  (let ((theme (if (agent-emacs-system-dark-p)
                   'modus-vivendi-tinted
                 'modus-operandi-tinted)))
    (unless (memq theme custom-enabled-themes)
      (mapc #'disable-theme custom-enabled-themes)
      (load-theme theme t))))

(defun agent-emacs-style-faces (&rest _)
  "Style the tab bar and window dividers to go with the current theme."
  (let ((active (face-background 'mode-line-active nil t)))
    (set-face-attribute 'tab-bar nil :background active
                        :box `(:line-width 6 :color ,active :style nil)))
  ;; `spacious-padding' paints the dividers in the background colour,
  ;; which hides them.
  (custom-set-faces '(window-divider (( ))))
  (set-face-attribute 'window-divider nil
                      :foreground (face-background 'mode-line-inactive nil t)))

;; After the theme and `spacious-padding' have set their own faces.
(add-hook 'enable-theme-functions #'agent-emacs-style-faces 90)

(setq default-frame-alist
      (seq-remove (lambda (parameter)
                    (memq (car parameter) '(background-color foreground-color)))
                  default-frame-alist))
(agent-emacs-match-system-theme)
(when (eq system-type 'darwin)
  (run-with-timer 5 5 #'agent-emacs-match-system-theme))

;; Iosevka when it is installed (see the README), else Menlo, which every
;; Mac has.
(when (display-graphic-p)
  (cond ((member "Iosevka" (font-family-list))
         (set-face-attribute 'default nil :family "Iosevka" :height 120)
         (set-face-attribute 'fixed-pitch nil :family "Iosevka"))
        ((member "Menlo" (font-family-list))
         (set-face-attribute 'default nil :family "Menlo" :height 140))))

;; The tab bar lists the agent sessions and nothing else.
(setq tab-bar-format nil)
(tab-bar-mode 1)

(setq-default line-spacing 2)
(setq ns-use-thin-smoothing t
      window-divider-default-right-width 1)
(window-divider-mode 1)

;; Padding around the mode line, header line and tab bar.  The empty list
;; keeps the frame's own borders and dividers as they are.
(use-package spacious-padding
  :demand t
  :custom
  (spacious-padding-widths '())
  :config
  (spacious-padding-mode 1)
  (agent-emacs-style-faces))

(use-package doom-modeline
  :demand t
  :custom
  ;; The icons need the Symbols Nerd Font (see the README); without it
  ;; they would show as empty boxes.
  (doom-modeline-icon (and (member "Symbols Nerd Font Mono" (font-family-list)) t))
  :config
  (doom-modeline-mode 1))

;;;; Completion

(use-package vertico
  :demand t
  :config
  (vertico-mode 1))

(use-package orderless
  :demand t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :demand t
  :config
  (marginalia-mode 1))

;; Completion while typing in a buffer, such as the commands offered after
;; "/" in a Codex session, in a popup at the cursor.
(use-package corfu
  :demand t
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 3)
  (corfu-auto-delay 0.5)
  (corfu-cycle t)
  (corfu-quit-no-match t)
  :bind
  (:map corfu-map
        ("TAB" . nil)
        ("<tab>" . nil)
        ("RET" . corfu-complete)
        ("<return>" . corfu-complete))
  :config
  (global-corfu-mode 1)
  (corfu-history-mode 1))

(use-package consult
  :bind
  (("C-x b" . consult-buffer)
   ("C-x 4 b" . consult-buffer-other-window)
   ("M-y" . consult-yank-pop)
   ("M-g g" . consult-goto-line)
   ("M-g i" . consult-imenu)
   ("M-s r" . consult-ripgrep)
   ("M-s l" . consult-line)
   ("s-f" . consult-line)))

;;;; Dired

(use-package dired
  :ensure nil
  :hook
  ;; Start with file names alone; `(' shows the details.
  (dired-mode . dired-hide-details-mode)
  (dired-mode . hl-line-mode)
  :config
  ;; GNU `ls', from coreutils, can list directories first.
  (when (executable-find "gls")
    (setq insert-directory-program "gls"
          dired-use-ls-dired t
          dired-listing-switches
          "-AGFhlv --group-directories-first --time-style=long-iso")))

(defun agent-emacs-dired-icons ()
  "Show icons in Dired when their font is installed (see the README).
Without the font they would show as empty boxes."
  (when (member "Symbols Nerd Font Mono" (font-family-list))
    (nerd-icons-dired-mode 1)))

(use-package nerd-icons-dired
  :commands nerd-icons-dired-mode
  :hook
  (dired-mode . agent-emacs-dired-icons))

;;;; Git and Markdown

(use-package transient)

(use-package magit
  :bind
  ("C-x g" . magit-status))

(use-package markdown-mode
  :mode ("\\.md\\'" . gfm-mode))

;;;; Terminal

(use-package eat
  ;; A fork carrying a fix for mouse input after a buffer is killed,
  ;; pending upstream: https://codeberg.org/akib/emacs-eat/pulls/266
  :ensure (:host codeberg
           :repo "benthamite/emacs-eat"
           :branch "fix-mouse-input-after-buffer-kill"
           :files ("*.el" ("term" "term/*.el") "*.texi"
                   "*.ti" ("terminfo/e" "terminfo/e/*")
                   ("terminfo/65" "terminfo/65/*")
                   ("integration" "integration/*")
                   (:exclude ".dir-locals.el" "*-tests.el")))
  :custom
  (eat-term-name "xterm-256color")
  (eat-kill-buffer-on-exit t)
  :hook
  (eat-mode . agent-emacs-use-strict-monospace-font)
  (eat-mode . agent-emacs-disable-line-spacing)
  :config
  ;; `eat' only lightens the weight of faint text, which leaves Claude Code's
  ;; suggested prompt looking like something you typed.
  (set-face-attribute 'eat-term-faint nil :inherit 'shadow))

(defun agent-emacs-disable-line-spacing ()
  "Turn off line spacing in the current terminal buffer.
`eat' works out mouse rows from the font height alone, so the spacing
would make hovers and clicks land on the wrong row further down."
  (setq-local line-spacing nil))

(defun agent-emacs-resize-terminal-after-zoom ()
  "Fit the current terminal to the window after a zoom.
Zooming changes how many characters fit without changing the window, so
nothing else tells `eat' to redraw at the new width."
  (when (derived-mode-p 'eat-mode)
    (window--adjust-process-windows)))

(add-hook 'text-scale-mode-hook #'agent-emacs-resize-terminal-after-zoom)

(defconst agent-emacs-terminal-wheel-divisor 2
  "Forward one in this many mouse wheel events to a terminal program.
A trackpad gesture sends many events and programs scroll several lines
for each, which scrolls far too fast.")

(defvar-local agent-emacs-terminal-wheel-count 0
  "Mouse wheel events seen in this terminal since one was last forwarded.")

(defun agent-emacs-terminal-slow-wheel ()
  "Forward only some mouse wheel events to the current terminal's program."
  (interactive)
  (setq agent-emacs-terminal-wheel-count (1+ agent-emacs-terminal-wheel-count))
  (when (>= agent-emacs-terminal-wheel-count agent-emacs-terminal-wheel-divisor)
    (setq agent-emacs-terminal-wheel-count 0)
    (eat-self-input 1 last-input-event)))

(with-eval-after-load 'eat
  (dolist (map (list eat--mouse-click-mode-map
                     eat--mouse-modifier-click-mode-map))
    (dolist (key '("<wheel-up>" "<wheel-down>"
                   "<double-wheel-up>" "<double-wheel-down>"
                   "<triple-wheel-up>" "<triple-wheel-down>"))
      (keymap-set map key #'agent-emacs-terminal-slow-wheel))))

(defun agent-emacs-use-strict-monospace-font ()
  "Use Iosevka Fixed in the current buffer when Iosevka is the default font.
Iosevka draws some characters wider than one cell, which breaks line
wrapping in a terminal; Iosevka Fixed keeps every character to one cell."
  (when (and (equal (face-attribute 'default :family) "Iosevka")
             (member "Iosevka Fixed" (font-family-list)))
    (face-remap-add-relative 'default :family "Iosevka Fixed")))

(defun agent-emacs-escape-quit ()
  "Like `keyboard-escape-quit', but never delete other windows."
  (interactive)
  (let ((buffer-quit-function (or buffer-quit-function #'ignore)))
    (keyboard-escape-quit)))

(keymap-global-set "ESC ESC ESC" #'agent-emacs-escape-quit)

;;;; Mac editing keys in Claude chats

(defconst agent-emacs-chat-key-sequences
  '(("M-<left>" . "\eb")
    ("M-<right>" . "\ef")
    ("s-<left>" . "\C-a")
    ("s-<right>" . "\C-e")
    ("s-<backspace>" . "\C-u")
    ("s-z" . "\C-_")
    ("C-z" . "\C-_"))
  "Keys in a Claude chat and the bytes each sends to Claude Code.
Without these, the keys run Emacs commands that move Emacs's point but
not the cursor of Claude Code's input box.  `C-z' sends undo because the
suspend it would otherwise trigger leaves no shell to resume from.")

(defun agent-emacs-chat-send (sequence)
  "Return a command that sends SEQUENCE to the current chat's terminal."
  (lambda ()
    (interactive)
    (eat-term-send-string eat-terminal sequence)))

(defvar agent-emacs-chat-keymap
  (let ((map (make-sparse-keymap)))
    (pcase-dolist (`(,key . ,sequence) agent-emacs-chat-key-sequences)
      (keymap-set map key (agent-emacs-chat-send sequence)))
    ;; Sent on one press; `eat' otherwise waits for a second as a Meta prefix.
    (keymap-set map "<escape>" #'claude-code-send-escape)
    map)
  "Keys that apply in the semi-char input mode of a Claude chat.")

(defun agent-emacs-setup-chat-keys ()
  "Give the current Claude chat the Mac editing keys.
They override `eat' in this buffer alone, and only in its semi-char input
mode, so Codex terminals and other `eat' buffers keep their own keys."
  (set-keymap-parent agent-emacs-chat-keymap eat-semi-char-mode-map)
  (setq-local minor-mode-overriding-map-alist
              (cons (cons 'eat--semi-char-mode agent-emacs-chat-keymap)
                    minor-mode-overriding-map-alist)))

(add-hook 'claude-code-start-hook #'agent-emacs-setup-chat-keys)

(defun agent-emacs-chat-click-to-cursor (orig &rest args)
  "Move a Claude chat's cursor to a plain click on its line, else call ORIG.
ARGS are passed to ORIG.  Claude Code asks for mouse events but ignores
clicks in its input box, so this turns the click into arrow keys.  A
click on another line of a multi-line input still goes to Claude Code."
  (let* ((event last-input-event)
         (pos (and (mouse-event-p event)
                   (eq (event-basic-type event) 'mouse-1)
                   (null (seq-difference (event-modifiers event)
                                         '(click down double triple drag)))
                   (claude-code--buffer-p (current-buffer))
                   (posn-point (event-start event))))
         (cursor (and pos
                      (bound-and-true-p eat-terminal)
                      (marker-position (eat-term-display-cursor eat-terminal)))))
    (if (and cursor (= (line-number-at-pos pos) (line-number-at-pos cursor)))
        (when (and (memq 'click (event-modifiers event)) (/= pos cursor))
          (eat-term-input-event eat-terminal (abs (- pos cursor))
                                (if (> pos cursor) 'right 'left)))
      (apply orig args))))

(with-eval-after-load 'eat
  (advice-add 'eat-self-input :around #'agent-emacs-chat-click-to-cursor))

;;;; AI agents

(use-package alert
  :custom
  (alert-default-style (if (eq system-type 'darwin) 'osx-notifier 'notifications)))

(use-package claude-code
  :ensure (:host github :repo "stevemolitor/claude-code.el" :branch "main"
           :files ("*.el" (:exclude "images/*")))
  :custom
  ;; Show the new session in the selected window.
  (claude-code-display-window-fn (lambda (buffer) (switch-to-buffer buffer) nil))
  (claude-code-terminal-backend 'eat)
  (claude-code-optimize-window-resize nil)
  :bind-keymap
  ("C-c c" . claude-code-command-map))

(use-package monet
  :ensure (:host github :repo "stevemolitor/monet")
  :after claude-code
  :demand t
  :config
  (monet-mode 1)
  (add-hook 'claude-code-process-environment-functions
            #'monet-start-server-function))

(use-package codex
  :ensure (:host github :repo "benthamite/codex")
  :custom
  (codex-terminal-backend 'app-server))

(use-package agent
  :ensure (:host github :repo "benthamite/agent")
  :demand t
  :custom
  (agent-alert-on-ready t)
  (agent-sync-theme t)
  :bind
  (("C-c a" . agent-menu)
   ("C-c s" . agent-select-session)
   ("C-c w" . agent-jump-to-waiting))
  :config
  (require 'agent-claude)
  (require 'agent-codex)
  (agent-claude-mode 1)
  (agent-codex-mode 1)
  (agent-tab-bar-mode 1))

(use-package agent-log
  :ensure (:host github :repo "benthamite/agent-log")
  :after agent
  :demand t
  :custom
  (agent-log-auto-sync-sessions t))

;;;; Server

;; The Claude Code hooks report session state to Emacs through
;; `emacsclient'.  Use a server name of our own so that another Emacs
;; running a server does not collide with this one.
(require 'server)
(unless (daemonp)
  (setq server-name "agent-emacs")
  (unless (server-running-p server-name)
    (server-start)))

;;;; Welcome screen

(defconst agent-emacs-welcome-buffer-name "*Agent Emacs*"
  "Name of the welcome buffer.")

(defconst agent-emacs-setup-marker
  (expand-file-name "setup-done" agent-emacs-var-directory)
  "File whose existence records that first-run setup has been offered.")

(defun agent-emacs-welcome ()
  "Show the welcome buffer listing the main keys."
  (interactive)
  (with-current-buffer (get-buffer-create agent-emacs-welcome-buffer-name)
    (let ((inhibit-read-only t))
      (erase-buffer)
      (insert (propertize "Agent Emacs\n\n" 'face '(:height 1.5 :weight bold))
              "Agents\n"
              "  C-c a        agent menu: start, resume and manage sessions\n"
              "  C-c s        switch to a session\n"
              "  C-c w        jump to the next session waiting for you\n"
              "  C-c c        Claude Code commands\n"
              "  M-x agent-setup   check that everything agents need is installed\n\n"
              "Files and projects\n"
              "  C-x C-f      open a file          C-x b    switch buffer\n"
              "  C-x p f      file in project      C-x g    git status (Magit)\n"
              "  M-s r        search the project   s-f      search this buffer\n\n"
              "Getting around\n"
              "  C-g          cancel anything      C-/      undo\n"
              "  Cmd-C/V/Z/S  copy, paste, undo, save, as on any Mac app\n"
              "  C-x 0 / C-x 1 / C-x 2 / C-x 3   close / only / split windows\n"
              "  After a prefix key such as C-x, wait a moment to see what follows.\n"
              "  M-x agent-emacs-welcome   show this screen again\n"))
    (special-mode)
    (goto-char (point-min))
    (current-buffer)))

(setq initial-buffer-choice #'agent-emacs-welcome)

(defun agent-emacs-split-into-columns ()
  "Split the frame into two columns, to hold two sessions side by side.
The left column is empty and selected, so the first session opens there
while the welcome buffer stays in view on the right."
  (when (one-window-p)
    (set-window-buffer (split-window-right) (agent-emacs-welcome))
    (switch-to-buffer (get-scratch-buffer-create))))

(add-hook 'window-setup-hook #'agent-emacs-split-into-columns)

(defun agent-emacs-offer-setup ()
  "Run `agent-setup' the first time Agent Emacs starts."
  (unless (file-exists-p agent-emacs-setup-marker)
    (with-temp-file agent-emacs-setup-marker)
    (agent-setup)))

(add-hook 'elpaca-after-init-hook #'agent-emacs-offer-setup)

;;;; Personal settings

(let ((user-file (expand-file-name "user.el" user-emacs-directory)))
  (when (file-exists-p user-file)
    (add-hook 'elpaca-after-init-hook (lambda () (load user-file nil t)))))

;;; init.el ends here
