;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname sum-to-n-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; sum-to-n-starter.rkt

;  PROBLEM:
;  
;  Design a function that produces the sum of all the naturals from 0 to a given n. 
  

; Natural -> Natural
; sum of natural which 0 to n
(check-expect (sum-0-to-n 0) 0)
(check-expect (sum-0-to-n 5) 15)
(check-expect (sum-0-to-n 10) 55)

;(define (sum-0-to-n n) 0) ; stub

(define (sum-0-to-n n)
  (cond [(zero? n) 0]
        [else
         (+ n
            (sum-0-to-n (sub1 n)))]))