;;; package --- Summary: Setup flycheck
;;; Commentary:
;;

;;; Code:

;; Enable flycheck
(add-to-list 'load-path (concat emacs-setup-root-path "flycheck"))
(add-to-list 'load-path (concat emacs-setup-root-path "seq"))
(require 'flycheck)

;; Use C++14 by default
(setq-default flycheck-clang-language-standard "c++14"
              flycheck-gcc-language-standard   "c++14")

;; flycheck setup for MathWorks sandbox
(add-hook 'after-init-hook #'global-flycheck-mode)
(eval-after-load 'flycheck
  '(progn
     (flycheck-define-checker c/c++-sbcccheck
       "A C/C++ checker using SBCC."
       :command ("sbcc" "-clang" "MIXED@SUPER-STRICT" source-inplace)
       :error-patterns
       ((error line-start
               (message "In file included from") " " (file-name) ":" line ":"
               line-end)
        (info line-start (file-name) ":" line ":" column
              ": note: " (message) line-end)
        (warning ":" line ":" (one-or-more digit) ": warning:" (message) line-end)
        (warning line-start (file-name) ":" line ":" column
                 ": warning: " (message) line-end)
        (warning line-start (one-or-more (not (any ":"))) ":" line
                 ": warning " (message) line-end)
        (error (one-or-more (not (any ":"))) ":" line ":" column ": " (or "error" "fatal error") ": " (message) line-end)
        (error line-start (file-name) ":" line ":" column
               ": " (or "fatal error" "error") ": " (message) line-end)
        (info line-start (file-name) ":" line ":" column
              ": note: " (message) line-end))
       :modes (c-mode c++-mode)
       :predicate (lambda () (and
                              (buffer-file-name)
                              (string-match "/matlab/" (buffer-file-name)))))
     (add-to-list 'flycheck-checkers 'c/c++-sbcccheck)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flycheck-temp-prefix ".flycheck"))

(provide 'setup_flycheck)
;;; setup_flycheck.el ends here
