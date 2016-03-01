;;; package --- Summary: Setup json-mode, json-reformat, and json-snatcher.
;;; Commentary:
;;

;;; Code:

(add-to-list 'load-path (concat emacs-setup-root-path "json_mode"))
(add-to-list 'load-path (concat emacs-setup-root-path "json_snatcher"))
(add-to-list 'load-path (concat emacs-setup-root-path "json_reformat"))

(require 'json-mode)
(require 'json-reformat)
(require 'json-snatcher)

(provide 'setup_json)
;;; setup_json.el ends here
