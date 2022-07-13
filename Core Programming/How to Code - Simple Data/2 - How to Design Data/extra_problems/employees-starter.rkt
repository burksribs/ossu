;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname employees-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; employees-starter.rkt

;; =================
;; Data definitions:


;PROBLEM A:
;
;You work in the Human Resources department at a ski lodge. 
;Because the lodge is busier at certain times of year, 
;the number of employees fluctuates. 
;There are always more than 10, but the maximum is 50.
;
;Design a data definition to represent the number of ski lodge employees. 
;Call it Employees.

;; Employees is Natural(10,50]
;; interp. number of ski lodge employees

#;
(define (fn-for-employee e)
  (... e))

;; template rule is:
;;  - atomic non-distinct: Natural(10,50]

;; =================
;; Functions:


;PROBLEM B:
;
;Now design a function that will calculate the total payroll for the quarter.
;Each employee is paid $1,500 per quarter. Call it calculate-payroll.
;

;; Employee -> Number
;; calculate the total payroll for the quarter.
(check-expect (calculate-payroll 20) 30000)

;(define (calculate-payroll e) 0) ; stub

(define (calculate-payroll e)
  (* e 1500))