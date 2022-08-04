(define-library (actor)
  (import (otus lisp))
  (import (otus async))
  (import (bot gallery))
  (import (owl time))
  (export run-tezos-downloader-actor)
  (begin
    (define (run-tezos-downloader-actor)
      (print "Actor: downloader is running")
      (define self 'nft-tezos-downloader)
      (actor self (lambda ()
                           (let loop ((this {'diff 5000
                                                   'wallet ""
                                                   'queue '()
                                                   'lasttimestamp (time-ms)}))
                             (let* ((envelope (wait-mail))
                                    (sender msg envelope))
                               (case msg
                                 (['start wallet-addr diff]
                                  (mail self ['download-nft])
                                  (loop
                                   {'queue '()
                                           'diff diff
                                           'wallet wallet-addr
                                           'lasttimestamp (time-ms)}))
                                 (['download-nft]
                                  (mail sender 'ok)
                                  (let ((q (this 'queue))
                                        (wallet (this 'wallet))
                                        (timestamp (this 'lasttimestamp))
                                        (diff (this 'diff))) 
                                    (if (= (length q) 0)
                                        (let* ((tokens (get-tokens wallet))
                                               (first-token (car tokens))
                                               (rest (cdr tokens)))
                                          (async (lambda ()  (get-file-ipfs first-token)))
                                          (await (mail self ['download-nft]))
                                          (loop {'queue rest 'diff diff 'wallet wallet 'lasttimestamp (time-ms)}))
                                        (if (< diff (- (time-ms) timestamp))
                                            (let* ((first-elem (car q))
                                                   (rest (cdr q)))
                                              (async (lambda () (get-file-ipfs first-elem)))
                                              (await (mail self ['download-nft]))
                                              (loop {'queue rest 'wallet wallet 'diff diff 'lasttimestamp (time-ms)
                                                            }))
                                            (begin
                                              (await (mail self ['download-nft])) 
                                              (sleep 1)
                                              (loop this))
                                            ))))
                                 (else
                                  (print "Actor " self " can not understand message: " msg)
                                  (loop this)
                                  )))))))


    )
  )
