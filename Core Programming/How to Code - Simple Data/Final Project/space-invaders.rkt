;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname space-invaders) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

;; Space Invaders

;; Constants:

(define WIDTH  300)
(define HEIGHT 500)

(define INVADER-X-SPEED 1.5)  ;speeds (not velocities) in pixels per tick
(define INVADER-Y-SPEED 1.5)
(define TANK-SPEED 2)
(define MISSILE-SPEED 10)

(define HIT-RANGE 10)

(define INVADE-RATE 100)

(define BACKGROUND (empty-scene WIDTH HEIGHT))

(define INVADER
  (overlay/xy (ellipse 10 15 "outline" "blue")              ;cockpit cover
              -5 6
              (ellipse 20 10 "solid"   "blue")))            ;saucer

(define TANK
  (overlay/xy (overlay (ellipse 28 8 "solid" "black")       ;tread center
                       (ellipse 30 10 "solid" "green"))     ;tread outline
              5 -14
              (above (rectangle 5 10 "solid" "black")       ;gun
                     (rectangle 20 10 "solid" "black"))))   ;main body

(define TANK-HEIGHT/2 (/ (image-height TANK) 2))

(define MISSILE (ellipse 5 15 "solid" "red"))



;; Data Definitions:

(define-struct game (invaders missiles tank))
;; Game is (make-game  (listof Invader) (listof Missile) Tank)
;; interp. the current state of a space invaders game
;;         with the current invaders, missiles and tank position

;; Game constants defined below Missile data definition

#;
(define (fn-for-game s)
  (... (fn-for-loinvader (game-invaders s))
       (fn-for-lom (game-missiles s))
       (fn-for-tank (game-tank s))))



(define-struct tank (x dir))
;; Tank is (make-tank Number Integer[-1, 1])
;; interp. the tank location is x, HEIGHT - TANK-HEIGHT/2 in screen coordinates
;;         the tank moves TANK-SPEED pixels per clock tick left if dir -1, right if dir 1

(define T0 (make-tank (/ WIDTH 2) 1))   ;center going right
(define T1 (make-tank 50 1))            ;going right
(define T2 (make-tank 50 -1))           ;going left

#;
(define (fn-for-tank t)
  (... (tank-x t) (tank-dir t)))



(define-struct invader (x y dx))
;; Invader is (make-invader Number Number Number)
;; interp. the invader is at (x, y) in screen coordinates
;;         the invader along x by dx pixels per clock tick

(define I1 (make-invader 150 100 12))           ;not landed, moving right
(define I2 (make-invader 150 HEIGHT -10))       ;exactly landed, moving left
(define I3 (make-invader 150 (+ HEIGHT 10) 10)) ;> landed, moving right


#;
(define (fn-for-invader invader)
  (... (invader-x invader) (invader-y invader) (invader-dx invader)))


(define-struct missile (x y))
;; Missile is (make-missile Number Number)
;; interp. the missile's location is x y in screen coordinates

(define M1 (make-missile 150 300))                       ;not hit U1
(define M2 (make-missile (invader-x I1) (+ (invader-y I1) 10)))  ;exactly hit U1
(define M3 (make-missile (invader-x I1) (+ (invader-y I1)  5)))  ;> hit U1

#;
(define (fn-for-missile m)
  (... (missile-x m) (missile-y m)))



(define G0 (make-game empty empty T0))
(define G1 (make-game empty empty T1))
(define G2 (make-game (list I1) (list M1) T1))
(define G3 (make-game (list I1 I2) (list M1 M2) T1))



;; =================
;; Functions:

;; MAIN
;; GameState -> GameState
;; runs the Space Invaders game
;; start the world with (main G0)
;; <no tests for main functions>
(define (main g)
  (big-bang g                  ; GameState
    (on-tick   next-state)      ; GameState -> GameState
    (to-draw   render-state)    ; GameState -> Image
    (on-key    handle-key)      ; GameState KeyEvent -> GameState
    (stop-when game-over?)))    ; GameState -> Boolean


