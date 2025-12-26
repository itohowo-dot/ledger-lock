;; LedgerLock
;; Version: 1.0.0
;; A secure, auditable counter contract with ownership controls and event logging
;; Built for production-grade state management on Stacks blockchain

;; =================================
;; Constants
;; =================================

;; Error Codes
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-COUNTER-UNDERFLOW (err u101))
(define-constant ERR-COUNTER-OVERFLOW (err u102))
(define-constant ERR-INVALID-VALUE (err u103))
(define-constant ERR-TRANSFER-FAILED (err u104))
(define-constant ERR-SAME-OWNER (err u105))

;; Contract Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant MAX-COUNTER-VALUE u340282366920938463463374607431768211455) ;; uint max
(define-constant MIN-COUNTER-VALUE u0)

;; =================================
;; Data Variables
;; =================================

(define-data-var counter uint u0)
(define-data-var owner principal CONTRACT-OWNER)
(define-data-var paused bool false)
(define-data-var total-increments uint u0)
(define-data-var total-decrements uint u0)

;; =================================
;; Data Maps
;; =================================

;; Track operations per address for analytics
(define-map user-operations 
  principal 
  {
    increments: uint,
    decrements: uint,
    last-action-block: uint
  }
)

;; =================================
;; Private Functions
;; =================================

(define-private (is-contract-owner)
  (is-eq tx-sender (var-get owner))
)

(define-private (is-paused)
  (var-get paused)
)

(define-private (update-user-stats (operation (string-ascii 10)))
  (let
    (
      (current-stats (default-to 
        { increments: u0, decrements: u0, last-action-block: u0 }
        (map-get? user-operations tx-sender)
      ))
    )
    (if (is-eq operation "increment")
      (map-set user-operations tx-sender {
        increments: (+ (get increments current-stats) u1),
        decrements: (get decrements current-stats),
        last-action-block: stacks-block-height
         })
      (map-set user-operations tx-sender {
        increments: (get increments current-stats),
        decrements: (+ (get decrements current-stats) u1),
        last-action-block: stacks-block-height
      })
    )
  )
)

;; =================================
;; Read-Only Functions
;; =================================

(define-read-only (get-lock-count)
  (ok (var-get counter))
)

(define-read-only (get-owner)
  (ok (var-get owner))
)

(define-read-only (get-contract-owner)
  (ok CONTRACT-OWNER)
)

(define-read-only (is-locked-status)
  (ok (var-get paused))
)

(define-read-only (get-total-locks)
  (ok (var-get total-increments))
)

(define-read-only (get-total-unlocks)
  (ok (var-get total-decrements))
)