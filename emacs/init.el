;;; init.el --- Customized 'configuration entry point.
;;
;;
;;; Commentary:
;; Modify below lines to fit this setup to your workflow.

;;; Code:
(require 'setup_cedet)
(require 'setup)
(require 'setup_autocomplete)
(require 'setup_gui)
(require 'setup_flycheck)               ; This option include a setup for MathWork sandbox.
(require 'setup_helm)
(require 'setup_json)
(require 'setup_markdown)
(require 'setup_doxymacs)

(require 'extra_features)

;; Might require the latest version of Emacs
;; (require 'setup_magit)

(provide 'init)
;;; init.el ends here