;; NEXT-STATE
;; GameState -> GameState
;; update tank, invaders, missiles
;; <no tests for random functions>
;(define (next-state gs) GS0) ;stub
;<template from GameState>
(define (next-state g)
  (cond [(< (random INVADE-RATE) 2)
         (make-game
          (append (list (make-invader (random WIDTH) 0 INVADER-X-SPEED))
                  (next-invaders (game-invaders g) (game-missiles g)))
          (next-missiles (game-invaders g) (game-missiles g))
          (next-tank (game-tank g)))]
        [else
         (make-game (next-invaders (game-invaders g) (game-missiles g))
                    (next-missiles (game-invaders g) (game-missiles g))
                    (next-tank (game-tank g)))]))

;; NEXT-INVADERS
;; (listof Invader) (listof Missile) -> (listof Invader)
;; produces updated list of invaders with new positions
;(check-expect (next-invaders (list I1) (list M1)))
(check-expect (next-invaders (list I1) (list M1))
              (cond [(empty? (list I1)) empty]
                    [(collision-invader? (first (list I1)) (list M1))
                     (next-invaders (rest (list I1)) (list M1))]
                    [else
                     (append (list (next-invader (first (list I1))))
                             (next-invaders (rest (list I1)) (list M1)))]))
(check-expect (next-invaders (list I1 I2) (list M1 M2))
              (cond [(empty? (list I1 I2)) empty]
                    [(collision-invader? (first (list I1 I2)) (list M1 M2))
                     (next-invaders (rest (list I1 I2)) (list M1 M2))]
                    [else
                     (append (list (next-invader (first (list I1 I2))))
                             (next-invaders (rest (list I1 I2)) (list M1 M2)))]))
(check-expect (next-invaders (list I1 I2 I3) (list M1 M2 M3))
              (cond [(empty? (list I1 I2 I3)) empty]
                    [(collision-invader? (first (list I1 I2 I3)) (list M1 M2 M3))
                     (next-invaders (rest (list I1 I2 I3)) (list M1 M2 M3))]
                    [else
                     (append (list (next-invader (first (list I1 I2 I3))))
                             (next-invaders (rest (list I1 I2 I3)) (list M1 M2 M3)))]))

;(define (next-invaders loi lom) loi) ;stub

(define (next-invaders loi lom)
  (cond [(empty? loi) empty]
        [(collision-invader? (first loi) lom) (next-invaders (rest loi) lom)]
        [else
         (append (list (next-invader (first loi)))
                 (next-invaders (rest loi) lom))]))



;; COLLISION-INVADER
;; Invader (listof Missile) -> Boolean
;; produces true if given invader is within hit range
;; of any one of given missiles, false otherwise
(check-expect (collision-invader? I1 (list M1)) false)
(check-expect (collision-invader? I1 (list M1 M2)) true)
(check-expect (collision-invader? I1 (list M1 M2 M3)) true)
;(define (collision-invader? i lom) false) ;stub
(define (collision-invader? i lom)
  (cond [(empty? lom) false]
        [(and
          (<= (- (invader-x i) HIT-RANGE)
              (missile-x (first lom))
              (+ (invader-x i) HIT-RANGE))
          (<= (- (invader-y i) HIT-RANGE)
              (missile-y (first lom))
              (+ (invader-y i) HIT-RANGE)))
         true]
        [else (collision-invader? i (rest lom))]))



;; NEXT-INVADER
;; Invader -> Invader
;; produces updated invader
(check-expect (next-invader I1) (make-invader 162 112 12))
(check-expect (next-invader (make-invader 1 100 -2)) (make-invader 0 100 2))
(check-expect (next-invader (make-invader (- WIDTH 1) 100 2))
              (make-invader WIDTH 100 -2))

