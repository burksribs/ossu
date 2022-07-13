;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname spinning-bears-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; spinning-bears-starter.rkt

(require 2htdp/image)
(require 2htdp/universe)
;
;PROBLEM:
;
;In this problem you will design another world program. In this program the changing 
;information will be more complex - your type definitions will involve arbitrary 
;sized data as well as the reference rule and compound data. But by doing your 
;design in two phases you will be able to manage this complexity. As a whole, this problem 
;will represent an excellent summary of the material covered so far in the course, and world 
;programs in particular.
;
;This world is about spinning bears. The world will start with an empty screen. Clicking
;anywhere on the screen will cause a bear to appear at that spot. The bear starts out upright,
;but then rotates counterclockwise at a constant speed. Each time the mouse is clicked on the 
;screen, a new upright bear appears and starts spinning.
;
;So each bear has its own x and y position, as well as its angle of rotation. And there are an
;arbitrary amount of bears.
;
;To start, design a world that has only one spinning bear. Initially, the world will start
;with one bear spinning in the center at the screen. Clicking the mouse at a spot on the
;world will replace the old bear with a new bear at the new spot. You can do this part 
;with only material up through compound. 
;
;Once this is working you should expand the program to include an arbitrary number of bears.
;
;Here is an image of a bear for you to use: .

;; ========================
;; CONSTANTS
(define WIDTH 800)
(define HEIGHT 600)
(define MTS (empty-scene WIDTH HEIGHT))
(define BEAR-IMG .)
(define SPEED 5)

;; ========================
;; DATA DEFINITONS

(define-struct bear (x y a))
;; bear is (make-bear Number[0,WIDTH] Number[0,HEIGHT] Integer)
;; interp. x and y are coordinates, a is angle of rotation in degrees

(define B1 (make-bear 0 0 0)) ; bear in the upper left corner
(define B2 (make-bear (/ WIDTH 2) (/ HEIGHT 2) 0)) ; bear in the middle of screen

#;
(define (fn-for-bear b)
  (... (bear-x b)   ;Number[0,WIDTH]
       (bear-y b)   ;Number[0,HEIGHT]
       (bear-a b))) ;Integer

;Template rule used:
; - compound: 3 fields


;; ListOfBear is one of:
;;  - empty
;;  - (cons Bear ListOfBear)
(define LOB1 empty)
(define LOB2 (cons (make-bear 2 3 5)empty))
(define LOB3 (cons (make-bear 455 421 90)(cons (make-bear 2 3 5)empty)))

#;
(define (fn-for-lob lob)
  (cond [(empty? lob) (...)]
        [else
         (... (fn-for-bear (first lob))
              (fn-for-lob (rest lob)))]))

;; Template rules used:
;;  - one of: 2 cases
;;  - atomic distinct: empty
;;  - compound: (cons Bear ListOfBear)
;;  - reference: (first lob) is Bear 
;;  - self-reference: (rest lob) is ListOfBear

;; ========================
;; FUNCTIONS

;; ListOfBear -> ListOfBear
;; start the world with (main empty)
;; 
(define (main lob)
  (big-bang lob                   ; ListOfBear
            (on-tick   spin-bears)     ; ListOfBear -> ListOfBear
            (to-draw   render-bears)   ; ListOfBear -> Image
            (on-mouse  handle-mouse)      ; ListOfBear Integer Integer MouseEvent -> ListOfBear
            ))


;; ListOfBear -> ListOfBear
;; spin all of the bears forward by SPEED degrees
(check-expect (spin-bears empty) empty)
(check-expect (spin-bears (cons (make-bear 10 10 5) empty))
              (cons (make-bear 10 10 (+ 5 SPEED))empty))
(check-expect (spin-bears (cons (make-bear 451 551 30) (cons (make-bear 10 10 5) empty)))
              (cons (make-bear 451 551 (+ 30 SPEED)) (cons (make-bear 10 10 (+ 5 SPEED))empty)))

;(define (spin-bears b) b) ;stub

; <template from ListOfBear>
(define (spin-bears lob)
  (cond [(empty? lob) empty]
        [else
         (cons (spin-a-bear (first lob))
              (spin-bears (rest lob)))]))


;; Bear -> Bear
;; spin a bear forward by SPEED degrees
(check-expect (spin-a-bear (make-bear 10 10 10)) (make-bear 10 10 (+ 10 SPEED)))

; (define (spin-a-bear b) b); stub

; <template from Bear>
(define (spin-a-bear b)
  (make-bear (bear-x b)
             (bear-y b)
             (+ SPEED (bear-a b))))


;; ListOfBear -> Image
;; render the bears onto the empty scene
(check-expect (render-bears empty) MTS)
(check-expect (render-bears (cons (make-bear 0 0 0) empty))
              (place-image (rotate 0 BEAR-IMG) 0 0 MTS))
(check-expect (render-bears
               (cons (make-bear 0 0 0)
                     (cons (make-bear (/ WIDTH 2) (/ HEIGHT 2) 90)
                           empty)))
              (place-image (rotate 0 BEAR-IMG) 0 0
                           (place-image (rotate 90 BEAR-IMG) (/ WIDTH 2) (/ HEIGHT 2)
                                        MTS)))

;(define (render-bears lob) MTS)

; <template from ListOfBear
(define (render-bears lob)
  (cond [(empty? lob) MTS]
        [else
         (render-bear-on (first lob)
              (render-bears (rest lob)))]))


;; Bear Image -> Image
;; render an image of the bear on the given image
(check-expect (render-bear-on (make-bear 0 0 0) MTS) (place-image (rotate 0 BEAR-IMG) 0 0 MTS))
(check-expect (render-bear-on (make-bear (/ WIDTH 2) (/ HEIGHT 2) 90) MTS)
              (place-image (rotate 90 BEAR-IMG) (/ WIDTH 2) (/ HEIGHT 2) MTS))

;(define (render-bear-on b img) MTS)

(define (render-bear-on b img)
  (place-image (rotate (modulo (bear-a b) 360) BEAR-IMG) (bear-x b) (bear-y b) img))



;; ListOfBear Integer Integer MouseEvent -> ListOfBear
;; On mouse-click, adds a bear with 0 rotation to the list at the x, y location
(check-expect (handle-mouse empty 13 54 "button-down") (cons (make-bear 13 54 0) empty))
(check-expect (handle-mouse empty 13 54 "move") empty)

; (define (handle-mouse lob x y me) empty) ; stub

(define (handle-mouse lob x y me)
  (cond [(mouse=? me "button-down") (cons (make-bear x y 0) lob)]
        [else lob]))