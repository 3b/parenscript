(in-package :parenscript)

(defun parenscript-function-p (symbol)
  (and (some (lambda (h)
               (nth-value 1 (gethash symbol h)))
             (list *macro-toplevel-lambda-list*
                   *function-lambda-list*
                   *special-operator-lambda-list*))
       t))
#++
(pushnew 'parenscript-function-p swank::*external-valid-function-name-p-hooks*)

(defun parenscript-arglist (fname)
  (loop for hash in (list *macro-toplevel-lambda-list*
                          *function-lambda-list*
                          *special-operator-lambda-list*)
     do (multiple-value-bind (ll found)
            (gethash fname hash)
          (when found
            (return (values ll found))))))
#++
(pushnew 'parenscript-arglist swank::*external-arglist-hooks*)

