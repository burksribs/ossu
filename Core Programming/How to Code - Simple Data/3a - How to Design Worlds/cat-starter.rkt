;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname cat-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; cat-starter.rkt

;
;PROBLEM:
;
;Use the How to Design Worlds recipe to design an interactive
;program in which a cat starts at the left edge of the display 
;and then walks across the screen to the right. When the cat
;reaches the right edge it should just keep going right off 
;the screen.
;
;Once your design is complete revise it to add a new feature,
;which is that pressing the space key should cause the cat to
;go back to the left edge of the screen. When you do this, go
;all the way back to your domain analysis and incorporate the
;new feature.
;
;To help you get started, here is a picture of a cat, which we
;have taken from the 2nd edition of the How to Design Programs 
;book on which this course is based.
;
;...

(require 2htdp/image)
(require 2htdp/universe)

;; A caat that walsk from left to right across the screen

;; ==============
;; Constants:

(define WIDTH 600)
(define HEIGHT 400)
(define CTR-Y (/ HEIGHT 2))
(define MTS (empty-scene WIDTH HEIGHT))
(define CAT-IMG ...)

(define SPEED 2)

;; =============
;; Data definitions:

;; Cat is Number
;; interp. x coordinates of cat
(define C1 0)             ;left edge
(define C2 (/ WIDTH 2))   ;middle
(define C3 WIDTH)         ;right edge

#;
(define (fn-for-cat c)
  (... c))

;; Template rules used:
;; - atomic non-distinct: Number

;; =================
;; Functions:

;; Cat -> Cat
;; start the world with ...
;;
(define (main c)
  (big-bang c                         ;Cat
            (on-tick advance-cat)     ;Cat -> Cat
            (to-draw render)))        ;Cat -> Image

;; Cat -> Cat
;; produce the next cat, by advancing it 1 pixel to right
(check-expect (advance-cat 3) (+ 3 SPEED))

;(define (advance-cat c) 0) ;stub

;<use template from Cat>

(define (advance-cat c)
  (+ c SPEED))

;; Cat -> Image
;; render the cat image at appropriate place on MTS
(check-expect (render 4) (place-image CAT-IMG 4 CTR-Y MTS))

;(define (render c) MTS) ;stub

(define (render c)
  (place-image CAT-IMG c CTR-Y MTS))


;; Cat KeyEvent -> Cat
;; reset cat to left edgen when space key is pressed
(check-expect (handle-key 10 " ") 0)
(check-expect (handle-key 10 "a") 10)
(check-expect (handle-key  0 " ") 0)
(check-expect (handle-key  0 "a") 0)

;(define (handle-key c ke) 0) ;stub

(define (handle-key c ke)
  (cond [(key=? ke " ") 0]
        [else c]))