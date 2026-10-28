((agent :source "elpaca-menu-lock-file" :recipe
        (:source "Init file" :package "agent" :id agent :host github :repo
                 "benthamite/agent" :type git :protocol https :inherit t :depth
                 treeless :ref "96493a811eb30e814b6e3d967d9fd51727868920"))
 (agent-log :source "elpaca-menu-lock-file" :recipe
            (:source "Init file" :package "agent-log" :id agent-log :host github
                     :repo "benthamite/agent-log" :type git :protocol https
                     :inherit t :depth treeless :ref
                     "cd7285000ef5295f013dfda35d945b5f77dc4eb5"))
 (alert :source "elpaca-menu-lock-file" :recipe
        (:package "alert" :fetcher github :repo "jwiegley/alert" :files
                  ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                   "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                   "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                   "docs/*.texinfo"
                   (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                             "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                  :source "MELPA" :id alert :type git :protocol https :inherit t
                  :depth treeless :ref
                  "31fc56855289d0846e73d7ca9b84b628aeac16a0"))
 (claude-code :source "elpaca-menu-lock-file" :recipe
              (:package "claude-code" :fetcher github :repo
                        "stevemolitor/claude-code.el" :files
                        ("*.el" (:exclude "images/*")) :source "MELPA" :id
                        claude-code :host github :branch "main" :type git
                        :protocol https :inherit t :depth treeless :ref
                        "03199df8b3a1e9cd4857f0851f7a912ba524aff3"))
 (codex :source "elpaca-menu-lock-file" :recipe
        (:source "Init file" :package "codex" :id codex :host github :repo
                 "benthamite/codex" :type git :protocol https :inherit t :depth
                 treeless :ref "6981e418588a264bd41be0afba4084a8a72411ab"))
 (compat :source "elpaca-menu-lock-file" :recipe
         (:package "compat" :repo
                   ("https://github.com/emacs-compat/compat" . "compat") :tar
                   "31.1.0.0" :host gnu :files ("*" (:exclude ".git")) :source
                   "GNU ELPA" :id compat :type git :protocol https :inherit t
                   :depth treeless :ref
                   "90880f81419577e1d3f68424d2a3adf31e6d663e"))
 (cond-let
   :source "elpaca-menu-lock-file" :recipe
   (:package "cond-let" :fetcher github :repo "tarsius/cond-let" :files
             ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
              "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el" "docs/dir"
              "docs/*.info" "docs/*.texi" "docs/*.texinfo"
              (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                        "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
             :source "MELPA" :id cond-let :type git :protocol https :inherit t
             :depth treeless :ref "09292a77001434f59ab55c775dec2b98cb18d028"))
 (consult :source "elpaca-menu-lock-file" :recipe
          (:package "consult" :repo "minad/consult" :fetcher github :files
                    ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                     "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                     "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                     "docs/*.texinfo"
                     (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                               "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                    :source "MELPA" :id consult :type git :protocol https
                    :inherit t :depth treeless :ref
                    "e1183ed28bd921974b13c4bef2c7a8289607ddc3"))
 (corfu :source "elpaca-menu-lock-file" :recipe
        (:package "corfu" :repo "minad/corfu" :files
                  (:defaults "extensions/corfu-*.el") :fetcher github :source
                  "MELPA" :id corfu :type git :protocol https :inherit t :depth
                  treeless :ref "b468efac023dda39332acc943edc9895c80b5a6f"))
 (dash :source "elpaca-menu-lock-file" :recipe
       (:package "dash" :fetcher github :repo "magnars/dash.el" :files
                 ("dash.el" "dash.texi") :source "MELPA" :id dash :type git
                 :protocol https :inherit t :depth treeless :ref
                 "d746dd9edcb67a108818beb0cdc78dc1cb466832"))
 (doom-modeline :source "elpaca-menu-lock-file" :recipe
                (:package "doom-modeline" :repo "seagle0128/doom-modeline"
                          :fetcher github :files
                          ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                           "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                           "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                           "docs/*.texinfo"
                           (:exclude ".dir-locals.el" "test.el" "tests.el"
                                     "*-test.el" "*-tests.el" "LICENSE"
                                     "README*" "*-pkg.el"))
                          :source "MELPA" :id doom-modeline :type git :protocol
                          https :inherit t :depth treeless :ref
                          "f80a74fdea1734962ee91678ae68b6bcd3d1c450"))
 (eat :source "elpaca-menu-lock-file" :recipe
      (:package "eat" :repo "benthamite/emacs-eat" :tar "0.9.4" :host codeberg
                :files
                ("*.el" ("term" "term/*.el") "*.texi" "*.ti"
                 ("terminfo/e" "terminfo/e/*") ("terminfo/65" "terminfo/65/*")
                 ("integration" "integration/*")
                 (:exclude ".dir-locals.el" "*-tests.el"))
                :source "NonGNU ELPA" :id eat :branch
                "fix-mouse-input-after-buffer-kill" :type git :protocol https
                :inherit t :depth treeless :ref
                "d355673df4ba26c1232ecdd2558b62872afa4d69"))
 (elpaca :source
   "elpaca-menu-lock-file" :recipe
   (:source "Init file" :package "elpaca" :id elpaca :repo
            "https://github.com/progfolio/elpaca.git" :ref
            "3f02e31ef6d4fb661e8708995391337e8994dde7" :depth 1 :inherit ignore
            :files (:defaults "elpaca-test.el" (:exclude "extensions")) :build
            (:not elpaca-activate) :type git :protocol https))
 (elpaca-use-package :source "elpaca-menu-lock-file" :recipe
                     (:package "elpaca-use-package" :wait t :repo
                               "https://github.com/progfolio/elpaca.git" :files
                               ("extensions/elpaca-use-package.el") :main
                               "extensions/elpaca-use-package.el" :build
                               (:not elpaca-source elpaca-build-docs) :source
                               "Elpaca extensions" :id elpaca-use-package :type
                               git :protocol https :inherit t :depth treeless
                               :ref "3f02e31ef6d4fb661e8708995391337e8994dde7"))
 (f :source "elpaca-menu-lock-file" :recipe
    (:package "f" :fetcher github :repo "rejeep/f.el" :files
              ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
               "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el" "docs/dir"
               "docs/*.info" "docs/*.texi" "docs/*.texinfo"
               (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                         "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
              :source "MELPA" :id f :type git :protocol https :inherit t :depth
              treeless :ref "931b6d0667fe03e7bf1c6c282d6d8d7006143c52"))
 (gntp :source "elpaca-menu-lock-file" :recipe
       (:package "gntp" :repo "tekai/gntp.el" :fetcher github :files
                 ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
                  "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el"
                  "docs/dir" "docs/*.info" "docs/*.texi" "docs/*.texinfo"
                  (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                            "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                 :source "MELPA" :id gntp :type git :protocol https :inherit t
                 :depth treeless :ref "767571135e2c0985944017dc59b0be79af222ef5"))
 (inheritenv :source "elpaca-menu-lock-file" :recipe
             (:package "inheritenv" :fetcher github :repo "purcell/inheritenv"
                       :files
                       ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                        "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                        "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                        "docs/*.texinfo"
                        (:exclude ".dir-locals.el" "test.el" "tests.el"
                                  "*-test.el" "*-tests.el" "LICENSE" "README*"
                                  "*-pkg.el"))
                       :source "MELPA" :id inheritenv :type git :protocol https
                       :inherit t :depth treeless :ref
                       "b9e67cc20c069539698a9ac54d0e6cc11e616c6f"))
 (llama :source "elpaca-menu-lock-file" :recipe
        (:package "llama" :fetcher github :repo "tarsius/llama" :files
                  ("llama.el" ".dir-locals.el") :source "MELPA" :id llama :type
                  git :protocol https :inherit t :depth treeless :ref
                  "6850d0c91b629da14fdff2300c222289d1a0029a"))
 (log4e :source "elpaca-menu-lock-file" :recipe
        (:package "log4e" :repo "aki2o/log4e" :fetcher github :files
                  ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                   "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                   "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                   "docs/*.texinfo"
                   (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                             "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
                  :source "MELPA" :id log4e :type git :protocol https :inherit t
                  :depth treeless :ref
                  "6d71462df9bf595d3861bfb328377346aceed422"))
 (magit :source "elpaca-menu-lock-file" :recipe
        (:package "magit" :fetcher github :repo "magit/magit" :files
                  ("lisp/magit*.el" "lisp/git-*.el" "docs/magit.texi"
                   "docs/AUTHORS.md" "LICENSE" ".dir-locals.el"
                   ("githooks" "githooks/*") ("git-hooks" "git-hooks/*")
                   (:exclude "lisp/magit-section.el"))
                  :source "MELPA" :id magit :type git :protocol https :inherit t
                  :depth treeless :ref
                  "62373ca1667ecd8e33ed33f0335c2dec91f54dfe"))
 (magit-section :source "elpaca-menu-lock-file" :recipe
                (:package "magit-section" :fetcher github :repo "magit/magit"
                          :files
                          ("lisp/magit-section.el" "docs/magit-section.texi"
                           "magit-section-pkg.el")
                          :source "MELPA" :id magit-section :type git :protocol
                          https :inherit t :depth treeless :ref
                          "62373ca1667ecd8e33ed33f0335c2dec91f54dfe"))
 (marginalia :source "elpaca-menu-lock-file" :recipe
             (:package "marginalia" :repo "minad/marginalia" :fetcher github
                       :files
                       ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                        "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                        "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                        "docs/*.texinfo"
                        (:exclude ".dir-locals.el" "test.el" "tests.el"
                                  "*-test.el" "*-tests.el" "LICENSE" "README*"
                                  "*-pkg.el"))
                       :source "MELPA" :id marginalia :type git :protocol https
                       :inherit t :depth treeless :ref
                       "42eafcfddbe88d92ed96521a00a5a90a49bac4dd"))
 (markdown-mode :source "elpaca-menu-lock-file" :recipe
                (:package "markdown-mode" :fetcher github :repo
                          "jrblevin/markdown-mode" :files
                          ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                           "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                           "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                           "docs/*.texinfo"
                           (:exclude ".dir-locals.el" "test.el" "tests.el"
                                     "*-test.el" "*-tests.el" "LICENSE"
                                     "README*" "*-pkg.el"))
                          :source "MELPA" :id markdown-mode :type git :protocol
                          https :inherit t :depth treeless :ref
                          "76cb4ffecfdf95ee769e5cb4608e04202c3c1521"))
 (monet :source "elpaca-menu-lock-file" :recipe
        (:source "Init file" :package "monet" :id monet :host github :repo
                 "stevemolitor/monet" :type git :protocol https :inherit t
                 :depth treeless :ref "ee2e35557e8ae07de842c435486f7c152f3750e0"))
 (nerd-icons :source "elpaca-menu-lock-file" :recipe
             (:package "nerd-icons" :repo "rainstormstudio/nerd-icons.el"
                       :fetcher github :files (:defaults "data") :source "MELPA"
                       :id nerd-icons :type git :protocol https :inherit t
                       :depth treeless :ref
                       "17faac7977242b470732efd417d3bcc8eb5a830e"))
 (orderless :source "elpaca-menu-lock-file" :recipe
            (:package "orderless" :repo "oantolin/orderless" :fetcher github
                      :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source "MELPA" :id orderless :type git :protocol https
                      :inherit t :depth treeless :ref
                      "3d2c2e6468ddf51e69c78e8212e5fd9006d2ce8a"))
 (s :source "elpaca-menu-lock-file" :recipe
    (:package "s" :fetcher github :repo "magnars/s.el" :files
              ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo" "doc/dir"
               "doc/*.info" "doc/*.texi" "doc/*.texinfo" "lisp/*.el" "docs/dir"
               "docs/*.info" "docs/*.texi" "docs/*.texinfo"
               (:exclude ".dir-locals.el" "test.el" "tests.el" "*-test.el"
                         "*-tests.el" "LICENSE" "README*" "*-pkg.el"))
              :source "MELPA" :id s :type git :protocol https :inherit t :depth
              treeless :ref "d7c04b84d03481a1ed62ee13dbe595224ccbe57c"))
 (shrink-path :source "elpaca-menu-lock-file" :recipe
              (:package "shrink-path" :fetcher gitlab :repo
                        "bennya/shrink-path.el" :files
                        ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                         "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                         "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                         "docs/*.texinfo"
                         (:exclude ".dir-locals.el" "test.el" "tests.el"
                                   "*-test.el" "*-tests.el" "LICENSE" "README*"
                                   "*-pkg.el"))
                        :source "MELPA" :id shrink-path :type git :protocol
                        https :inherit t :depth treeless :ref
                        "c14882c8599aec79a6e8ef2d06454254bb3e1e41"))
 (spacious-padding :source "elpaca-menu-lock-file" :recipe
                   (:package "spacious-padding" :repo
                             ("https://github.com/protesilaos/spacious-padding"
                              . "spacious-padding")
                             :tar "0.9.0" :host gnu :files
                             ("*" (:exclude ".git" "COPYING" "doclicense.texi"))
                             :source "GNU ELPA" :id spacious-padding :type git
                             :protocol https :inherit t :depth treeless :ref
                             "9d96d301d5bccf192daaf00dba64bca9979dcb5a"))
 (transient :source "elpaca-menu-lock-file" :recipe
            (:package "transient" :fetcher github :repo "magit/transient" :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source "MELPA" :id transient :type git :protocol https
                      :inherit t :depth treeless :ref
                      "c886106bd506c4629ece352732f735657605cddb"))
 (vertico :source "elpaca-menu-lock-file" :recipe
          (:package "vertico" :repo "minad/vertico" :files
                    (:defaults "extensions/vertico-*.el") :fetcher github
                    :source "MELPA" :id vertico :type git :protocol https
                    :inherit t :depth treeless :ref
                    "a9998a777f1d92348f84d091bb15b87df933a7a2"))
 (websocket :source "elpaca-menu-lock-file" :recipe
            (:package "websocket" :repo "ahyatt/emacs-websocket" :fetcher github
                      :files
                      ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                       "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                       "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                       "docs/*.texinfo"
                       (:exclude ".dir-locals.el" "test.el" "tests.el"
                                 "*-test.el" "*-tests.el" "LICENSE" "README*"
                                 "*-pkg.el"))
                      :source "MELPA" :id websocket :type git :protocol https
                      :inherit t :depth treeless :ref
                      "2195e1247ecb04c30321702aa5f5618a51c329c5"))
 (with-editor :source "elpaca-menu-lock-file" :recipe
              (:package "with-editor" :fetcher github :repo "magit/with-editor"
                        :files
                        ("*.el" "*.el.in" "dir" "*.info" "*.texi" "*.texinfo"
                         "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
                         "lisp/*.el" "docs/dir" "docs/*.info" "docs/*.texi"
                         "docs/*.texinfo"
                         (:exclude ".dir-locals.el" "test.el" "tests.el"
                                   "*-test.el" "*-tests.el" "LICENSE" "README*"
                                   "*-pkg.el"))
                        :source "MELPA" :id with-editor :type git :protocol
                        https :inherit t :depth treeless :ref
                        "ca956bbfd1c9f163d2a8390716fcd39799d23f34")))
