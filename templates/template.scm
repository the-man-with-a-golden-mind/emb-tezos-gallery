(define-library (templates template)
  (import (owl string))
  (import (scheme core))
  (import (owl list))
  (import (otus lisp))
  (export n
          H1
          H2
          DIV
          SPAN
          I
          P
          BR
          NAV
          SECTION
          IMG
          A
          DD
          DL
          DT
          HR
          OL
          UL
          B
          SVG
          CANVAS
          BUTTON
          INPUT
          FORM
          LABEL
          OPTION
          PROGRESS
          TEXTAREA
          SELECT)

  (begin

    (define (html-param name val)
      (let ((return-val  (string-append " " name "=\"" val "\" ")))
        (if (string-eq? val "")
            ""
            return-val)))

    (define (html-params params)
      (if (eq? '() params)
          ""
          (let ((mapped-params (map
                                (lambda (param)
                                  (html-param (car param) (car (cdr param))))
                                params)))
                (fold string-append "" mapped-params))))

    (define (n elem-name params content)
      (string-append "<"
                     elem-name
                     (html-params params)
                     ">"
                     content
                     "</"
                     elem-name
                     ">"))

    (define (H1 params content)
      (n "h1" params content))

    (define (H2 params content)
      (n "h2" params content))

    (define (DIV params content)
      (n "div" params content))

    (define (SPAN params content)
      (n "span" params content))

    (define (I params content)
      (n "i" params content))

    (define (IMG params content)
      (n "img" params content))

    (define (P params content)
      (n "p" params content))

    (define (BR params content)
      (n "br" params content))

    (define (NAV params content)
      (n "nav" params content))

    (define (SECTION params content)
      (n "section" params content))

    (define (A params content)
      (n "a" params content))

    (define (DD params content)
      (n "dd" params content))

    (define (DL params content)
      (n "dl" params content))

    (define (DT params content)
      (n "dt" params content))

    (define (HR params content)
      (n "hr" params content))

    (define (OL params content)
      (n "ol" params content))

    (define (UL params content)
      (n "ul" params content))

    (define (B params content)
      (n "b" params content))

    (define (SVG params content)
      (n "svg" params content))

    (define (CANVAS params content)
      (n "canvas" params content))

    (define (BUTTON params content)
      (n "button" params content))

    (define (INPUT params content)
      (n "input" params content))

    (define (FORM params content)
      (n "form" params content))

    (define (LABEL params content)
      (n "label" params content))

    (define (OPTION params content)
      (n "option" params content))

    (define (PROGRESS params content)
      (n "progress" params content))

    (define (TEXTAREA params content)
      (n "textarea" params content))

    (define (SELECT params content)
      (n "select " params content))))
