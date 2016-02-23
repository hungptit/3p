;; Disable the flash sceen
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(display-time-mode t)
 '(inhibit-startup-screen t)
 '(package-selected-packages (quote (package-build shut-up epl git commander f dash s)))
 '(tool-bar-mode nil))

;; Show line-number in the mode line
(line-number-mode 1)

;; Show column-number in the mode line
(column-number-mode 1)

;; Time
(display-time-mode 1)

;; Disable the menubar and toolbar
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;; (if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

(global-unset-key "\C-c\C-c")
(global-set-key   "\C-c\C-c" 'comment-region)

(global-unset-key "\C-c\C-u")
(global-set-key   "\C-c\C-u" 'uncomment-region)

;; Copy/paste to/from X
(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

;; Show line number
(global-linum-mode 0)

;; Customize tab width
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

;; Enable cask
(load-file (concat emacs-setup-root-path "cask/cask.el"))

;; yasnippet must be loaded before auto-complete to avoid of rendering problem.
(add-to-list 'load-path (concat emacs-setup-root-path "yasnippet/"))
(require 'yasnippet)
(yas-global-mode 1)

;; Auto-complete
(add-to-list 'load-path (concat emacs-setup-root-path "popup/"))
(add-to-list 'load-path (concat emacs-setup-root-path "fuzzy/"))
(add-to-list 'load-path (concat emacs-setup-root-path "autocomplete/"))
(require 'popup)
(require 'fuzzy)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories (concat emacs-setup-root-path "ac-dict"))
(ac-config-default)
(define-key ac-complete-mode-map "\r" nil)

;; Setup async
(add-to-list 'load-path (concat emacs-setup-root-path "async/"))
(when (require 'dired-aux)
  (require 'dired-async))

(provide 'setup) 
;;; setup.el ends here
