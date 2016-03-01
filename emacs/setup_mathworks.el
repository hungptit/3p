;;; package --- Summary: Emacs setup for MathWorks sandbox.
;;; Commentary:
;;

;;; Code:


;; For MATLAB
(autoload 'matlab-eei-connect "matlab-eei"
  "Connects Emacs to MATLAB's external editor interface.")

(autoload 'matlab-mode "matlab" "Enter Matlab mode." t)
(setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))
(autoload 'matlab-shell "matlab" "Interactive Matlab mode." t)

(setq matlab-indent-function t)		; if you want function bodies indented
(setq matlab-verify-on-save-flag nil)	; turn off auto-verify on save

(defun my-matlab-mode-hook ()
  (setq fill-column 108)
  (imenu-add-to-menubar "Find"))		; where auto-fill should wrap
(add-hook 'matlab-mode-hook 'my-matlab-mode-hook)

;; For Mathworks tools
(load-file "//mathworks/hub/share/sbtools/emacs_setup.el")
(require 'mathworks)

(provide 'setup_mathworks)
;;; setup_mathworks.el ends here
