;;; package --- Summary: Setup doxymacs
;;; Commentary:
;;

;;; Code:
(add-to-list 'load-path (concat emacs-setup-root-path "doxymacs/share/emacs/site-lisp/"))
(require 'doxymacs)
(defun doxymacs-font-lock ()
  (interactive)
  (font-lock-add-keywords nil doxymacs-doxygen-keywords))

(provide 'setup_doxymacs)
;;; setup_doxymacs.el ends here
