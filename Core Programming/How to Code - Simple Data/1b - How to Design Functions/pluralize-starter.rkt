;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname pluralize-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; pluralize-stubs-starter.rkt

;PROBLEM:
; 
; Design a function that pluralizes a given word. (Pluralize means to convert the word to its plural form.)
; For simplicity you may assume that just adding s is enough to pluralize a word. 
;

;; String -> String
;; pluralizes str by appending "s" to the end 
(check-expect (pluralize "apple") "apples")
(check-expect (pluralize "hand") (string-append "hand" "s"))

;(define (pluralize s) "") ;stub

;(define (pluralize s) ;template
;  (... s))

(define (pluralize s)
  (string-append s "s"))