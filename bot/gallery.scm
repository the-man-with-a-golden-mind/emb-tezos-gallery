
(define-library (bot gallery)
  (import
   (lang sexp)
   (otus lisp)
   (owl parse)
   (owl async)
   (file json)
   (owl ff))

  (export process-tokens
          get-tokens
          get-files
          get-file-ipfs)

  (begin
 
    (define (build-command-url url)
      (let ((raw-request (list "curl" "-s" "-X" "GET" url
                               "-H"  "content-type: application/json")))
        (print raw-request)
        raw-request))

    (define (download-file url file-name)
      (list "curl" url
            "--output" file-name)
      )

    (define get-string
      (let-parse* ((bytes (greedy+ byte)))
                  (bytes->string bytes)))

    (define get-json
      (let-parse* ((bytes (greedy+ byte)))
                  (read-json-stream bytes)))


    (define (make-request command return?)
      (print "MAKE REQUEST")
      (print command)
      (define In (syscall 22))
      (define Out (syscall 22))

      (define (Pid command in out)
        (syscall 59 (c-string "/usr/bin/curl")
                 (map c-string command)
                 (list (car in) (cdr out))))

      (Pid command In Out)
      ;CLOSING PORTS
      (for-each close-port (list (car In) (cdr Out)))
      (if (eq? return? #true)
          (let* ((response (try-parse get-json (port->bytestream (car Out)) #false))
                    (body (car response)))
               (close-port (car Out))
               body
               )
          (print "Processing request")))

    (define (get-file-ipfs file-code)
      (begin
        (print file-code)
        (let* ((cleared-name (substring file-code 7))
               (url (string-append "https://ipfs.io/ipfs/"  cleared-name))
                  (command (download-file url (string-append "./images/" cleared-name ".jpeg")))
                  (result (make-request command #false)))
          (print "RESULTTT")
             )))

    (define (process-tokens body)
      (let* ((balances (getf body 'balances))
             (balances-list (vector->list balances))
             (ipfs-links (map (lambda (i) (getf i 'display_uri)) balances-list)))
        ipfs-links))

    (define (get-files ipfs-files)
      (begin
        (print "IPFS FILES")
        (print ipfs-files)
        (map (lambda (f) (begin
                          (print "IPFS FILE: ")
                          (print f)
                          (async (get-file-ipfs f))
                          )) ipfs-files)))

    (define (get-tokens)
      (let* ((command (build-command-url "https://api.better-call.dev/v1/account/mainnet/tz2JPfBB2fpf9DRzXjVi5U4CAEoENU2dnz8e/token_balances"))
             (request (make-request command #true))
             (links (process-tokens request)))
        links))))