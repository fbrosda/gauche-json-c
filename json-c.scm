;;;
;;; gauche_json
;;;

(define-module json-c
  (export parse-json-string
	  parse-json
	  parse-json*))

(select-module json-c)

;; Loads extension
(dynamic-load "gauche_json")

;;
;; Put your Scheme definitions here
;;

(define (parse-json :optional (input-port (current-input-port)))
  (let1 inpt (read-string +inf.0 input-port)
    (parse-json-string inpt)))

;; Note: Expects one json expression per line!
(define (parse-json* :optional (input-port (current-input-port)))
  (reverse!
   (rlet1 res '()
	  (until (read-line input-port) eof-object? => l
		 (set! res (cons (parse-json-string l) res))))))
