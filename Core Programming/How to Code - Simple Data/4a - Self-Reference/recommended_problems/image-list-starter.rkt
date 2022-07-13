;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname image-list-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; image-list-starter.rkt

;; =================
;; Data definitions:


;PROBLEM A:
;
;Design a data definition to represent a list of images. Call it ListOfImage. 

;; ListOfImage is one of:
;;  - empty
;;  - (cons Image ListOfImage)
;; interp. a list of images
(define LOI1 empty)
(define LOI2 (cons (rectangle 40 60 "solid" "red") (cons (rectangle 10 42 "solid" "black") empty)))
#;
(define (fn-for-loi loi)
  (cond [(empty? loi) (...)]
        [else
         (... (first loi)
              (fn-for-loi (rest loi)))]))

;; Template rules used:
;;  - one of: 2 cases
;;  - atomic distinct: empty
;;  - compound: (cons Number ListOfNumber)
;;  - self-reference: (rest lon) is ListOfNumber

;; =================
;; Functions:


;PROBLEM B:
;
;Design a function that consumes a list of images and produces a number 
;that is the sum of the areas of each image. For area, just use the image's 
;width times its height.


;; ListOfImage -> Natural
;; produce sum of area of all images
(check-expect (sum-areas LOI1) 0)
(check-expect (sum-areas LOI2) 2820)

;(define (sum-areas loi) 0) ;stub

(define (sum-areas lon)
  (cond [(empty? lon) 0]
        [else
         (+ (* (image-width (first lon)) (image-height (first lon)))
               (sum-areas (rest lon)))]))