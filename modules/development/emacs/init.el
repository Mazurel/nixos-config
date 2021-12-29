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

;; Environemnt variables
(setenv "TERM" "emacs") ; Removes weird line characters

;; Modeline
(doom-modeline-mode 1)
(size-indication-mode)
(display-time-mode 1)
(setq display-time-24hr-format t)

;; Vim like keybindings
;(evil-mode)

(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev))
  (meow-leader-define-key
   ;; SPC j/k will run the original command in MOTION state.
   '("j" . "H-j")
   '("k" . "H-k")
   ;; Use SPC (0-9) for digit arguments.
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-kill)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-goto-line)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("Z" . meow-pop-grab)
   '("^" . meow-back-to-indentation)
   '("$" . meow-end-of-thing)
   '("'" . repeat)
   '("/" . swiper-isearch)
   '("<escape>" . mode-line-other-buffer)))

(require 'meow)
(meow-setup)
(meow-global-mode 1)
(add-to-list 'meow-mode-state-list '(cuda-mode . normal))

; Enable which key
(which-key-mode)

;; Parens are nicer :)
(show-paren-mode)

;; Tab size
(setq default-tab-width 4)
(setq tab-width 4)

;; LSP and Company
(add-hook 'prog-mode-hook 'global-company-mode)
(setq lsp-keymap-prefix "C-c l")
(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration))

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      company-minimum-prefix-length 1
      lsp-lens-enable t
      ;; Disable signatures at the bottom of the modeline, see: https://emacs-lsp.github.io/lsp-mode/tutorials/how-to-turn-off/
      lsp-eldoc-enable-hover nil
      lsp-signature-render-documentation nil
      lsp-signature-auto-activate nil)

;; LSP mode hook functions
(mapc
 (lambda (hook)
   (progn
     (add-hook hook 'lsp)))
 '(c-mode-hook c++-mode-hook python-mode-hook nix-mode-hook js-mode-hook dart-mode-hook))

; Timings for company
(setq company-minimum-prefix-length 1
      company-idle-delay 0.0)

;; Enable Ivy
(ivy-mode)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
; (setq search-default-mode #'char-fold-to-regexp)

;; Ido search
; TODO: Consider using it instead of ivy
; (ido-mode)
; (setq ido-enable-flex-matching t)

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
	("or" . "⋁")
	("and" . "⋀")
	))

(add-hook 'prog-mode-hook 'prettify-symbols-mode)

;; Recenter view around cursor
;(add-hook 'post-command-hook 'recenter)
(require 'ibuf-ext)

;; Use human readable Size column instead of original one
(define-ibuffer-column size-h
  (:name "Size" :inline t)
  (cond
   ((> (buffer-size) 1000000) (format "%7.1fM" (/ (buffer-size) 1000000.0)))
   ((> (buffer-size) 100000) (format "%7.0fk" (/ (buffer-size) 1000.0)))
   ((> (buffer-size) 1000) (format "%7.1fk" (/ (buffer-size) 1000.0)))
   (t (format "%8d" (buffer-size)))))

;; Modify the default ibuffer-formats
(setq ibuffer-formats
    '((mark modified read-only " "
	    (name 28 28 :left :elide)
	    " "
	    (size-h 9 -1 :right)
	    " "
	    (mode 16 16 :left :elide)
	    " "
	    filename-and-process)))

(setq ibuffer-saved-filter-groups
	(quote (("Default"
		("Dired" (mode . dired-mode))
		("Magit" (name . "magit:*")) 
		("Internal" (or
			    (name . "^\\*.*\\*$")))))))

(add-hook 'ibuffer-mode-hook
              (lambda ()
                (ibuffer-switch-to-saved-filter-groups "Default")))

;; hl-todo
(add-hook 'prog-mode-hook 'hl-todo-mode)

;; Load and setup dired-guess
(load "~/.config/emacs/dired-guess.el")
(require 'dired-guess)
(define-key dired-mode-map "r" 'dig-start)

;; Prolog
(global-set-key [f10] 'ediprolog-dwim)
(setq ediprolog-system 'swi)
(setq ediprolog-program "swipl")

;; Matlab
;(add-to-list
; 'auto-mode-alist
; '("\\.m$" . matlab-mode))
; (matlab-cedet-setup)

;; Prolog (with ediprolog)
(add-to-list
 'auto-mode-alist
 '("\\.pl$" . prolog-mode))

;; Org mode
(add-hook 'org-mode-hook 'org-indent-mode)
(add-hook 'org-mode-hook 'org-superstar-mode)

(setq org-latex-with-hyperref nil) ; Disable default hyperref

; This adds better hyperrefs for org mode export into latex
(add-hook 'org-mode-hook
	  (lambda ()
	    (add-to-list 'org-latex-default-packages-alist
			 '("hyperref,x11names" "xcolor" t))
	    (add-to-list 'org-latex-default-packages-alist
			 '("linktoc = all, colorlinks = true, urlcolor = DodgerBlue4, citecolor = PaleGreen1, linkcolor = black" "hyperref" nil))))

;; Javascript
(add-hook 'js-mode-hook
	  (lambda ()
	    (progn
	      (setq tab-width 4)
	      (lsp))))

;; Keybindings
(load "~/.config/emacs/keybindings.el")

;; Custom init generated by Nix
(load "~/.config/emacs/custom-init.el")

;; Load scad-mode.el
(load "~/.config/emacs/scad-mode.el")
(autoload 'scad-mode "scad-mode" "A major mode for editing OpenSCAD code." t)
(add-to-list 'auto-mode-alist '("\\.scad$" . scad-mode))
