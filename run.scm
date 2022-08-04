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

(run-tezos-downloader-actor)
(mail 'nft-tezos-downloader ['start "aasdasd" 5000])
(define (while)
  (let loop ()
    ;; Run NFT Tezos Downloader
    (await (async (lambda () '())))
    (sleep 1)
    (loop)
    ))


(while)
