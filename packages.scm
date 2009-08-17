(define-structure utilities utilities-interface
  (open bitwise (subset signals (error warn))
        loopholes let-opt scheme define-record-types
        records record-types
        threads threads-internal placeholders locks srfi-1)
  (files utilities))

(define-structure let-opt-expanders let-opt-expanders/interface
  (open scheme
        signals
        srfi-8)
  (files let-opt-expanders))

(define-structure let-opt let-opt/interface
  (open scheme signals receiving)
  (for-syntax (open scheme let-opt-expanders))
  (files let-opt))

(define-structure defrec-package (export (define-record :syntax))
  (open records record-types scheme)
  (for-syntax (open scheme (subset signals (error warn)) receiving))
  (files defrec))

(define-structures ((re-level-0 re-level-0-interface)
                    (re-match-internals re-match-internals-interface)
                    (re-internals re-internals-interface)
                    (sre-syntax-tools (export (if-sre-form :syntax)
                                              sre-form?
                                              parse-sre parse-sres
                                              regexp->scheme
                                              static-regexp?))
                    (standard-char-sets (export nonl-chars word-chars))
                    (sre-internal-syntax-tools (export expand-rx)))
  (open defrec-package
        weak
        ;; re-posix-parsers     ; regexp->posix-string
        let-opt
        sort                            ; Posix renderer
        define-record-types
        defrec-package
        receiving
        utilities
        (subset srfi-1 (fold every fold-right))
        srfi-14
        (subset signals (error warn))
        ascii
        primitives                      ; JMG add-finalizer!
        define-record-types             ; JMG debugging
        external-calls
        srfi-13                         ; string-fold
        posix-regexps
        scheme)

  (files re-low re simp re-high
         parse posixstr spencer re-syntax)

  (begin (define-syntax if-sre-form
           (lambda (exp r c)
             (if (sre-form? (cadr exp) r c)
                 (caddr exp)
                 (cadddr exp))))))

;;; Stuff that could appear in code produced by (rx ...)
(define-structure rx-lib rx-lib-interface
  (open re-internals
        re-level-0
        (subset srfi-1 (fold))
        srfi-14
        (subset signals (error warn))
        ascii
        scheme)
  (files rx-lib))

(define-structure rx-syntax rx-syntax-interface
  (open re-level-0
        srfi-14
        rx-lib
        standard-char-sets
        scheme)
  (for-syntax (open sre-internal-syntax-tools scheme))
  (begin (define-syntax rx expand-rx)))

(define-structure re-match-syntax re-match-syntax-interface
  (for-syntax (open scheme
                    signals))   ; For ERROR
  (open re-level-0 scheme)
  (access signals) ; for ERROR
  (files re-match-syntax))

(define-structure re-old-funs re-old-funs-interface
  (open re-level-0 (subset signals (error warn)) receiving scheme)
  (files oldfuns))

(define-structure re-subst re-subst-interface
  (open re-level-0
        re-match-internals
        posix-regexps
        (subset srfi-1 (fold))
        ;;scsh-level-0    ; write-string
        os-strings
        i/o
        let-opt
        receiving
        (subset signals (error warn))
        srfi-13         ; string-copy!
        scheme)
  (files re-subst))

(define-structure re-folders re-folders-interface
  (open re-level-0 let-opt (subset signals (error warn)) scheme)
  (files re-fold))

(define-structure re-exports re-exports-interface
  (open rx-syntax
        re-level-0
        re-subst
        re-match-syntax
        re-folders))


;;; File        Exports
;;; ----        -------
;;; parse       sre->regexp regexp->sre
;;;             parse-sre parse-sres regexp->scheme
;;;             char-set->in-pair static-regexp?
;;; posixstr    regexp->posix-string
;;; re-high     compile-regexp regexp-search regexp-search?
;;; re-subst    regexp-substitute regexp-substitute/global
;;; re-low      match:start match:end match:substring
;;;             CRE record, new-cre
;;;             cre-search cre-search?
;;; re-syntax   sre-form? if-sre-form expand-rx
;;; re.scm      The ADT. flush-submatches uncase uncase-char-set
;;;             char-set-full? char-set-empty?
;;;             re-char-class? static-char-class?
;;; rx-lib      coerce-dynamic-regexp coerce-dynamic-charset spec->char-set
;;; simp        simplify-regexp
;;; spencer     posix-string->regexp
