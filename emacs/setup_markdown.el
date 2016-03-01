;;; package --- Summary: Setup markdown
;;; Commentary:
;;

;;; Code:

;; Markdown
(add-to-list 'load-path (concat emacs-setup-root-path "markdown_mode"))
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(provide 'setup_markdown)
;;; setup_markdown.el ends here
