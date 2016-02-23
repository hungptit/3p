;; Setup required packages
(add-to-list 'load-path (concat emacs-setup-root-path "dash/"))
(add-to-list 'load-path (concat emacs-setup-root-path "with_editor/"))
(require 'dash)

;; Setup magit
(add-to-list 'load-path (concat emacs-setup-root-path "magit/lisp"))
(require 'magit)

(provide 'setup_magit)
;;; setup_magit ends here
