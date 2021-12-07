(defun remove-key (map k)
  "Removes key from some map"
  (define-key map k nil))

(defun redefine-key (map k c)
  "Redefines key in some keymap"
  (remove-key map k)
  (define-key map k c))

(defun global-redefine-key (k c)
  "Redefine globaly defined key."
  (interactive)
  (global-unset-key k)
  (global-set-key k c))

(defun spawn-alacritty ()
  "Spawns alacritty terminal"
  (interactive)
  (start-process-shell-command "alacritty-term" nil "alacritty"))

; From: https://www.emacswiki.org/emacs/DocumentingKeyBindingToLambda
(defun lambda-key (keymap key def)
  "Wrap`define-key' to provide documentation."
  (set 'sym (make-symbol (documentation def)))
  (fset sym def)
  (define-key keymap key sym))

(setq my-custom-keybindings-map (make-keymap))

;(global-set-key (kbd "C-SPC") nil)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-redefine-key (kbd "C-s") 'save-buffer)

;; Buffer navigation
(define-key my-custom-keybindings-map (kbd "C-b C-n") 'next-buffer)
(define-key my-custom-keybindings-map (kbd "C-b C-p") 'previous-buffer)
(define-key my-custom-keybindings-map (kbd "C-b C-d") 'kill-buffer)

;; Ibuffer navigation
(define-key my-custom-keybindings-map (kbd "C-b C-l") 'ibuffer)
(define-key my-custom-keybindings-map (kbd "C-b C-b") 'counsel-ibuffer)

;; Spawning external programs
(define-key my-custom-keybindings-map (kbd "C-s C-a") 'spawn-alacritty)

;; Terminals/Shell
(define-key my-custom-keybindings-map (kbd "C-t C-e")
  (lambda (name)
    (interactive (list (read-shell-command "sName: ")))
    (eshell)
    (rename-buffer (concat "*Eshell-" name "*"))))
(define-key my-custom-keybindings-map (kbd "C-t C-t") 'vterm)

;; Map my map to more global maps
; (global-set-key (kbd " ") my-custom-keybindings-map)
(global-set-key (kbd "M-p") my-custom-keybindings-map)

;(evil-define-key 'insert evil-insert-state-map
;  (kbd "C-V") 'paste)

;; Matlab related
(add-hook 'matlab-mode-hook
	  (lambda ()
	    (lambda-key matlab-mode-map (kbd "C-c C-w")
			'(lambda ()
			   "Launch matlab shell in window below"
			   (interactive)
			   (progn
			     (split-window-below)
			     (other-window 1)
			     (fit-window-to-buffer (selected-window) (/ (frame-height) 3))
			     (matlab-shell)))
			)))

;; Emacs fitting keybindings
(global-set-key (kbd "C-x C-a C-f") 'find-file-at-point)

;; Ivy keybindings
(global-set-key (kbd "C-c C-f") 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

