;; Decentralized Content Provenance System
;; A Clarity smart contract for tracking digital content ownership and provenance on the Stacks blockchain

;; Data structures
(define-map content-registry
  { content-hash: (buff 32) }
  {
    creator: principal,
    title: (string-utf8 256),
    timestamp: uint,
    description: (string-utf8 1024),
    license-type: (string-utf8 64),
    version: uint,
    previous-hash: (optional (buff 32))
  }
)
