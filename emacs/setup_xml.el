;;; package --- Summary: Use xmllint to beautify XML data.
;;; Commentary:
;;

;;; Code:

(defun xml-format ()
  (interactive)
  (save-excursion
    (shell-command-on-region (mark) (point) "xmllint --format -" (buffer-name) t)
    )
  )
(provide 'setup_xml)
;;; setup_xml.el ends here