;(define (next-invader invader) invader) ; stub

(define (next-invader i)
  (cond [(< 0 (+ (invader-x i) (invader-dx i)) WIDTH)
         (make-invader
          (+ (invader-x i) (invader-dx i))
          (+ (invader-y i) (abs (invader-dx i)))
          (invader-dx i))]
        [(<= (+ (invader-x i) (invader-dx i)) 0)
         (make-invader 0 (invader-y i) (* -1 (invader-dx i)))]
        [(<= WIDTH (+ (invader-x i) (invader-dx i)))
         (make-invader WIDTH (invader-y i) (* -1 (invader-dx i)))]))

;; NEXT-MISSILES
;; (listof Invader) (listof Missile) -> (listof Missile)
;; produces updated list of Missiles with new positions
;; !!!
;(define (next-missiles loi lom) lom) ;stub
;<template from Missile>
(define (next-missiles loi lom)
  (cond [(empty? lom) empty]
        [(<= (- (missile-y (first lom)) MISSILE-SPEED) 0)
         (next-missiles loi (rest lom))]
        [(collision-missile? (first lom) loi)
         (next-missiles loi (rest lom))]
        [else
         (append (list (make-missile
                        (missile-x (first lom))
                        (- (missile-y (first lom)) MISSILE-SPEED)))
                 (next-missiles loi (rest lom)))]))


;; COLLISION-MISSILE
;; Missile (listof Invader) -> Boolean
;; produces true if given missile is within hit range
;; of any one of given invaders, false otherwise
(check-expect (collision-missile? M1 (list I1)) false)
(check-expect (collision-missile? M2 (list I1 I2)) true)
(check-expect (collision-missile? M3 (list I1 I2 I3)) true)
;(define (collision-missile? m loi) false) ;stub
(define (collision-missile? m loi)
  (cond [(empty? loi) false]
        [(and
          (<= (- (missile-x m) HIT-RANGE)
              (invader-x (first loi))
              (+ (missile-x m) HIT-RANGE))
          (<= (- (missile-y m) HIT-RANGE)
              (invader-y (first loi))
              (+ (missile-y m) HIT-RANGE)))
         true]
        [else (collision-missile? m (rest loi))]))


;; NEXT-TANK
;; Tank -> Tank
;; produces updated Tank with new position
(check-expect (next-tank T0)
              (cond [(< 0 (+ (* TANK-SPEED (tank-dir T0)) (tank-x T0)) WIDTH)
                     (make-tank (+ (* TANK-SPEED (tank-dir T0)) (tank-x T0))
                                (tank-dir T0))]
                    [(<= (+ (* TANK-SPEED (tank-dir T0)) (tank-x T0)) 0)
                     (make-tank 0 (tank-dir T0))]
                    [(<= WIDTH (+ (* TANK-SPEED (tank-dir T0)) (tank-x T0)))
                     (make-tank WIDTH (tank-dir T0))]))
(check-expect (next-tank T1)
              (cond [(< 0 (+ (* TANK-SPEED (tank-dir T1)) (tank-x T1)) WIDTH)
                     (make-tank (+ (* TANK-SPEED (tank-dir T1)) (tank-x T1))
                                (tank-dir T1))]
                    [(<= (+ (* TANK-SPEED (tank-dir T1)) (tank-x T1)) 0)
                     (make-tank 0 (tank-dir T1))]
                    [(<= WIDTH (+ (* TANK-SPEED (tank-dir T1)) (tank-x T1)))
                     (make-tank WIDTH (tank-dir T1))]))
(check-expect (next-tank T2)
              (cond [(< 0 (+ (* TANK-SPEED (tank-dir T2)) (tank-x T2)) WIDTH)
                     (make-tank (+ (* TANK-SPEED (tank-dir T2)) (tank-x T2))
                                (tank-dir T2))]
                    [(<= (+ (* TANK-SPEED (tank-dir T2)) (tank-x T2)) 0)
                     (make-tank 0 (tank-dir T2))]
                    [(<= WIDTH (+ (* TANK-SPEED (tank-dir T2)) (tank-x T2)))
                     (make-tank WIDTH (tank-dir T2))]))
