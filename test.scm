;;;
;;; Test gauche_json
;;;

(use gauche.test)

(test-start "json-c")
(use json-c)
(test-module 'json-c)

(test* "<empty string>" #t (eof-object? (parse-json-string "")))
(test* "Int 1" 1 (parse-json-string "1"))
(test* "Int 2" -1 (parse-json-string "-1"))
(test* "Int 3" 0 (parse-json-string "0"))
(test* "Large Int 1" 2305843009213693952 (parse-json-string "2305843009213693952"))
(test* "Large Int 2" 18446744073709551615 (parse-json-string "18446744073709551615"))
(test* "Large Int 3" "integer value is out of range."
       (guard (e [else (~ e 'message)])
         (parse-json-string "999999999999999999999999999999")))
(test* "Small Int 1" -2305843009213693952 (parse-json-string "-2305843009213693952"))
(test* "Small Int 2" -9223372036854775808 (parse-json-string "-9223372036854775808"))
(test* "Large Int 3" "integer value is out of range."
       (guard (e [else (~ e 'message)])
         (parse-json-string "-999999999999999999999999999999")))

(test* "Int Parse Error" "integer value is out of range."
       (guard (e [else (~ e 'message)])
         (parse-json-string "{\"a\": 999999999999999999999999999999, \"b\": 2}")))


(test* "Double" 0.5 (parse-json-string "0.5"))

(test* "Invalid input"
       "<string> required, but got 1"
       (guard (e [else (~ e 'message)])
	 (parse-json-string 1)
	 #f))

(test* "Invalid input" #f (guard (e [else #f])
			    (parse-json-string "[1, ")
			    #t))

(test* "True" #t (parse-json-string "true"))
(test* "False" #f (parse-json-string "false"))
(test* "null" 'null (parse-json-string "null"))

(test* "Empty String" "" (parse-json-string "\"\""))
(test* "String" "Hello World!" (parse-json-string "\"Hello World!\""))

(test* "Array []" #() (parse-json-string "[]"))
(test* "Array [null]" #(null) (parse-json-string "[null]"))
(test* "Array [1,2]" #(1 2) (parse-json-string "[1, 2]"))
(test* "Array [[], []]" #(#() #()) (parse-json-string "[[], []]"))
(test* "Array [[1,2,3]]" #(#(1 2 3)) (parse-json-string "[[1,2,3]]"))

(test* "Object {}" '() (parse-json-string "{}"))
(test* "Object {a: 1}" '(("a" . 1)) (parse-json-string "{\"a\": 1}"))
(test* "Object {a: {}}" '(("a" . ())) (parse-json-string "{\"a\": {}}"))
(test* "Object {a: {b: 2}}" '(("a" . (("b" . 2)))) (parse-json-string "{\"a\": {\"b\": 2}}"))

(test* "Mixed [{a: [1,2,3]}, {b: {c: false}}]"
       #((("a" . #(1 2 3))) (("b" . (("c" . #f)))))
       (parse-json-string "[{\"a\": [1,2,3]}, {\"b\": {\"c\": false}}]"))

(test* "Mixed [{a: [1,2,3]}, {b: {c: {x: false}}}]"
       '(("a" . 12) ("b" . #(1 2 3)) ("c" . (("x" . #f))))
       (parse-json-string "{\"a\": 12, \"b\": [1,2,3], \"c\": {\"x\": false}}"))

(test* "parse-json"
       '()
       (with-input-from-string "{}" parse-json))

(test* "parse-json*"
       '(1 #(3 4) (("a" . 1)))
       (with-input-from-string "1 \n [3, 4] \n {\"a\": 1}" parse-json*))

(test* "json-null?" #t (json-null? (parse-json-string "null")))
(test* "json-null?" #f (json-null? (parse-json-string "1")))

;; If you don't want `gosh' to exit with nonzero status even if
;; the test fails, pass #f to :exit-on-failure.
(test-end :exit-on-failure #t)
