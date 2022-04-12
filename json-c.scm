(define-module json-c
  (use rfc.json
       :only (<json-parse-error>
	      construct-json
	      construct-json-string))
  (export parse-json-string
	  parse-json
	  parse-json*
	  construct-json
	  construct-json-string))

(select-module json-c)

(dynamic-load "gauche_json")

(define (parse-json :optional (input-port (current-input-port)))
  (let1 inpt (read-string +inf.0 input-port)
    (parse-json-string inpt)))

;; Note: Expects one json expression per line!
(define (parse-json* :optional (input-port (current-input-port)))
  (reverse!
   (rlet1 res '()
	  (until (read-line input-port) eof-object? => l
		 (guard (e [else (print l) ; TODO: more flexibility?
				 (report-error e)])
		   (when (> (string-length l) 0)
		     (set! res (cons (parse-json-string l) res))))))))
