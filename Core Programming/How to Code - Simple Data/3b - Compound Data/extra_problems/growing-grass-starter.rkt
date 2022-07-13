;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname growing-grass-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

;; growing-grass-starter.rkt

;
;PROBLEM:
;
;Design a world program as follows:
;
;The world starts off with a piece of grass waiting to grow. As time passes, 
;the grass grows upwards. Pressing any key cuts the current strand of 
;grass to 0, allowing a new piece to grow to the right of it.
;
;Starting display:
;
;...
;
;After a few seconds:
;
;...
;After a few more seconds:
;
;...
;
;Immediately after pressing any key:
;
;...
;
;A few more seconds after pressing any key:
;
;...
;
;NOTE 1: Remember to follow the HtDW recipe! Be sure to do a proper domain 
;analysis before starting to work on the code file.


(require 2htdp/image)
(require 2htdp/universe)

;; Growing grass

;; =================
;; Constants:

(define WIDTH 800)
(define HEIGHT 600)

(define MTS (rectangle WIDTH HEIGHT "solid" "sky blue"))

(define GRASS-COLOR "green")
(define GRASS-WIDTH 10)
(define GRASS-Y HEIGHT)

(define GROW-SPEED 2)

;; =================
;; Data definitions:

(define-struct grass (x h))
;; Grass is (make-grass Number[0,WIDTH] Number[HEIGHT, 0]
;; interp. x position of grass
;;         h height of grass

(define G1 (make-grass 0 HEIGHT))
(define G2 (make-grass 10 4))

(define (fn-for-grass g)
 (... (grass-x g)   ;Number[0,WIDTH]
      (grass-h g))) ;Number[HEIGHT, 0]

;; Template Rules
;; - compound: 2 fields

;; =================
;; Functions:

;; Grass -> Grass
;; start the world with (main g)
;; 
(define (main g)
  (big-bang g                   ; Grass
            (on-tick   grow-up)     ; Grass -> Grass
            (to-draw   render-grass)   ; Grass -> Image
            (on-key    handle-key)))    ; Grass KeyEvent -> Grass

;; Grass -> Grass
;; produce the next Grass
(check-expect (grow-up (make-grass 0 HEIGHT)) (make-grass 0 HEIGHT))
(check-expect (grow-up (make-grass 50 50)) (make-grass 50 (+ 50 GROW-SPEED)))
(check-expect (grow-up (make-grass 50 1)) (make-grass 50 3))

;(define (grow-up g) g) ;stub

(define (grow-up g)
 (if (> (+ (grass-h g) GROW-SPEED) HEIGHT)
     (make-grass (grass-x g) HEIGHT)
     (make-grass (grass-x g) (+ (grass-h g) GROW-SPEED))))


;; Grass -> Image
;; render grass 
(check-expect (render-grass (make-grass 50 50)) (place-image (rectangle GRASS-WIDTH 50 "solid" GRASS-COLOR)
                                                             50 GRASS-Y
                                                             MTS))
(check-expect (render-grass (make-grass 50 1)) (place-image (rectangle GRASS-WIDTH 1 "solid" GRASS-COLOR)
                                                             50 GRASS-Y
                                                             MTS))
;(define (render-grass g) g) ;stub

(define (render-grass g)
 (place-image (rectangle GRASS-WIDTH (grass-h g) "solid" GRASS-COLOR)
                                                             (grass-x g) GRASS-Y
                                                             MTS))


;; Grass KeyEvent -> Grass
;; if space key pressed grass growing next x
(check-expect (handle-key (make-grass 50 10) " ") (make-grass (+ 50 GRASS-WIDTH) 0))

(define (handle-key g ke)
  (cond [(key=? ke " ") (make-grass (+ (grass-x g) GRASS-WIDTH) 0)]
        [else 
         g]))