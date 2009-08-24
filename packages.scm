(define-structure error-package (export warn error)
  (open (subset signals (error warn))))

(define-structure utilities utilities-interface
  (open bitwise error-package
        loopholes let-opt scheme define-record-types
        records record-types
        threads threads-internal placeholders locks srfi-1)
  (files utilities))

(define-structure let-opt-expanders let-opt-expanders-interface
  (open scheme error-package srfi-8)
  (files let-opt-expanders))

(define-structure let-opt let-opt-interface
  (open scheme error-package receiving)
  (for-syntax (open scheme let-opt-expanders))
  (files let-opt))

(define-structure defrec-package (export (define-record :syntax))
  (open records record-types scheme)
  (for-syntax (open scheme error-package receiving))
  (files defrec))

(define-structures ((re-level-0 re-level-0-interface)
                    (re-match-internals re-match-internals-interface)
                    (re-internals re-internals-interface)
                    (standard-char-sets (export nonl-chars word-chars))
                    (sre-internal-syntax-tools (export sre-form?
                                                       parse-sre parse-sres
                                                       regexp->scheme
                                                       static-regexp? expand-rx)))
  (open defrec-package
        weak
        let-opt
        sort                            ; Posix renderer
        define-record-types
        defrec-package
        receiving
        utilities
        (subset srfi-1 (fold every fold-right))
        srfi-14
        error-package
        ascii
        primitives                      ; JMG add-finalizer!
        define-record-types             ; JMG debugging
        srfi-13                         ; string-fold
        posix-regexps
        scheme)

  (files re-low re simp re-high
         parse posixstr spencer re-syntax))

(define-structure sre-syntax-tools sre-syntax-tools-interface
  (open scheme sre-internal-syntax-tools)
  (for-syntax (open scheme sre-internal-syntax-tools))
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
        error-package
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
  (for-syntax (open scheme error-package))
  (open re-level-0 scheme)
  (files re-match-syntax))

(define-structure re-subst re-subst-interface
  (open re-level-0
        re-match-internals
        posix-regexps
        (subset srfi-1 (fold))
        os-strings
        i/o
        let-opt
        receiving
        error-package
        srfi-13         ; string-copy!
        scheme)
  (files re-subst))

(define-structure re-folders re-folders-interface
  (open re-level-0 let-opt error-package scheme)
  (files re-fold))

(define-structure re-exports re-exports-interface
  (open rx-syntax
        re-level-0
        re-subst
        re-match-syntax
        re-folders))

(define-structure re-procs-tests (export test-re-procs)
  (open scheme srfi-78 srfi-6 receiving
        re-exports)
  (files (tests re-procs-tests)))

(define-structure re-adt-tests (export test-re-adt)
  (open scheme srfi-78 re-exports)
  (files (tests re-adt-tests)))

(define-structure sre-tools-tests (export test-sre-tools)
  (open scheme srfi-78 re-exports sre-syntax-tools)
  (files (tests sre-tools-tests)))

(define-structure rx-tests (export test-rx)
  (open scheme srfi-78 re-procs-tests
        re-adt-tests sre-tools-tests)
  (begin (define (test-rx)
           (test-re-procs)
           (test-re-adt)
           (test-sre-tools)
           (check-report)
           (check-reset!))))

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
