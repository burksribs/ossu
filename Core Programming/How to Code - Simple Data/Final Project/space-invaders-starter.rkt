;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname space-invaders-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

;; Game -> Game
;; start the world with (main G0)
;; 
(define (main s)
  (big-bang s                   ; Game
    (on-tick   advanced-game)     ; Game -> Game
    (to-draw   render-game)   ; Game -> Image
    (stop-when game-over?)      ; Game -> Boolean
    (on-key    handle-key)))    ; Game KeyEvent -> Game

;; Game -> Game
;; produce the next game state
;(define (advanced-game s) s) ; stub

(define (advanced-game s)
  (make-game (next-invaders (destroy-invaders (game-missiles s) (add-invader (game-invaders s))))
             (next-missiles (destroy-missiles (game-missiles s) (game-invaders s)))
             (next-tank (game-tank s))))

;; ListOfInvader -> ListOfInvader
;; produce next invaders
(check-expect (next-invaders empty) empty)
(check-expect (next-invaders (list I1)) (list (make-invader (+ 150 (* 12 INVADER-X-SPEED)) (+ 100 INVADER-Y-SPEED) 12)))

;(define (next-invaders loi) loi)

(define (next-invaders loi)
  (cond[(empty? loi) empty]
       [else
        (cons (move-invader (first loi))
              (next-invaders (rest loi)))]))

;; Invader -> Invader
;; moves an invader in the direction it is travelling, will bounce off walls
(check-expect (move-invader I1) (make-invader (+ 150 (* INVADER-X-SPEED 12)) (+ 100 INVADER-Y-SPEED) 12)) ;middle of screen: keep movin
(check-expect (move-invader (make-invader WIDTH 100 1)) (make-invader WIDTH (+ 100 INVADER-Y-SPEED) -1))  ;right edge: reverse velocity
(check-expect (move-invader (make-invader WIDTH 100 -1)) (make-invader (- WIDTH INVADER-X-SPEED) (+ 100 INVADER-Y-SPEED) -1)) ;right edge: moving left, keep going
(check-expect (move-invader (make-invader 0 100 -1)) (make-invader 0 (+ 100 INVADER-Y-SPEED) 1)) ;left edge, moving left: reverse direction
(check-expect (move-invader (make-invader (+ 0 (- INVADER-X-SPEED 1)) 100 -1)) (make-invader 0 (+ INVADER-Y-SPEED 100) 1)) ;will exceed left edge, set to 0 and reverse direction
;(define (move-invader i) i) ;stub

(define (move-invader i)
  (cond [(< (+ (invader-x i) (* (invader-dx i) INVADER-X-SPEED)) 0)
         (make-invader 0 (+ (invader-y i) INVADER-Y-SPEED) (- (invader-dx i)))]
        [(> (+ (invader-x i) (* (invader-dx i) INVADER-X-SPEED)) WIDTH)
         (make-invader WIDTH (+ (invader-y i) INVADER-Y-SPEED) (- (invader-dx i)))]
        [else
         (make-invader (+ (invader-x i) (* INVADER-X-SPEED (invader-dx i))) (+ (invader-y i) INVADER-Y-SPEED) (invader-dx i))]))

;; ListOfInvader -> ListOfInvader
;; add new invader

;(define (add-invader loi) loi)

(define (add-invader loi)
  (cond[(< (random INVADE-RATE) 2)
        (cons (make-invader (random WIDTH) 0 1) loi)]
       [else loi]))

;; ListOfMissile ListOfInvader -> ListOfInvader
;; destroy invaders that have collided with the missiles

;(define (destroy-invaders lom loi) loi)

(define (destroy-invaders lom loi)
  (cond[(empty? loi) empty]
       [(empty? lom) loi]
       [else
        (if (collide-invader? (first loi) lom)
            (rest loi)
            (cons (first loi) (destroy-invaders lom (rest loi))))]))

