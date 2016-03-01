;;; package --- Summary: Basic setup for Emacs
;;; Commentary:
;;

;;; Code:

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

;; Customize tab width
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

;; Enable cask
(add-to-list 'load-path (concat emacs-setup-root-path "cask"))
(require 'cask)

(provide 'setup)
;;; setup.el ends here
