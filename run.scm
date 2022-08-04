(define *path* (cons "./" *path*))
(print *path*)
(import (actor))
(import (otus lisp))

(import (bot gallery))

(run-tezos-downloader-actor)
(mail 'nft-tezos-downloader ['start "tz2JPfBB2fpf9DRzXjVi5U4CAEoENU2dnz8e" 5000])

