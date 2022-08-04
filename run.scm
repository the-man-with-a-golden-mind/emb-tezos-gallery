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
    ;; Run NFT Tezos Downloader
    (await (mail 'nft-tezos-downloader ['d]))
    (sleep 1)
    (loop)
    ))


(while)
