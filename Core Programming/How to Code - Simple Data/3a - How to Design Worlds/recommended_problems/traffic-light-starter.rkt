;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname traffic-light-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

;; traffic-light-starter.rkt

;
;PROBLEM:
;
;Design an animation of a traffic light. 
;
;Your program should show a traffic light that is red, then green, 
;then yellow, then red etc. For this program, your changing world 
;state data definition should be an enumeration.
;
;Here is what your program might look like if the initial world 
;state was the red traffic light:
;...
;Next:
;...
;Next:
;...
;Next is red, and so on.
;
;To make your lights change at a reasonable speed, you can use the 
;rate option to on-tick. If you say, for example, (on-tick next-color 1) 
;then big-bang will wait 1 second between calls to next-color.
;
;Remember to follow the HtDW recipe! Be sure to do a proper domain 
;analysis before starting to work on the code file.
;
;Note: If you want to design a slightly simpler version of the program,
;you can modify it to display a single circle that changes color, rather
;than three stacked circles. 


;; =================
;; Constants:

(define BACKGROUND (rectangle 100 200 "solid" "black"))
(define BLANK (square 5 "solid" "black"))

(define R 30)

(define REDLIGHT (overlay (above (circle R "solid" "red")
                                 BLANK
                                 (circle R "outline" "yellow")
                                 BLANK
                                 (circle R "outline" "green"))
                          BACKGROUND))
(define YELLOWLIGHT (overlay (above (circle R "outline" "red")
                                 BLANK
                                 (circle R "solid" "yellow")
                                 BLANK
                                 (circle R "outline" "green"))
                          BACKGROUND))
(define GREENLIGHT (overlay (above (circle R "outline" "red")
                                 BLANK
                                 (circle R "outline" "yellow")
                                 BLANK
                                 (circle R "solid" "green"))
                          BACKGROUND))

(define SPEED 1)

;; =================
;; Data definitions:

;; TrafficLight is one of:
;;  - "red"
;;  - "green"
;;  - "yellow"
;; interp. represent traffic lights

(define (fn-for-trafic-light tl)
  (cond [(string? "red" tl) (...)]
        [(string? "green" tl) (...)]
        [(string? "yellow" tl) (...)]))

;; Templater rule used:
;;  - one of: 3 cases
;;  - atomic distinct: "red"
;;  - atomic distinct: "green"
;;  - atomic distinct: "yellow"

;; =================
;; Functions:

;; TrafficLight -> TrafficLight
;; start the world with (main tl)
;; 
(define (main tl)
  (big-bang tl                   ; TrafficLight
            (on-tick   next-light SPEED)     ; TrafficLight -> TrafficLight
            (to-draw   render))) ; TrafficLight -> Image

;; TrafficLight -> TrafficLight
;; produce the next light
(check-expect (next-light "red") "green")
(check-expect (next-light "yellow") "red")
(check-expect (next-light "green") "yellow")

;(define (next-light tl) "") ;stub

; <template rule used from TrafficLight>

(define (next-light tl)
  (cond [(string=? "red" tl) "green"]
        [(string=? "green" tl) "yellow"]
        [(string=? "yellow" tl) "red"]))


;; TrafficLight -> Image
;; render traffic light
(check-expect (render "red") REDLIGHT)
(check-expect (render "yellow") YELLOWLIGHT)
(check-expect (render "green") GREENLIGHT)

;(define (render tl) "") ;stub


(define (render tl)
  (cond [(string=? "red" tl)
         REDLIGHT]
        [(string=? "green" tl)
         GREENLIGHT]
        [(string=? "yellow" tl)
         YELLOWLIGHT]))