(require 'cl)

(defvar test-failure-fail-overlays nil)
(defvar test-failure-pass-overlays nil)

(defun test-failure-clear-overlays ()
  (interactive)
  (loop for overlay in (nconc test-failure-pass-overlays test-failure-fail-overlays)
        do (delete-overlay overlay))
  (setq test-failure-fail-overlays nil)
  (setq test-failure-pass-overlays nil))

(defun test-failure-start ()
  (test-failure-clear-overlays))

(defun test-failure--make-overlay (file line)
  (with-current-buffer (or (get-file-buffer file) (find-file file))
    (save-excursion
      (goto-line line)
      (make-overlay (save-excursion (beginning-of-line) (point))
                    (save-excursion (end-of-line) (point))))))

(defmacro define-test-result-overlay-change-command (var color)
  `(defun ,(intern (format "report-test-%s" var)) (file line)
     (interactive "fFile: \nnLine: ")
     (let ((overlay (test-failure--make-overlay file line)))
       (push overlay ,(intern (format "test-failure-%s-overlays" var)))
       (overlay-put overlay 'face ',color))))

(define-test-result-overlay-change-command pass (:underline "#00ff00"))
(define-test-result-overlay-change-command fail (:underline "#ff0000"))
