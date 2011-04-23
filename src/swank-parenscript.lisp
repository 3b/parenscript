(in-package :parenscript)

(defun parenscript-function-p (symbol)
  (and (or (gethash symbol *macro-toplevel-lambda-list* )
           (gethash symbol *function-lambda-list*))
       t))
#++
(pushnew 'parenscript-function-p swank::*external-valid-function-name-p-hooks*)

(defun parenscript-arglist (fname)
  (acond
    ((gethash fname *macro-toplevel-lambda-list*)
     (values it t))
    ((gethash fname *function-lambda-list*)
     (values it t))))
#++
(pushnew 'parenscript-arglist swank::*external-arglist-hooks*)

