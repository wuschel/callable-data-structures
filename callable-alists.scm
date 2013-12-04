(module callable-alists (make-callable-alist)

(import chicken scheme)
(use lolevel data-structures)

(define +none+
  (list 'none))

(define (set-callable-alist! callable-alist key value)
  (let ((items (procedure-data callable-alist)))
    (set-car! items (alist-update! key value (car items)))))

(define (make-callable-alist alist)
  (let* ((alist (list alist))
         (getter
          (extend-procedure
           (lambda (#!optional (key +none+) test default)
             (if (eq? key +none+)
                 (car alist)
                 (let ((val (alist-ref key (car alist) (or test eqv?) +none+)))
                   (if (eq? val +none+)
                       default
                       val))))
           alist)))
    (getter-with-setter
     getter
     (lambda (key val)
       (set-callable-alist! getter key val)))))

) ;; end module
