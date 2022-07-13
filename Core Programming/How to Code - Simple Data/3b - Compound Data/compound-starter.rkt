;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname compound-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; compound-starter.rkt

;
;PROBLEM:
;
;Design a data definition to represent hockey players, including both 
;their first and last names.

(define-struct player (fn ln))
;; HockeyPlayer is (make-player String String)
;; interp. (make-player fn ln) is a hockey player with
;;           first name fn
;;           last name ln
(define P1 (make-player "Bobby" "Orr"))
(define P2 (make-player "Wayne" "Gretzky"))

(define (fn-for-player p)
  (... (player-fn p)   ;String
       (player-ln p))) ;String

;; Template rule used:
;;  - compound: 2 fields