;; Invader ListOfMissile -> Boolean
;; produce true if the invaders hit missile
(check-expect (collide-invader? I1 (list M1)) false)
(check-expect (collide-invader? I1 (list M1 M2 M3)) true)
;(define (collide-invader i lom) false)

(define (collide-invader? i lom)
  (cond[(empty? lom) false]
       [else
        (if (and (< (- (invader-x i) HIT-RANGE) (missile-x (first lom)) (+ (invader-x i) HIT-RANGE))
                 (< (- (invader-y i) HIT-RANGE) (missile-y (first lom)) (+ (invader-y i) HIT-RANGE)))
            true
            (collide-invader? i (rest lom)))]))
  
;; ListOfMissile -> ListOfMissile
;; produce next missiles

;(define (next-missiles lom) lom) ;stub
  
(define (next-missiles lom)
  (cond [(empty? lom) empty]
        [else
         (if (< (missile-y (first lom)) 0)
             (next-missiles (rest lom))
             (append (list (move-missile (first lom)))
                     (next-missiles (rest lom))))]))

;; Missile -> Missile
;; produce next missile
(check-expect (move-missile (make-missile 150 150)) (make-missile 150 (- 150 MISSILE-SPEED)))

;(define (move-missile m) m) ;stub

(define (move-missile m)
  (make-missile (missile-x m) (- (missile-y m) MISSILE-SPEED)))


;; ListOfMissile ListOfInvader -> ListOfMissile
;; destroy missiles that have collided with the invaders

;(define (destroy-missiles lom loi) loi)

(define (destroy-missiles lom loi)
  (cond[(empty? loi) lom]
       [(empty? lom) empty]
       [else
        (if (collide-missile? (first lom) loi)
            (rest lom)
            (cons (first lom) (destroy-missiles (rest lom) loi)))]))

;; Invader ListOfMissile -> Boolean
;; if the invaders x and y position is found within the hitbox of the missile, return true
(check-expect (collide-missile? M1 (list I1)) false)
(check-expect (collide-missile? M3 (list I1 I2 I3)) true)

;(define (collide-missile? m loi) false)

(define (collide-missile? m loi)
  (cond [(empty? loi) false]
        [else
         (if (and (< (- (invader-x (first loi)) HIT-RANGE) (missile-x m) (+ (invader-x (first loi)) HIT-RANGE))
                  (< (- (invader-y (first loi)) HIT-RANGE) (missile-y m) (+ (invader-y (first loi)) HIT-RANGE)))
             true
             (collide-missile? m (rest loi)))]))


;; Tank -> Tank
;; produce next tank
(check-expect (next-tank (make-tank 50 1)) (make-tank (+ 50 TANK-SPEED) 1))
(check-expect (next-tank (make-tank (- WIDTH 1) 1)) (make-tank WIDTH -1))
(check-expect (next-tank (make-tank (- 0 1) -1)) (make-tank 0 1))

;(define (next-tank t) t) ;stub

(define (next-tank t)
  (cond [(>= 0 (+ (tank-x t) (* TANK-SPEED (tank-dir t))))
         (make-tank 0 1)]
        [(<= WIDTH (+ (tank-x t) (* TANK-SPEED (tank-dir t))))
         (make-tank WIDTH -1)]
        [else
         (make-tank (+ (tank-x t) (* TANK-SPEED (tank-dir t))) (tank-dir t))]))



;; Game -> Image
;; render the images of current state
(check-expect (render-game G2)
              (render-invaders (game-invaders G2)
                               (render-missiles (game-missiles G2)
                                                (render-tank (game-tank G2)))))
;(define (render-game g) BACKGROUND) ;stub

(define (render-game s)
  (render-invaders (game-invaders s)
                   (render-missiles (game-missiles s)
                                    (render-tank (game-tank s)))))

