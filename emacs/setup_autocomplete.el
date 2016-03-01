;;; package --- Summary: Setup auto-complete and its dependencies
;;; Commentary:
;;

;;; Code:

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

(provide 'setup_autocomplete)
;;; setup_autocomplete.el ends here
