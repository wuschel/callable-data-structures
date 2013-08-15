(module callable-hash-tables (make-callable-hash-table)

(import chicken scheme)
(use srfi-69 lolevel)

(define +none+
  (list 'none))

(define (set-callable-hash-table! hash key value)
  (let ((items (procedure-data hash)))
    (hash-table-set! items key value)))

(define (make-callable-hash-table . args)
  (let* ((items (apply alist->hash-table args))
         (getter
          (extend-procedure
           (lambda (#!optional (key +none+) default)
             (if (eq? key +none+)
                 items
                 (let ((val (hash-table-ref/default items key +none+)))
                   (if (eq? val +none+)
                       default
                       val))))
           items)))
    (getter-with-setter
     getter
     (lambda (key val)
       (set-callable-hash-table! getter key val)))))

) ;; end module
