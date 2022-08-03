(define-library (actor)
  (import (otus lisp))
  (import (otus async))
  (import (bot gallery))
  (import (owl time))
  (export run-actor)
  (begin

    (define (diff) 5000)

    (define (run-actor)
      (print "Actor: downloader is running")
      (actor 'downloader (lambda ()
                           (let loop ((this {'queue '() 'lasttimestamp (time-ms)}))
                             (let* ((envelope (wait-mail))
                                    (sender msg envelope))
                               (case msg
                                 (['d]
                                  (let ((q (this 'queue)))
                                    (if (= (length q) 0)
                                        (let* ((tokens (get-tokens))
                                               (first-token (car tokens))
                                               (rest (cdr tokens)))
                                          (async (lambda ()  (get-file-ipfs first-token)))
                                          (loop {'queue rest 'lasttimestamp (time-ms)}))
                                        (if (< (diff) (- (time-ms) (this 'lasttimestamp)))
                                            (let* ((first-elem (car q))
                                                   (rest (cdr q)))
                                              (async (lambda () (get-file-ipfs first-elem)))
                                              (loop {'queue rest 'lasttimestamp (time-ms)}))
                                            (begin
                                              (loop this))
                                            ))))
                                 (else
                                  (print "MSG")
                                  (print msg))))))))


    )
  )
