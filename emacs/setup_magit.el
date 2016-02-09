;; Setup required packages
(add-to-list 'load-path (concat emacs-setup-root-path "dash/"))
(add-to-list 'load-path (concat emacs-setup-root-path "with-editor/"))
(require 'dash)

;; Setup magit
(add-to-list 'load-path (concat emacs-setup-root-path "magit/lisp"))
(require 'magit)

