;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname make-box-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; make-box-starter.rkt


;PROBLEM:
;
;You might want to create boxes of different colours.
;
;Use the How to Design Functions (HtDF) recipe to design a function that consumes a color, and creates a 
;solid 10x10 square of that colour.  Follow the HtDF recipe and leave behind commented out versions of
;the stub and template.
;

;; String -> Image
;; makes 10x10 square with given color
(check-expect (color-square "red") (square 10 "solid" "red"))

;(define (color-square c) (square 0 "solid" "white")) ; stub

#;
(define (color-square c) ;template
  (... c))

(define (color-square c)
  (square 10 "solid" c))

