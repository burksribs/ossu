;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname decreasing-image-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; decreasing-image-starter.rkt

; PROBLEM:
; 
; Design a function called decreasing-image that consumes a Natural n and produces an image of all the numbers 
; from n to 0 side by side. 
; 
; So (decreasing-image 3) should produce ...

(define TEXT-SIZE 24)
(define TEXT-COLOR "black")

;; Natural -> Image
;; produce an image of all the numbers
(check-expect (decreasing-image 3) (beside (text "3 " TEXT-SIZE TEXT-COLOR)
                                           (text "2 " TEXT-SIZE TEXT-COLOR)
                                           (text "1 " TEXT-SIZE TEXT-COLOR)
                                           (text "0 " TEXT-SIZE TEXT-COLOR)))

;(define (decreasing-image n) (text "" 0 "white")) ;stub

(define (decreasing-image n)
  (cond [(zero? n) (text "0 " TEXT-SIZE TEXT-COLOR)]
        [else
         (beside (text (string-append (number->string n) " ") TEXT-SIZE TEXT-COLOR)
                 (decreasing-image (sub1 n)))]))
