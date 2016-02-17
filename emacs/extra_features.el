(custom-set-faces
 '(semantic-decoration-on-unknown-includes ((((class color) (background light)) (:background "#ffF0F0")))))

;; Set cursor and mouse-pointer colours
(set-cursor-color "red")
(set-mouse-color "goldenrod")

;; Set region background colour
(set-face-background 'region "blue")

;; Set emacs background colour
(set-background-color "black")
(set-foreground-color "white")

;; Set fonts
;; (set-default-font "-bitstream-Bitstream Vera Sans Mono-normal-normal-normal-*-20-*-*-*-m-0-iso10646-1")
(set-default-font "Bitstream Vera Sans Mono:pixelsize=20:foundry=Bits:weight=normal:slant=normal:width=normal:scalable=true")
(put 'upcase-region 'disabled nil)

;; CMake
(flymake-mode 1)
(require 'cmake-mode)

;; Org-mode
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

;; MATLAB
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

;; ;; irony-mode
;; (add-to-list 'load-path (concat emacs-setup-root-path "irony-mode/"))
;; (add-hook 'c++-mode-hook 'irony-mode)
;; (add-hook 'c-mode-hook 'irony-mode)
;; (add-hook 'objc-mode-hook 'irony-mode)
;; (require 'irony)
;; (require 'irony-cdb)

;; ;; replace the `completion-at-point' and `complete-symbol' bindings in
;; ;; irony-mode's buffers by irony-mode's function
;; (defun my-irony-mode-hook ()
;;   (define-key irony-mode-map [remap completion-at-point]
;;     'irony-completion-at-point-async)
;;   (define-key irony-mode-map [remap complete-symbol]
;;     'irony-completion-at-point-async))
;; (add-hook 'irony-mode-hook 'my-irony-mode-hook)
;; (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

;; ;; ac-irony
;; (defun my-ac-irony-setup ()
;;   ;; be cautious, if yas is not enabled before (auto-complete-mode 1), overlays
;;   ;; *may* persist after an expansion.
;;   (yas-minor-mode 1)
;;   (auto-complete-mode 1)

;;   (add-to-list 'ac-sources 'ac-source-irony)
;;   (define-key irony-mode-map (kbd "M-RET") 'ac-complete-irony-async))

;; (add-hook 'irony-mode-hook 'my-ac-irony-setup)

;; doxymacs.
(add-to-list 'load-path (concat emacs-setup-root-path "doxymacs/share/emacs/site-lisp/"))
(require 'doxymacs)
(defun doxymacs-font-lock ()
  (interactive)
  (font-lock-add-keywords nil doxymacs-doxygen-keywords))

;; json-mode, json-reformat, and json-snatcher
(add-to-list 'load-path (concat emacs-setup-root-path "json-mode"))
(add-to-list 'load-path (concat emacs-setup-root-path "json-snatcher"))
(add-to-list 'load-path (concat emacs-setup-root-path "json-reformat"))

(require 'json-mode)
(require 'json-reformat)
(require 'json-snatcher)

;; Markdown
(add-to-list 'load-path (concat emacs-setup-root-path "markdown-mode"))
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; Enable flycheck
(add-to-list 'load-path (concat emacs-setup-root-path "flycheck"))
(add-to-list 'load-path (concat emacs-setup-root-path "seq"))
(require 'flycheck)

;; rainbow-delimiters
(add-to-list 'load-path (concat emacs-setup-root-path "rainbow-delimiters"))
(require 'rainbow-delimiters)

;; undo-tree
(add-to-list 'load-path (concat emacs-setup-root-path "undo-tree"))
(require 'undo-tree)
(global-undo-tree-mode)
