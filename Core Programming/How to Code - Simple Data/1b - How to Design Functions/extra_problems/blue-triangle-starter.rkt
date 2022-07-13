;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname blue-triangle-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
;; blue-triangle-starter.rkt

;PROBLEM:
;
;Design a function that consumes a number and produces a blue solid triangle of that size.
;
;You should use The How to Design Functions (HtDF) recipe, and your complete design should include
;signature, purpose, commented out stub, examples/tests, commented out template and the completed function.

;; Natural -> Image
;; produce a blue triangle with given size
(check-expect (blue-triangle 10) (triangle 10 "solid" "blue"))
(check-expect (blue-triangle 30) (triangle 30 "solid" "blue"))

;(define (blue-triangle n) (triangle 0 "solid" "blue")) ;stub

;(define (blue-triangle n) ;template
;  (... n))

(define (blue-triangle n)
  (triangle n "solid" "blue"))