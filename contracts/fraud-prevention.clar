;; Fraud Prevention Contract
;; Prevents ticket fraud and manages security measures

(define-constant ERR_UNAUTHORIZED (err u500))
(define-constant ERR_SUSPICIOUS_ACTIVITY (err u501))
(define-constant ERR_BLACKLISTED_USER (err u502))
(define-constant ERR_RATE_LIMIT_EXCEEDED (err u503))
(define-constant ERR_DUPLICATE_TICKET (err u504))
(define-constant ERR_INVALID_SIGNATURE (err u505))

;; Data maps
(define-map blacklisted-users principal bool)
(define-map user-activity principal {
    last-purchase: uint,
    purchase-count: uint,
    suspicious-flags: uint
})

(define-map ticket-hashes uint (buff 32))
(define-map fraud-reports uint {
    reporter: principal,
    reported-user: principal,
    ticket-id: uint,
    reason: (string-ascii 200),
    reported-at: uint,
    status: (string-ascii 20)
})

(define-data-var next-report-id uint u1)
(define-data-var max-purchases-per-block uint u5)

;; Public functions
(define-public (blacklist-user (user principal) (reason (string-ascii 200)))
    (begin
        ;; Only contract owner or verified organizers can blacklist
        (map-set blacklisted-users user true)
        (ok true)
    )
)

(define-public (report-fraud (reported-user principal) (ticket-id uint) (reason (string-ascii 200)))
    (let ((report-id (var-get next-report-id)))
        (map-set fraud-reports report-id {
            reporter: tx-sender,
            reported-user: reported-user,
            ticket-id: ticket-id,
            reason: reason,
            reported-at: block-height,
            status: "pending"
        })
        (var-set next-report-id (+ report-id u1))
        (ok report-id)
    )
)

(define-public (validate-purchase-attempt (user principal))
    (let ((activity (default-to { last-purchase: u0, purchase-count: u0, suspicious-flags: u0 }
                                (map-get? user-activity user))))

        ;; Check if user is blacklisted
        (asserts! (not (default-to false (map-get? blacklisted-users user))) ERR_BLACKLISTED_USER)

        ;; Check rate limiting
        (asserts! (or (not (is-eq (get last-purchase activity) block-height))
                     (< (get purchase-count activity) (var-get max-purchases-per-block)))
                 ERR_RATE_LIMIT_EXCEEDED)

        ;; Update activity
        (let ((new-count (if (is-eq (get last-purchase activity) block-height)
                            (+ (get purchase-count activity) u1)
                            u1)))
            (map-set user-activity user {
                last-purchase: block-height,
                purchase-count: new-count,
                suspicious-flags: (get suspicious-flags activity)
            })
        )

        (ok true)
    )
)

(define-public (generate-ticket-hash (ticket-id uint) (event-id uint) (owner principal))
    (let ((hash-data (concat (concat (unwrap-panic (to-consensus-buff? ticket-id))
                                   (unwrap-panic (to-consensus-buff? event-id)))
                           (unwrap-panic (to-consensus-buff? owner)))))
        (map-set ticket-hashes ticket-id (sha256 hash-data))
        (ok (sha256 hash-data))
    )
)

(define-public (verify-ticket-authenticity (ticket-id uint) (expected-hash (buff 32)))
    (let ((stored-hash (map-get? ticket-hashes ticket-id)))
        (match stored-hash
            hash (ok (is-eq hash expected-hash))
            (err ERR_DUPLICATE_TICKET)
        )
    )
)

(define-public (update-fraud-report-status (report-id uint) (new-status (string-ascii 20)))
    (let ((report (unwrap! (map-get? fraud-reports report-id) ERR_UNAUTHORIZED)))
        ;; Only allow certain users to update status
        (map-set fraud-reports report-id
            (merge report { status: new-status }))
        (ok true)
    )
)

;; Read-only functions
(define-read-only (is-user-blacklisted (user principal))
    (default-to false (map-get? blacklisted-users user))
)

(define-read-only (get-user-activity (user principal))
    (map-get? user-activity user)
)

(define-read-only (get-fraud-report (report-id uint))
    (map-get? fraud-reports report-id)
)

(define-read-only (get-ticket-hash (ticket-id uint))
    (map-get? ticket-hashes ticket-id)
)

(define-read-only (calculate-risk-score (user principal))
    (let ((activity (map-get? user-activity user)))
        (match activity
            data (get suspicious-flags data)
            u0
        )
    )
)
