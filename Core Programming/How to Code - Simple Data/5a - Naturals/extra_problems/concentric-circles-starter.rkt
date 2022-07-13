;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname concentric-circles-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; concentric-circles-starter.rkt

; PROBLEM:
; 
; Design a function that consumes a natural number n and a color c, and produces n 
; concentric circles of the given color.
; 
; So (concentric-circles 5 "black") should produce .
 

;; Natural String -> Image
;; produce n concentric circles of color c
(check-expect (concentric-circles 0 "red") empty-image)
(check-expect (concentric-circles 2 "red") (overlay (circle 20 "outline" "red")
                                                    (circle 10 "outline" "red")
                                                    empty-image))
(check-expect (concentric-circles 5 "red") (overlay (circle 50 "outline" "red")
                                                    (circle 40 "outline" "red")
                                                    (circle 30 "outline" "red")
                                                    (circle 20 "outline" "red")
                                                    (circle 10 "outline" "red")
                                                    empty-image))


; (define (concentric-circles n c) empty-image) ;stub

(define (concentric-circles n c)
  (cond [(zero? n) empty-image]
        [else
         (overlay (circle (* n 10) "outline" c)
                  (concentric-circles (sub1 n) c))]))