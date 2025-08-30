;; Project Registry - Minimal, Extensible

;; Constants
(define-constant ERR-ALREADY-REGISTERED u100)
(define-constant ERR-NOT-OWNER u101)
(define-constant ERR-NOT-FOUND u102)
(define-constant ERR-INVALID u103)
(define-constant MAX-TITLE u100)
(define-constant MAX-DESC u300)
(define-constant MAX-LOC u100)
(define-constant MAX-GOALS u5)
(define-constant MAX-GOAL u60)
(define-constant MAX-TAGS u8)
(define-constant MAX-TAG u16)

;; Maps
(define-map projects
  { hash: (buff 32) }
  {
    owner: principal,
    title: (string-utf8 100),
    desc: (string-utf8 300),
    loc: (string-utf8 100),
    goals: (list 5 (string-utf8 60)),
    created: uint
  }
)
(define-map categories
  { hash: (buff 32) }
  { category: (string-utf8 40), tags: (list 8 (string-utf8 16)) }
)
(define-map collaborators
  { hash: (buff 32), who: principal }
  { role: (string-utf8 40), added: uint }
)
(define-map status
  { hash: (buff 32) }
  { state: (string-utf8 16), visible: bool, updated: uint }
)
(define-map versions
  { hash: (buff 32), v: uint }
  { doc: (buff 32), note: (string-utf8 100), time: uint }
)

;; Helpers
(define-private (valid-str (s (string-utf8 300)) (max uint))
  (and (> (len s) u0) (<= (len s) max)))
(define-private (valid-list (lst (list 8 (string-utf8 60))) (max uint) (max-item uint))
  (and (<= (len lst) max)
       (fold (lambda (i a) (and a (valid-str i max-item))) lst true)))

;; Register project
(define-public (register (hash (buff 32)) (title (string-utf8 100)) (desc (string-utf8 300)) (loc (string-utf8 100)) (goals (list 5 (string-utf8 60))))
  (begin
    (asserts! (valid-str title MAX-TITLE) (err ERR-INVALID))
    (asserts! (valid-str desc MAX-DESC) (err ERR-INVALID))
    (asserts! (valid-str loc MAX-LOC) (err ERR-INVALID))
    (asserts! (valid-list goals MAX-GOALS MAX-GOAL) (err ERR-INVALID))
    (asserts! (is-none (map-get? projects {hash: hash})) (err ERR-ALREADY-REGISTERED))
    (map-set projects {hash: hash}
      { owner: tx-sender, title: title, desc: desc, loc: loc, goals: goals, created: block-height })
    (map-set status {hash: hash}
      { state: u"Planning", visible: true, updated: block-height })
    (ok true)
  )
)

;; Transfer ownership
(define-public (transfer (hash (buff 32)) (to principal))
  (let ((p (map-get? projects {hash: hash})))
    (asserts! (is-some p) (err ERR-NOT-FOUND))
    (asserts! (is-eq (get owner (unwrap-panic p)) tx-sender) (err ERR-NOT-OWNER))
    (map-set projects {hash: hash} (merge (unwrap-panic p) {owner: to}))
    (ok true)
  )
)

;; Add collaborator
(define-public (add-collab (hash (buff 32)) (who principal) (role (string-utf8 40)))
  (let ((p (map-get? projects {hash: hash})))
    (asserts! (is-some p) (err ERR-NOT-FOUND))
    (asserts! (is-eq (get owner (unwrap-panic p)) tx-sender) (err ERR-NOT-OWNER))
    (asserts! (is-none (map-get? collaborators {hash: hash, who: who})) (err ERR-ALREADY-REGISTERED))
    (map-set collaborators {hash: hash, who: who} {role: role, added: block-height})
    (ok true)
  )
)

;; Add category/tags
(define-public (add-category (hash (buff 32)) (cat (string-utf8 40)) (tags (list 8 (string-utf8 16))))
  (let ((p (map-get? projects {hash: hash})))
    (asserts! (is-some p) (err ERR-NOT-FOUND))
    (asserts! (is-eq (get owner (unwrap-panic p)) tx-sender) (err ERR-NOT-OWNER))
    (asserts! (valid-str cat u40) (err ERR-INVALID))
    (asserts! (valid-list tags MAX-TAGS MAX-TAG) (err ERR-INVALID))
    (map-set categories {hash: hash} {category: cat, tags: tags})
    (ok true)
  )
)

;; Update status
(define-public (set-status (hash (buff 32)) (state (string-utf8 16)) (visible bool))
  (let ((p (map-get? projects {hash: hash})))
    (asserts! (is-some p) (err ERR-NOT-FOUND))
    (asserts! (is-eq (get owner (unwrap-panic p)) tx-sender) (err ERR-NOT-OWNER))
    (map-set status {hash: hash} {state: state, visible: visible, updated: block-height})
    (ok true)
  )
)

;; Register version
(define-public (add-version (hash (buff 32)) (v uint) (doc (buff 32)) (note (string-utf8 100)))
  (let ((p (map-get? projects {hash: hash})))
    (asserts! (is-some p) (err ERR-NOT-FOUND))
    (asserts! (is-eq (get owner (unwrap-panic p)) tx-sender) (err ERR-NOT-OWNER))
    (asserts! (is-none (map-get? versions {hash: hash, v: v})) (err ERR-ALREADY-REGISTERED))
    (map-set versions {hash: hash, v: v} {doc: doc, note: note, time: block-height})
    (ok true)
  )
)

;; Read-only queries
(define-read-only (get-project (hash (buff 32))) (map-get? projects {hash: hash}))
(define-read-only (get-category (hash (buff 32))) (map-get? categories {hash: hash}))
(define-read-only (get-collab (hash (buff 32)) (who principal)) (map-get? collaborators {hash: hash, who: who}))
(define-read-only (get-status (hash (buff 32))) (map-get? status {hash: hash}))
(define-read-only (get-version (hash (buff 32)) (v uint)) (map-get? versions {hash: hash, v: v}))