;(define (next-tank t) t) ;stub
;<template from Tank>
(define (next-tank t)
  (cond [(< 0 (+ (* TANK-SPEED (tank-dir t)) (tank-x t)) WIDTH)
         (make-tank (+ (* TANK-SPEED (tank-dir t)) (tank-x t))
                    (tank-dir t))]
        [(<= (+ (* TANK-SPEED (tank-dir t)) (tank-x t)) 0)
         (make-tank 0 (tank-dir t))]
        [(<= WIDTH (+ (* TANK-SPEED (tank-dir t)) (tank-x t)))
         (make-tank WIDTH (tank-dir t))]))

;; RENDER-STATE
;; GameState -> Image
;; produces image, rendering given game state
(check-expect (render-state G0)
              (render-invaders (game-invaders G0)
                               (render-missiles (game-missiles G0)
                                                (render-tank (game-tank G0) BACKGROUND))))
(check-expect (render-state G1)
              (render-invaders (game-invaders G1)
                               (render-missiles (game-missiles G1)
                                                (render-tank (game-tank G1) BACKGROUND))))
(check-expect (render-state G2)
              (render-invaders (game-invaders G2)
                               (render-missiles (game-missiles G2)
                                                (render-tank (game-tank G2) BACKGROUND))))
(check-expect (render-state G3)
              (render-invaders (game-invaders G3)
                               (render-missiles (game-missiles G3)
                                                (render-tank (game-tank G3) BACKGROUND))))
;(define (render-state g) g) ;stub
;<template from GameState>
(define (render-state g)
  (render-invaders (game-invaders g)
                   (render-missiles (game-missiles g)
                                    (render-tank (game-tank g) BACKGROUND))))




;; RENDER-INVADERS
;; (listof Invader) Image -> Image
;; produces image of given list of invaders
(check-expect (render-invaders (game-invaders G0) BACKGROUND) BACKGROUND)
(check-expect (render-invaders (game-invaders G1) BACKGROUND) BACKGROUND)
(check-expect (render-invaders (game-invaders G2) BACKGROUND)
              (place-image INVADER
                           (invader-x (first (game-invaders G2)))
                           (invader-y (first (game-invaders G2)))
                           (render-invaders (rest (game-invaders G2))
                                            BACKGROUND)))
(check-expect (render-invaders (game-invaders G3) BACKGROUND)
              (place-image INVADER
                           (invader-x (first (game-invaders G3)))
                           (invader-y (first (game-invaders G3)))
                           (render-invaders (rest (game-invaders G3))
                                            BACKGROUND)))
;(define (render-invaders lst BACKGROUND) BACKGROUND) ;stub
;<template from Invader with additional atomic parameter>
(define (render-invaders lst img)
  (cond [(empty? lst) img]
        [else
         (place-image INVADER
                      (invader-x (first lst))
                      (invader-y (first lst))
                      (render-invaders (rest lst)
                                       img))]))




;; RENDER-MISSILES
;; (listof Missile) Image -> Image
;; produces image of given list of missiles
(check-expect (render-missiles (game-missiles G0) BACKGROUND) BACKGROUND)
(check-expect (render-missiles (game-missiles G1) BACKGROUND) BACKGROUND)
(check-expect (render-missiles (game-missiles G2) BACKGROUND)
              (place-image MISSILE
                           (missile-x (first (game-missiles G2)))
                           (missile-y (first (game-missiles G2)))
                           (render-missiles (rest (game-missiles G2))
                                            BACKGROUND)))
(check-expect (render-missiles (game-missiles G3) BACKGROUND)
              (place-image MISSILE
                           (missile-x (first (game-missiles G3)))
                           (missile-y (first (game-missiles G3)))
                           (render-missiles (rest (game-missiles G3))
                                            BACKGROUND)))
