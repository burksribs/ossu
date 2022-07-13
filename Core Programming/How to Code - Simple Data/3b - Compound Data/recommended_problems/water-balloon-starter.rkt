;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname water-balloon-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; water-balloon-starter.rkt

;PROBLEM:
;
;In this problem, we will design an animation of throwing a water balloon.  
;When the program starts the water balloon should appear on the left side 
;of the screen, half-way up.  Since the balloon was thrown, it should 
;fly across the screen, rotating in a clockwise fashion. Pressing the 
;space key should cause the program to start over with the water balloon
;back at the left side of the screen. 
;
;NOTE: Please include your domain analysis at the top in a comment box. 
;
;Use the following images to assist you with your domain analysis:
;
;
;1).
;2) .
;3)  .    
;4)   .
;Here is an image of the water balloon:
;(define WATER-BALLOON ...)
;
;
;
;NOTE: The rotate function wants an angle in degrees as its first 
;argument. By that it means Number[0, 360). As time goes by your balloon 
;may end up spinning more than once, for example, you may get to a point 
;where it has spun 362 degrees, which rotate won't accept. 
;
;The solution to that is to use the modulo function as follows:
;
;(rotate (modulo ... 360) (text "hello" 30 "black"))
;
;where ... should be replaced by the number of degrees to rotate.
;
;NOTE: It is possible to design this program with simple atomic data, 
;but we would like you to use compound data.

(require 2htdp/image)
(require 2htdp/universe)

;; CONSTANTS
(define WIDTH 800)
(define HEIGHT 800)
(define CTR-Y (/ HEIGHT 2))
(define LINEAR-SPEED 3)
(define ANGULAR-SPEED 5)
(define WATER-BALLOON ...)

(define MTS (empty-scene WIDTH HEIGHT))

;; DATA DEFINITON

(define-struct balloon (x dx angle))
;; balloon is (make-balloon (NATURAL[0,WIDTH] INTEGER NATURAL[0,360]
;; interp. (make-balloon x dx angle) is a cow with x coordinate x , x velocity dx and angle is angle
;;         the x is the center of the balloon
;;         x  is in screen coordinates (pixels)
;;         dx is in pixels per tick
;;         angle is rotates image per tick
(define B1 (make-balloon 10 3 0))
(define B2 (make-balloon 10 3 90))

(define (fn-for-balloon b)
  (... (balloon-x b)    ;Natural[0, WIDTH]
       (balloon-dx b)   ;Integer
       (balloon-angle b)    ;Natural[0, 360]
       ))

;; Template rules used:
;;  - compound: 3 fields


;; FUNCTIONS
;; Balloon -> Balloon
;; called to make the balloon go for a fly; start with (main (make-balloon 0 3 0))
;; no tests for main function
(define (main c)
  (big-bang c
            (on-tick next-balloon)       ; Balloon -> Balloon
            (to-draw render-balloon)     ; Balloon -> Image
            (on-key handle-key)))   ; Balloon KeyEvent -> Balloon

;; Balloon -> Balloon
;; increase balloon x by dx; when gets to edge, change dir and move off by 1
(check-expect (next-balloon (make-balloon 20 3 0)) (make-balloon (+ 20 3) 3 (+ 0 5)))
(check-expect (next-balloon (make-balloon WIDTH 3 10)) (make-balloon 0 3 (+ 10 5)))

(define (next-balloon b)
  (if (> (+ (balloon-x b) (balloon-dx b)) WIDTH)
      (make-balloon 0 LINEAR-SPEED (+ (balloon-angle b) ANGULAR-SPEED))
      (make-balloon (+ (balloon-x b) (balloon-dx b)) LINEAR-SPEED (+ (balloon-angle b) ANGULAR-SPEED))))


;; Balloon -> Image
;; place appropriate balloon image on MTS at (cow-x c) and CTR-Y
(check-expect (render-balloon (make-balloon 100 LINEAR-SPEED 50))
              (place-image (rotate (modulo 50 360) WATER-BALLOON) 100 CTR-Y MTS))

;(define (render-balloon b) MTS)  ;stub  

; took template from Balloon
(define (render-balloon b)
  (place-image (rotate (modulo (balloon-angle b) 360) WATER-BALLOON) (balloon-x b) CTR-Y MTS))



;; Balloon KeyEvent-> Balloon
;; reset balloon when space bar is pressed

;(define (handle-key b ke) b) ;stub

(define (handle-key b ke)
  (cond [(key=? ke " ") (make-balloon 0 LINEAR-SPEED 0)] 
        [else b]))
