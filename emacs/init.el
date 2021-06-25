;; Load packages provided by Nix
(require 'package)

;; optional. makes unpure packages archives unavailable
(setq package-archives nil)

(setq package-enable-at-startup nil)
(package-initialize)

;; Disable useless stuff
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(setq inhibit-startup-message t)

(dashboard-setup-startup-hook)
(setq dashboard-banner-logo-title "Welcome back to Emacs !")
(setq dashboard-center-content t)
(setq dashboard-startup-banner 'logo)
(setq dashboard-items '((recents  . 5)
                        (bookmarks . 5)
                        (projects . 5)
                        (agenda . 5)
                        (registers . 5)))

(setq dashboard-set-heading-icons t)
(setq dashboard-set-file-icons t)
(setq dashboard-set-navigator t)

;; Global page break doesnt work sadly for me
(add-hook 'buffer-list-update-hook 'page-break-lines-mode)

;; Resize to pixels <3
(setq frame-resize-pixelwise t)

;; Set default font
(set-face-attribute 'default nil :font "Source Code Pro 13")

(if (>= emacs-major-version 27)
    (set-fontset-font t '(#x1f000 . #x1faff)
		      (font-spec :family "Noto Color Emoji")))

;; Theme related stuff
(custom-set-variables
 '(custom-safe-themes
   '("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "402eea0f7f9a150eb52c4936f486045aaef62066743cca314868684102347350" default)))
(custom-set-faces
 )

(load-theme 'spacemacs-dark)

;; Modeline
(doom-modeline-mode 1)
(size-indication-mode)
(display-time-mode 1)
(setq display-time-24hr-format t)

;; Vim like keybindings
(evil-mode)

;; Enable which key
(which-key-mode)

;; Parens are nicer :)
(show-paren-mode)

;; LSP and Company
(add-hook 'prog-mode-hook 'global-company-mode)
(setq lsp-keymap-prefix "C-c l")
(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration))

;; LSP mode hook functions
(mapc
 (lambda (hook) (add-hook hook 'lsp))
 '(c-mode-hook c++-mode-hook python-mode-hook nix-mode-hook))

; Timings for company
(setq company-minimum-prefix-length 1
      company-idle-delay 0.0)

;; Enable Ivy
(ivy-mode)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(setq search-default-mode #'char-fold-to-regexp)

;; Every file should be opened with relative line numbers
(add-hook 'find-file-hook (lambda ()
  (display-line-numbers-mode)
  (setq display-line-numbers 'relative)))

;; Dired
(setq dired-listing-switches "-alh")
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

;; Racket-mode
(add-hook 'racket-mode-hook 'racket-xp-mode)

;; Fix the backup mess !!
; Curently saving it into /tmp so that they are cleaned from time to time
(setq backup-directory-alist `(("." . ,(expand-file-name "emacs/backups" "/tmp"))))

;; Colored eshell
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(add-to-list 'comint-output-filter-functions 'ansi-color-process-output)
(setenv "TERM" "xterm-256color")

;; Makes line wrap nicer in markdown languages
(mapc
 (lambda (hook) (add-hook hook 'visual-line-mode))
 '(markdown-mode-hook latex-mode-hook))

;; Pretty symbols
; Not sure about them yet
(setq prettify-symbols-alist
      '(
	("lambda" . "λ")
	("->" . "➔")
	("<=" . "≤")
	(">=" . "≥")
	("!=" . "≠")
	;(":)" . "🙂")
	))

(add-hook 'prog-mode-hook 'prettify-symbols-mode)

;; Recenter view around cursor
;(add-hook 'post-command-hook 'recenter)

;; Keybindings
(load "~/.emacs.d/keybindings.el")
