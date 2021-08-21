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

(setq my-custom-keybindings-map (make-keymap))

;; Remove useless keybindings
(remove-key evil-motion-state-map (kbd "SPC"))
(remove-key evil-motion-state-map (kbd "RET"))

(global-set-key (kbd "C-SPC") nil)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-redefine-key (kbd "C-s") 'save-buffer)

;; Buffer navigation
(define-key my-custom-keybindings-map (kbd "b n") 'next-buffer)
(define-key my-custom-keybindings-map (kbd "b p") 'previous-buffer)
(define-key my-custom-keybindings-map (kbd "b d") 'kill-buffer)

;; Ibuffer navigation
(define-key my-custom-keybindings-map (kbd "b l") 'ibuffer)
(redefine-key ibuffer-mode-map (kbd "j") 'ibuffer-forward-line)
(redefine-key ibuffer-mode-map (kbd "k") 'ibuffer-backward-line)
(define-key ibuffer-mode-map (kbd "J") 'ibuffer-jump-to-buffer)

;; Windows navigation
(define-key my-custom-keybindings-map (kbd "w s h") 'split-window-horizontally)
(define-key my-custom-keybindings-map (kbd "w s v") 'split-window-vertically)
(define-key my-custom-keybindings-map (kbd "w s l") 'split-window-right)
(define-key my-custom-keybindings-map (kbd "w s j") 'split-window-below)

(define-key my-custom-keybindings-map (kbd "w h") 'windmove-left)
(define-key my-custom-keybindings-map (kbd "w j") 'windmove-down)
(define-key my-custom-keybindings-map (kbd "w k") 'windmove-up)
(define-key my-custom-keybindings-map (kbd "w l") 'windmove-right)
	  
(define-key my-custom-keybindings-map (kbd "w d") 'evil-window-delete)
(define-key my-custom-keybindings-map (kbd "w q") 'evil-window-delete)

;; Spawning external programs
(define-key my-custom-keybindings-map (kbd "s a") 'spawn-alacritty)

;; Terminals/Shell
(define-key my-custom-keybindings-map (kbd "t e")
  (lambda (name)
    (interactive (list (read-shell-command "sName: ")))
    (eshell)
    (rename-buffer (concat "*Eshell-" name "*"))))
(define-key my-custom-keybindings-map (kbd "t t") 'vterm)

;; Map my map to more global maps
(global-set-key (kbd "C-SPC") my-custom-keybindings-map)
(define-key evil-motion-state-map (kbd "SPC") my-custom-keybindings-map)

;; Dired h/l navigation
(evil-define-key 'normal dired-mode-map
  "h" 'dired-up-directory
  "l" 'dired-find-file)

(evil-define-key 'insert evil-insert-state-map
  (kbd "C-V") 'paste)

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

