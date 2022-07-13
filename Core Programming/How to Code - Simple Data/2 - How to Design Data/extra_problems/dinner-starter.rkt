;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname dinner-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; dinner-starter.rkt

;; =================
;; Data definitions:


;PROBLEM A:
;
;You are working on a system that will automate delivery for 
;YesItCanFly! airlines catering service. 
;There are three dinner options for each passenger, chicken, pasta 
;or no dinner at all. 
;
;Design a data definition to represent a dinner order. Call the type 
;DinnerOrder.


;; DinnerOrder is one of:
;;  - "Chicken"
;;  - "Pasta"
;;  - "No Dinner"
;; interp. dinner options
;;< examples are redundant for enumerations>

#;
(define (fn-for-dinner-orde do)
  (cond [(string=? do "Chicken") (...)]
        [(string=? do "Pasta") (...)]
        [(string=? do "No Dinner") (...)]
        ))

;; Template rules used:
;;  - one of: 3 cases
;;  - atomic distinct: "Chicken"
;;  - atomic distinct: "Pasta"
;;  - atomic distinct: "No Dinner"

;; =================
;; Functions:
;
;
;PROBLEM B:
;
;Design the function dinner-order-to-msg that consumes a dinner order 
;and produces a message for the flight attendants saying what the
;passenger ordered. 
;
;For example, calling dinner-order-to-msg for a chicken dinner would
;produce "The passenger ordered chicken."

;; DinnerOrder -> String
;; produce what dinner ordered
(check-expect (order "Chicken") "The passenger ordered chicken.")
(check-expect (order "Pasta") "The passenger ordered pasta.")
(check-expect (order "No Dinner") "The passenger ordered nothing.")

;(define (order do) "") ;stub

(define (order do)
  (cond [(string=? do "Chicken")  "The passenger ordered chicken."]
        [(string=? do "Pasta") "The passenger ordered pasta."]
        [(string=? do "No Dinner") "The passenger ordered nothing."]
        ))
