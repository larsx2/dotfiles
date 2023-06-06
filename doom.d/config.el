;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Eduardo Urias"
      user-mail-address "edw.urias@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'omtose-darker)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;https://github.com/tecosaur/emacs-config/pulse;

(map! :leader
      (:prefix-map ("j" . "jump")
        (:prefix-map ("o" . "other")
          :desc "Jump to definition in other window" "d" #'xref-find-definitions-other-window)

       :desc "Find definition" "d" #'lsp-find-definition
       :desc "Find references" "r" #'lsp-find-references
       :desc "Find implementation" "i" #'lsp-find-implementation
       :desc "Peek references" "R" #'lsp-ui-peek-find-references
       :desc "Peek definition" "D" #'lsp-ui-peek-find-definitions
       :desc "Peek implementation" "I" #'lsp-ui-peek-find-implementation
       :desc "Peek type definition" "t" #'+lookup/type-definition
       :desc "Jump to line" "l" #'avy-goto-line
       :desc "Jump to timer" "j" #'avy-goto-char-timer
       :desc "Jump to char 2" "s" #'avy-goto-char-2
       :desc "Jump to word" "w" #'avy-goto-word-1
       :desc "Jump to char" "c" #'avy-goto-char

       )

      (:prefix-map ("a" . "applications")
       :desc "Open lsp-ui menu" "m" #'lsp-ui-imenu
       :desc "Format lsp buffer" "=" #'lsp-format-buffer
       :desc "Rip grep " "/" #'consult-ripgrep
       (:prefix-map ("h" . "highlight")
        :desc "Next symbol occurrence" "n" #'embark-next-symbol
        :desc "Previous symbol occurrence" "p" #'embark-previous-symbol
        :desc "Highlight at point" "h" #'highlight-symbol-at-point
        :desc "Unhighlight at point" "u" #'unhighlight-regexp
        )
       )

      (:prefix-map ("e" . "errors")
       :desc "Show errors in buffer" "e" #'flycheck-list-errors
       :desc "Consult flycheck errors" "l" #'consult-flycheck
       :desc "Show errors in all workspace" "L" #'consult-lsp-diagnostics
       :desc "Show next error in buffer" "n" #'flycheck-next-error
       :desc "Show previous error in buffer" "p" #'flycheck-previous-error)
      )

;; lsp ui configurations
(after! lsp-ui
  (setq lsp-ui-peek-always-show t)
  (setq lsp-headerline-breadcrumb-enable t)
  (setq lsp-headerline-breadcrumb-icons-enable t))

(setq-hook! 'typescript-mode-hook +format-with-lsp nil)
(setq-hook! 'typescript-mode-hook +format-with #'prettier-mode)

;; fix mouse support inside tmux
(global-set-key [mouse-4] 'scroll-down-line)
(global-set-key [mouse-5] 'scroll-up-line)

;; do not show tool bar
(setq tool-bar-mode nil)

;; vterm configurations
;; disable evil mode on vterm
(add-hook 'vterm-mode-hook 'evil-emacs-state)
(setq vterm-kill-buffer-on-exit t)
(setq vterm-always-compile-module t)

;; override dired
(dirvish-override-dired-mode)

(use-package! lsp-tailwindcss)
