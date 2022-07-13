;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname yell-all-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; yell-all-starter.rkt

;; =================
;; Data definitions:


;Remember the data definition for a list of strings we designed in Lecture 5c:
;(if this data definition does not look familiar, please review the lecture)


;; ListOfString is one of: 
;;  - empty
;;  - (cons String ListOfString)
;; interp. a list of strings

(define LS0 empty) 
(define LS1 (cons "a" empty))
(define LS2 (cons "a" (cons "b" empty)))
(define LS3 (cons "c" (cons "b" (cons "a" empty))))

#;
(define (fn-for-los los) 
  (cond [(empty? los) (...)]
        [else
         (... (first los)
              (fn-for-los (rest los)))]))

;; Template rules used: 
;; - one of: 2 cases
;; - atomic distinct: empty
;; - compound: (cons String ListOfString)
;; - self-reference: (rest los) is ListOfString

;; =================
;; Functions:


;PROBLEM:
;
;Design a function that consumes a list of strings and "yells" each word by 
;adding "!" to the end of each string.
;


;; ListOfString -> ListOfString
;; add "!" to the end of each string in the list
(check-expect (yell LS0) empty)
(check-expect (yell LS1) (cons "a!" empty))
(check-expect (yell LS2) (cons "a!" (cons "b!" empty)))
(check-expect (yell LS3) (cons "c!" (cons "b!" (cons "a!" empty))))

;(define (yell los) empty) ;stub
  
(define (yell los) 
  (cond [(empty? los) empty]
        [else
         (cons (string-append (first los) "!")
               (yell (rest los)))]))