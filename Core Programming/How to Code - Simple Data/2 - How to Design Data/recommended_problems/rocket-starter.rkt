;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname rocket-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; rocket-starter.rkt

;; =================
;; Data definitions:


;PROBLEM A:
;
;You are designing a program to track a rocket's journey as it descends 
;100 kilometers to Earth. You are only interested in the descent from 
;100 kilometers to touchdown. Once the rocket has landed it is done.
;
;Design a data definition to represent the rocket's remaining descent. 
;Call it RocketDescent.


;; RocketDescent is one of:
;;  - false
;;  - Number(0,100]
(define RD1 false)
(define RD2 1)
(define RD3 100)


(define (fn-for-rocket-descent rd)
  (cond [(false? rd) (...)]
        [(and (number? rd) (< 0 rd) (<= rd 100)) (... rd)]))

;; Template rule used:
;;  - one of: 2 cases
;;  - atomic distinct: false
;;  - atomic non-distinct: Number(0,100]

;; =================
;; Functions:


;PROBLEM B:
;
;Design a function that will output the rocket's remaining descent distance 
;in a short string that can be broadcast on Twitter. 
;When the descent is over, the message should be "The rocket has landed!".
;Call your function rocket-descent-to-msg.


;; RocketDescent -> String
;; output the rocket's remaining descent distance in string
(check-expect (rocket-descent-to-msg false) "The rocket has landed!")
(check-expect (rocket-descent-to-msg 1) "Altitude from land area is 1 km")
(check-expect (rocket-descent-to-msg 50) "Altitude from land area is 50 km")
(check-expect (rocket-descent-to-msg 100) "Altitude from land area is 100 km")

;(define (rocket-descent-to-msg rd) "") ;stub

; <used template from RocketDescent>
(define (rocket-descent-to-msg rd)
  (cond [(false? rd) "The rocket has landed!"]
        [(and (number? rd) (< 0 rd) (<= rd 100))
         (string-append "Altitude from land area is " (number->string rd) " km")]))
