;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname countdown-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; countdown-starter.rkt

;
;PROBLEM:
;
;Consider designing the system for controlling a New Year's Eve
;display. Design a data definition to represent the current state 
;of the countdown, which falls into one of three categories: 
;
; - not yet started
; - from 10 to 1 seconds before midnight
; - complete (Happy New Year!)

;; Countdown is one of:
;;  - false          means countdown has not yet started
;;  - Natural[1, 10]  means countdown is running and how many seconds left
;;  - "complete"     means countdown is over
;; interp. false means countdown has not started, "complete" is end of the countdown

(define CD1 false)
(define CD2 1)
(define CD3 10)
(define CD4 "complete")

#;
(define (fn-for-countdown cd)
  (cond [(false? cd) (...)]
        [(and (number? cd) (<= 1 cd) (<= cd 10)) (... cd)]
        [else (...)]))

;; template rule used:
;;  - one of: 3 cases
;;  - atomic distinct: false
;;  - atomic non-distinct: Natural[1,10]
;;  - atomic distinct: "complete"