;; ListOfInvader -> Image
;; render invaders
(check-expect (render-invaders (game-invaders G2) BACKGROUND)
              (place-image INVADER
                           (invader-x (first (game-invaders G2)))
                           (invader-y (first (game-invaders G2)))
                           (render-invaders (rest (game-invaders G2))
                                            BACKGROUND)))
;(define (render-invaders loi img) img) ;stub

(define (render-invaders loi img)
  (cond [(empty? loi) img]
        [else
         (place-image INVADER
                      (invader-x (first loi)) (invader-y (first loi))
                      (render-invaders (rest loi) img))]))

;; ListOfMissile -> Image
;; render missiles
(check-expect (render-missiles (game-missiles G2) BACKGROUND)
              (place-image MISSILE
                           (missile-x (first (game-missiles G2)))
                           (missile-y (first (game-missiles G2)))
                           (render-missiles (rest (game-missiles G2))
                                            BACKGROUND)))

;(define (render-missiles lom img) img) ;stub

(define (render-missiles lom img)
  (cond [(empty? lom) img]
        [else
         (place-image MISSILE
                      (missile-x (first lom)) (missile-y (first lom))
                      (render-missiles (rest lom) img))]))

;; Tank -> Image
;; render tank
(check-expect (render-tank T0)
              (place-image TANK
                           (tank-x T0)
                           (- HEIGHT TANK-HEIGHT/2)
                           BACKGROUND))

;(define (render-tank t) empty-image) ;stub

(define (render-tank t)
  (place-image TANK
               (tank-x t) (- HEIGHT TANK-HEIGHT/2)
               BACKGROUND))

;; Game -> Boolean
;; end the game if invader has landed
(check-expect (game-over? G0)
              (cond[(empty? (game-invaders G0)) false]
                   [else
                    (if (<= HEIGHT (invader-y (first (game-invaders G0))))
                        true
                        (game-over? (make-game
                                     (rest (game-invaders G0))
                                     (game-missiles G0)
                                     (game-tank G0))))]))
(check-expect (game-over? G1)
              (cond[(empty? (game-invaders G1)) false]
                   [else
                    (if (<= HEIGHT (invader-y (first (game-invaders G1))))
                        true
                        (game-over? (make-game
                                     (rest (game-invaders G1))
                                     (game-missiles G1)
                                     (game-tank G1))))]))

(define (game-over? s)
  (cond [(empty? (game-invaders s)) false]
        [else
         (if (>= (invader-y (first (game-invaders s))) HEIGHT)
             true
             (game-over? (make-game
                          (rest (game-invaders s))
                          (game-missiles s)
                          (game-tank s))))]))

;; Game KeyEvent -> Game
;; - left and right keys change the direction of the tank
;; - space bar key fires missiles

;(define (handle-key s ke) s) ;stub

(define (handle-key s ke)
  (cond [(key=? ke " ") (make-game (game-invaders s) (fire-missile (game-missiles s) (tank-x (game-tank s))) (game-tank s))]
        [(key=? ke "left") (make-game (game-invaders s) (game-missiles s) (turn-left (game-tank s)))]
        [(key=? ke "right") (make-game (game-invaders s) (game-missiles s) (turn-right (game-tank s)))]
        [else 
         s]))

;; ListOfMissile Natural -> ListOfMissile
;; fire a missile
(check-expect (fire-missile empty 150) (list (make-missile 150 (- HEIGHT TANK-HEIGHT/2))))

;(define (fire-missile lom x) lom)

(define (fire-missile lom x)
  (cond [(empty? lom) (list (make-missile x (- HEIGHT TANK-HEIGHT/2)))]
        [else
         (append (list (make-missile x (- HEIGHT TANK-HEIGHT/2))) lom)]))

;; Tank -> Tank
;; turn tank to left

;(define (turn-left t) t) ;stub
(define (turn-left t)
  (make-tank (tank-x t) -1))

;; Tank -> Tank
;; turn tank to right

;(define (turn-right t) t) ;stub
(define (turn-right t)
  (make-tank (tank-x t) 1))