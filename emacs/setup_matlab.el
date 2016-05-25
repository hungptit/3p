;;; package --- Summary: Setup graphviz-dot-mode
;;; Commentary:
;; 

;;; Code:
(add-to-list 'load-path (concat emacs-setup-root-path "matlab-mode"))
(require 'matlab-load)

(autoload 'matlab-mode "matlab" "Matlab Editing Mode" t)
(add-to-list
 'auto-mode-alist
 '("\\.m$" . matlab-mode))
(setq matlab-indent-function t)
(setq matlab-shell-command "/home/hungptit/projects/matlab-sqlite/run_matlab.sh")

(provide 'setup_matlab)
;;; setup_matlab.el ends here
