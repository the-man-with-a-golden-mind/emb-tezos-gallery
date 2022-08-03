(define *path* (cons "./" *path*))
(print *path*)
(import (actor))
(import (otus lisp))

(import (bot gallery))

(define (run)
  (let* ((tokens (get-tokens))
         (files (get-files tokens)))
    (print tokens))
  )

(run-actor)

(define (while)
  (let loop ()
    (mail 'downloader ['d])

    (sleep 1000)
    (loop)
    ))


(while)
