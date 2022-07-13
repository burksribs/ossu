;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname countdown-animation-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

;; countdown-animation starter.rkt


;PROBLEM:
;
;Design an animation of a simple countdown. 
;
;Your program should display a simple countdown, that starts at ten, and
;decreases by one each clock tick until it reaches zero, and stays there.
;
;To make your countdown progress at a reasonable speed, you can use the 
;rate option to on-tick. If you say, for example, 
;(on-tick advance-countdown 1) then big-bang will wait 1 second between 
;calls to advance-countdown.
;
;Remember to follow the HtDW recipe! Be sure to do a proper domain 
;analysis before starting to work on the code file.
;
;Once you are finished the simple version of the program, you can improve
;it by reseting the countdown to ten when you press the spacebar.

;; My world program  (make this more specific)

;; =================
;; Constants:
(define WIDTH 50)
(define HEIGHT 100)
(define FONT-SIZE 24)
(define FONT-COLOR "black")
(define CTR-X (/ WIDTH 2))
(define CTR-Y (/ HEIGHT 2))
(define MTS (empty-scene WIDTH HEIGHT))


;; =================
;; Data definitions:

;; Countdown is Natural[0,10]
;; numbers represent countdowns
(define CD1 0)
(define CD2 10)

(define (fn-for-countdown cd)
  (... cd))

;; Template rule used:
;;  - atomic non-distinct: Natural[0,10]


;; =================
;; Functions:

;; Countdown -> Countdown
;; start the world with (main 10)
;; 
(define (main cd)
  (big-bang cd                   ; Countdown
            (on-tick   tock 1)     ; Countdown -> Countdown
            (to-draw   render)   ; Countdown -> Image
            (on-key    handle-key)))    ; Countdown KeyEvent -> Countdown

;; Countdown -> Countdown
;; produce the next countdown
(check-expect (tock 0) 0)
(check-expect (tock 10) 9)

;(define (tock cd) 0) ;stub

;; <template rule used from Countdown>

(define (tock cd)
  (if (< 0 cd)
      (- cd 1)
      cd))

;; Countdown -> Image
;; render countdown
(check-expect (render 5) (place-image (text "5" FONT-SIZE FONT-COLOR) CTR-X CTR-Y MTS))

;(define (render cd) cd) ;stub

;; <template rule used from Countdown>

(define (render cd)
  (place-image (text (number->string cd) FONT-SIZE FONT-COLOR) CTR-X CTR-Y MTS))

;; Countdown KeyEvent -> Countdown
;; space key, reset countdown to beginning countdown
(check-expect (handle-key 10 " ") 10)
(check-expect (handle-key 10 "a") 10)
(check-expect (handle-key  0 " ") 10)
(check-expect (handle-key  0 "a") 0)

;(define (handle-key cd ke) 0) ;stub

(define (handle-key cd ke)
  (cond [(key=? ke " ") 10]
        [else cd]))