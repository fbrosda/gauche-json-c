;;
;; Package gauche-json
;;

(define-gauche-package "gauche-json-c"
  :version "1.0"
  :description "Fast json read/write for gauche using json-c."
  :require (("Gauche" (>= "0.9.11")))
  :providing-modules (json-c)
  :authors ("Fabian Brosda <fabi3141@gmx.de>")
  :maintainers ()
  :licenses ("BSD")
  ; :homepage "http://example.com/gauche-json/"
  ; :repository "http://example.com/gauche-json.git"
  )
