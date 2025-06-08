;; Event Organizer Verification Contract
;; Manages verification and registration of event organizers

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_ALREADY_VERIFIED (err u101))
(define-constant ERR_NOT_VERIFIED (err u102))
(define-constant ERR_INVALID_ORGANIZER (err u103))

;; Data maps
(define-map verified-organizers principal bool)
(define-map organizer-details principal {
    name: (string-ascii 100),
    email: (string-ascii 100),
    verified-at: uint,
    reputation-score: uint
})

;; Public functions
(define-public (register-organizer (name (string-ascii 100)) (email (string-ascii 100)))
    (let ((organizer tx-sender))
        (asserts! (is-none (map-get? organizer-details organizer)) ERR_ALREADY_VERIFIED)
        (map-set organizer-details organizer {
            name: name,
            email: email,
            verified-at: u0,
            reputation-score: u0
        })
        (ok true)
    )
)

(define-public (verify-organizer (organizer principal))
    (begin
        (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
        (asserts! (is-some (map-get? organizer-details organizer)) ERR_INVALID_ORGANIZER)
        (map-set verified-organizers organizer true)
        (map-set organizer-details organizer
            (merge (unwrap-panic (map-get? organizer-details organizer))
                   { verified-at: block-height }))
        (ok true)
    )
)

(define-public (update-reputation (organizer principal) (new-score uint))
    (begin
        (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
        (asserts! (is-verified-organizer organizer) ERR_NOT_VERIFIED)
        (map-set organizer-details organizer
            (merge (unwrap-panic (map-get? organizer-details organizer))
                   { reputation-score: new-score }))
        (ok true)
    )
)

;; Read-only functions
(define-read-only (is-verified-organizer (organizer principal))
    (default-to false (map-get? verified-organizers organizer))
)

(define-read-only (get-organizer-details (organizer principal))
    (map-get? organizer-details organizer)
)

(define-read-only (get-reputation-score (organizer principal))
    (match (map-get? organizer-details organizer)
        details (get reputation-score details)
        u0
    )
)
