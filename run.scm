(define *path* (cons "./" *path*))
(print *path*)
(import (actor))
(import (otus lisp))
(import (lib http))
(import (bot gallery))
(import (routing match))
(import (templates template))
(import (lang macro))

(run-tezos-downloader-actor)
(mail 'nft-tezos-downloader ['start "tz2JPfBB2fpf9DRzXjVi5U4CAEoENU2dnz8e" 5000])

(define port 8080)
(define ok-200 "HTTP/1.0 200 OK\n")
(define conn-close "Connection: close\n")
(define content-html "Content-Type: text/html; charset=UTF-8\n")

(define (send-template template send)
  (send ok-200
        conn-close
        content-html
        "Server: " (car *version*) "/" (cdr *version*)
        "\n\n"
        template))

(define (send-file filename fd send)
  (define full-filename (string-append "./images/" filename))
  (define stat (syscall 4 (if (string? full-filename) (c-string full-filename))))
  
  (if stat
      (cond
                                        ; regular file?
       ((not (zero? (band (ref stat 3) #o0100000)))
        (display "<file> ") ; TODO: get mimetypes
        (define file (open-input-file full-filename))
        (if file
            then
            (begin (send "HTTP/1.0 200 OK\n"
                         "Connection: close\n"
                         "Content-Type: " "application/octet-stream" "\n"
                         "Content-Length: " (ref stat 8) "\n"
                         "Server: " (car *version*) "/" (cdr *version*) "\n"
                         "\n")
                   (syscall 40 fd file 0 (ref stat 8)) ; sendfile
                (close-port file))
            else
            (send "HTTP/1.0 500 Internal Server Error\n"
                  "Connection: close\n"
                  "\n")
            ))
       (else
        (send "HTTP/1.0 500 Internal Server Error\n"
              "Connection: close\n"
              "\n")
        )))
  (send "HTTP/1.0 404 Not Found\n"
        "Connection: close\n"
        "\n"))

(define (request req-type content fd send)
  (cond
                                        ; static files
   ((eq? req-type 'static)
    (send-file content fd send))
                                        ; templates
   (else
    (send-template content send))))



(define (router fd send  path)
  (let* ((splitted-route (route path)))
    (print path)
                                        ;(print (car (cdr splitted-route)) "!!!")
                                        ;(print splitted-route)
    (CASE splitted-route
          (MATCH ("GET" "static" "images" string?) =>
                 (r-type static images filename)
                 (print "Filename: " filename)
                 (request 'static filename fd send)
                 )
          (MATCH ("GET" "home" string?) =>
                 (_ path name)
                 (request 'template (IMG (list (list "src" (string-append "http://localhost:" (number->string port) "/static/images/QmcGK5NhNycZdPCetRs4jAyri3kGgridMgNNs4WeGZbKGj.jpeg"))) (string-append "Hello" name)) #false send))
          (MATCH ("GET" string?) =>
                 (path name)
                 (request 'template (H1 '() (string-append "Hellooooo" name)) #false send))
          (else
           (request 'template (DIV '() (H1 '() "TEST")) #false send)))))

(http:run port (lambda (fd request headers body close)
                 (define (send . args)
                   (print "ARGS:" args)
                   (for-each (lambda (arg)
                               (display-to fd arg)) args))
                 (print "FD:" fd)
                 (print "REQUEST:" (route request))
                 (print "BODY:" body)
                 (print ":: " (syscall 51 fd))
                 (router fd send request)
                 (close #t)))