;(define (render-missiles lst img) img) ;stub
;<template from Missile with additional atomic parameter>
(define (render-missiles lst img)
  (cond [(empty? lst) img]
        [else
         (place-image MISSILE
                      (missile-x (first lst))
                      (missile-y (first lst))
                      (render-missiles (rest lst)
                                       img))]))




;; RENDER-TANK
;; Tank Image -> Image
;; produces tank image on top of given image, given tank
(check-expect (render-tank T0 BACKGROUND)
              (place-image TANK
                           (tank-x T0)
                           (- HEIGHT TANK-HEIGHT/2)
                           BACKGROUND))
(check-expect (render-tank T1 BACKGROUND)
              (place-image TANK
                           (tank-x T1)
                           (- HEIGHT TANK-HEIGHT/2)
                           BACKGROUND))
(check-expect (render-tank T2 BACKGROUND)
              (place-image TANK
                           (tank-x T2)
                           (- HEIGHT TANK-HEIGHT/2)
                           BACKGROUND))
;(define (render-tank t img) BACKGROUND) ;stub
;<template from Tank with additional atomic parameter>
(define (render-tank t img)
  (place-image TANK
               (tank-x t)
               (- HEIGHT TANK-HEIGHT/2)
               img))




;; HANDLE-KEY
;; GameState KeyEvent -> GameState
;; move tank left/right on left/right arrow key press
;; shoot missiles on space key press
(check-expect (handle-key G0 "u") G0)
(check-expect (handle-key G1 "left") (handle-key-tank-left G1))
(check-expect (handle-key G2 "right") (handle-key-tank-right G2))
(check-expect (handle-key G3 " ") (handle-key-missile G3))
;(define (handle-key gs ke) GS0)   ;stub
;<template from KeyEvent>
(define (handle-key g ke)
  (cond [(key=? ke " ")     (handle-key-missile g)]
        [(key=? ke "left")  (handle-key-tank-left g)]
        [(key=? ke "right") (handle-key-tank-right g)]
        [else g]))




;; HANDLE-KEY-MISSILE
;; GameState -> GameState
;; produces new game state with additional missile at tank location
(check-expect (handle-key-missile G0)
              (make-game (game-invaders G0)
                         (append (game-missiles G0)
                                 (list (make-missile
                                        (tank-x (game-tank G0))
                                        (- HEIGHT TANK-HEIGHT/2))))
                         (game-tank G0)))
(check-expect (handle-key-missile G1)
              (make-game (game-invaders G1)
                         (append (game-missiles G1)
                                 (list (make-missile
                                        (tank-x (game-tank G1))
                                        (- HEIGHT TANK-HEIGHT/2))))
                         (game-tank G1)))
(check-expect (handle-key-missile G2)
              (make-game (game-invaders G2)
                         (append (game-missiles G2)
                                 (list (make-missile
                                        (tank-x (game-tank G2))
                                        (- HEIGHT TANK-HEIGHT/2))))
                         (game-tank G2)))
(check-expect (handle-key-missile G3)
              (make-game (game-invaders G3)
                         (append (game-missiles G3)
                                 (list (make-missile
                                        (tank-x (game-tank G3))
                                        (- HEIGHT TANK-HEIGHT/2))))
                         (game-tank G3)))
;(define (handle-key-missile g) g) ;stub
;<template from GameState>
(define (handle-key-missile g)
  (make-game (game-invaders g)
             (append (game-missiles g)
                     (list (make-missile
                            (tank-x (game-tank g))
                            (- HEIGHT TANK-HEIGHT/2))))
             (game-tank g)))




;; HANDLE-KEY-TANK-LEFT
;; GameState -> GameState
;; produce new game state with tank-dx changed to -1
(check-expect (handle-key-tank-left G0)
              (make-game (game-invaders G0)
                         (game-missiles G0)
                         (make-tank (tank-x (game-tank G0)) -1)))
