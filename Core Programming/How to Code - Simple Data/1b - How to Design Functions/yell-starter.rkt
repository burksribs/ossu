;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname yell-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; yell-starter.rkt


;PROBLEM:
;
;DESIGN a function called yell that consumes strings like "hello" 
;and adds "!" to produce strings like "hello!".
;
;Remember, when we say DESIGN, we mean follow the recipe.
;
;Leave behind commented out versions of the stub and template.


;; String -> String
;; add "!" to the end of s
(check-expect (yell "hey!") "hey!")
(check-expect (yell "hello") "hello!")

;(define (yell s) "") ;stub

;(define (yell s) ;template
;  (... s))

(define (yell s)
  (if (string=? (substring s (- (string-length s) 1)) "!")
      s
      (string-append s "!")))