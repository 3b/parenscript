(in-package #:ps-test)

(defun normalize-whitespace (str)
  (substitute #\Space #\Newline (substitute #\Space #\Tab str)))

(defun same-space-between-statements (code)
  (let ((cl-ppcre:*use-bmh-matchers* nil))
    (cl-ppcre:regex-replace-all "\\s*;\\s*" code "; ")))

(defun remove-duplicate-spaces (str)
  (labels ((spacep (char) (and char (char= char #\Space)))
           (rds (list)
             (cond ((null list) nil)
                   ((and (spacep (first list)) (spacep (second list))) (rds (cons #\Space (cddr list))))
                   (t (cons (car list) (rds (cdr list)))))))
    (coerce (rds (coerce str 'list)) 'string)))

(defun trim-spaces (str)
  (string-trim '(#\Space) str))

(defun remove-spaces-near-brackets (str)
  (let ((cl-ppcre:*use-bmh-matchers* nil))
    (reduce (lambda (str rex-pair) (cl-ppcre:regex-replace-all (first rex-pair) str (second rex-pair)))
            (cons str '(("\\[ " "[") (" \\]" "]") ("\\( " "(") (" \\)" ")"))))))

(defun normalize-js-code (str)
  (remove-spaces-near-brackets
   (trim-spaces
    (remove-duplicate-spaces
     (same-space-between-statements
      (normalize-whitespace str))))))

(defmacro test-ps-js (testname parenscript javascript &key (js-target-version *js-target-version*))
  `(test ,testname ()
         (is (string= (normalize-js-code (let ((*js-target-version* ,js-target-version))
                                           (ps-doc* ',parenscript)))
                      (normalize-js-code ,javascript)))))

(def-suite output-tests)
(def-suite package-system-tests)

(defun run-tests()
  (format t "Running output tests:~&")
  (run! 'output-tests)
  (format t "Running package system tests:~&")
  (run! 'package-system-tests))
