;;;
;;; Test gauche_json
;;;

(use gauche.test)

(test-start "gauche_json")
(use gauche_json)
(test-module 'gauche_json)

;; The following is a dummy test code.
;; Replace it for your tests.
(test* "Int" 1 (parse-json-string "1"))
(test* "Double" 0.5 (parse-json-string "0.5"))

(test* "True" #t (parse-json-string "true"))
(test* "False" #f (parse-json-string "false"))

(test* "Empty String" "" (parse-json-string "\"\""))
(test* "String" "Hello World!" (parse-json-string "\"Hello World!\""))

(test* "Array []" #() (parse-json-string "[]"))
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


;; If you don't want `gosh' to exit with nonzero status even if
;; the test fails, pass #f to :exit-on-failure.
(test-end :exit-on-failure #t)
