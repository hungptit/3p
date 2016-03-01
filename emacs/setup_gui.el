;;; package --- Summary: Setup extra features
;;; Commentary:
;; 

;;; Code:

;; ;; Set fonts
;; (set-default-font "-bitstream-Bitstream Vera Sans Mono-normal-normal-normal-*-20-*-*-*-m-0-iso10646-1")
(set-default-font "Bitstream Vera Sans Mono:pixelsize=20:foundry=Bits:weight=normal:slant=normal:width=normal:scalable=true")

;; Enable zenburn
(add-to-list 'load-path (concat emacs-setup-root-path "zenburn"))
(require 'zenburn-theme)
(load-theme 'zenburn t)

(provide 'setup_gui)
;;; setup_gui.el ends here
