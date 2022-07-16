;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname challenge) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
#lang racket
(define-syntax while-less
  (syntax-rules (do)
    ((while-less x do y)
     (let ([z x])
        (letrec ([loop (lambda ()
                         (let ([w y])
                           (if (or (not (number? w)) (>= w z))
                               #t
                               (loop))))])
          (loop))))))