(check-expect (handle-key-tank-left G1)
              (make-game (game-invaders G1)
                         (game-missiles G1)
                         (make-tank (tank-x (game-tank G1)) -1)))
(check-expect (handle-key-tank-left G2)
              (make-game (game-invaders G2)
                         (game-missiles G2)
                         (make-tank (tank-x (game-tank G2)) -1)))
(check-expect (handle-key-tank-left G3)
              (make-game (game-invaders G3)
                         (game-missiles G3)
                         (make-tank (tank-x (game-tank G3)) -1)))
;(define (handle-key-tank-left gs) gs) ;stub
;<template from GameState>
(define (handle-key-tank-left g)
  (make-game (game-invaders g)
             (game-missiles g)
             (make-tank (tank-x (game-tank g)) -1)))




;; HANDLE-KEY-TANK-RIGHT
;; GameState -> GameState
;; produce new game state with tank-dx changed to 1
(check-expect (handle-key-tank-right G0)
              (make-game (game-invaders G0)
                         (game-missiles G0)
                         (make-tank (tank-x (game-tank G0)) 1)))
(check-expect (handle-key-tank-right G1)
              (make-game (game-invaders G1)
                         (game-missiles G1)
                         (make-tank (tank-x (game-tank G1)) 1)))
(check-expect (handle-key-tank-right G2)
              (make-game (game-invaders G2)
                         (game-missiles G2)
                         (make-tank (tank-x (game-tank G2)) 1)))
(check-expect (handle-key-tank-right G3)
              (make-game (game-invaders G3)
                         (game-missiles G3)
                         (make-tank (tank-x (game-tank G3)) 1)))
;(define (handle-key-tank-right g) g) ;stub
;<template from GameState>
(define (handle-key-tank-right g)
  (make-game (game-invaders g)
             (game-missiles g)
             (make-tank (tank-x (game-tank g)) 1)))




;; GAME-OVER
;; GameState -> Boolean
;; produces true when an invader reaches bottom of window, false otherwise
(check-expect (game-over? G0)
              (cond[(empty? (game-invaders G0)) false]
                   [else
                    (cond [(<= HEIGHT (invader-y (first (game-invaders G0)))) true]
                          [else (game-over? (make-game
                                             (rest (game-invaders G0))
                                             (game-missiles G0)
                                             (game-tank G0)))])]))
(check-expect (game-over? G1)
              (cond[(empty? (game-invaders G1)) false]
                   [else
                    (cond [(<= HEIGHT (invader-y (first (game-invaders G1)))) true]
                          [else (game-over? (make-game
                                             (rest (game-invaders G1))
                                             (game-missiles G1)
                                             (game-tank G1)))])]))
(check-expect (game-over? G2)
              (cond[(empty? (game-invaders G2)) false]
                   [else
                    (cond [(<= HEIGHT (invader-y (first (game-invaders G2)))) true]
                          [else (game-over? (make-game
                                             (rest (game-invaders G2))
                                             (game-missiles G2)
                                             (game-tank G2)))])]))
(check-expect (game-over? G3)
              (cond[(empty? (game-invaders G3)) false]
                   [else
                    (cond [(<= HEIGHT (invader-y (first (game-invaders G3)))) true]
                          [else (game-over? (make-game
                                             (rest (game-invaders G3))
                                             (game-missiles G3)
                                             (game-tank G3)))])]))
;(define (game-over? g) false) ;stub
;<template from GameState>
(define (game-over? g)
  (cond[(empty? (game-invaders g)) false]
       [else
        (cond [(<= HEIGHT (invader-y (first (game-invaders g)))) true]
              [else (game-over? (make-game
                                 (rest (game-invaders g))
                                 (game-missiles g)
                                 (game-tank g)))])]))