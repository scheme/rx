(define-interface utilities-interface
  (export mapv mapv! vector-every? copy-vector
          initialize-vector vector-append
          vfold vfold-right
          check-arg
          deprecated-proc
          real->exact-integer
          make-reinitializer
          run-as-long-as
          obtain-all-or-none))

(define-interface let-opt-expanders-interface
  (export expand-let-optionals
          expand-let-optionals*))

(define-interface let-opt-interface
  (export (let-optionals  :syntax)
          (let-optionals* :syntax)
          (:optional      :syntax)))

(define-interface basic-re-interface
  (export (re-dsm? (proc (:value) :boolean))
          ((re-dsm make-re-dsm) (proc (:value :exact-integer :exact-integer) :value))
          (re-dsm:body (proc (:value) :value))
          (re-dsm:pre-dsm (proc (:value) :exact-integer))
          (re-dsm:tsm (proc (:value) :exact-integer))
          (re-dsm:posix (proc (:value) :value))
          (set-re-dsm:posix (proc (:value :value) :unspecific))
          (re-dsm:post-dsm (proc (:value) :exact-integer))
          open-dsm

          (re-seq? (proc (:value) :boolean))
          (really-make-re-seq (proc (:value :exact-integer :value) :value))
          (make-re-seq/tsm (proc (:value :exact-integer) :value))
          ((re-seq make-re-seq) (proc (:value) :value))
          (re-seq:elts (proc (:value) :value))
          (re-seq:tsm (proc (:value) :exact-integer))
          (re-seq:posix (proc (:value) :value))
          (set-re-seq:posix (proc (:value :value) :unspecific))

          (re-choice? (proc (:value) :boolean))
          (really-make-re-choice (proc (:value :exact-integer :value) :value))
          (make-re-choice/tsm (proc (:value :exact-integer) :value))
          ((make-re-choice re-choice) (proc (:value) :value))
          (re-choice:elts (proc (:value) :value))
          (re-choice:tsm (proc (:value) :exact-integer))
          (re-choice:posix (proc (:value) :value))
          (set-re-choice:posix (proc (:value :value) :unspecific))

          (re-repeat? (proc (:value) :boolean))
          (really-make-re-repeat (proc (:exact-integer
                                        :value :value
                                        :exact-integer :value)
                                  :value))
          (make-re-repeat/tsm (proc (:exact-integer :value :value :exact-integer )
                                    :value))
          ((re-repeat make-re-repeat)
           (proc (:exact-integer :value :value) :value))
          ((re-repeat:from re-repeat:tsm)
           (proc (:value) :exact-integer))
          (re-repeat:to (proc (:value) :value))
          ((re-repeat:body re-repeat:posix)
           (proc (:value) :value))
          (set-re-repeat:posix (proc (:value :value) :unspecific))

          (re-submatch? (proc (:value) :boolean))
          (really-make-re-submatch (proc (:value :exact-integer :exact-integer :value)
                                         :value))
          (make-re-submatch/tsm (proc (:value :exact-integer :exact-integer) :value))
          ((make-re-submatch re-submatch)
           (proc (:value &opt :exact-integer :exact-integer) :value))

          (re-submatch:body (proc (:value) :value))
          ((re-submatch:pre-dsm re-submatch:tsm re-submatch:post-dsm)
           (proc (:value) :exact-integer))
          (re-submatch:posix (proc (:value) :value))
          (set-re-submatch:posix (proc (:value :value) :unspecific))

          (re-string? (proc (:value) :boolean))
          ((make-re-string re-string) (proc (:string) :value))
          (re-string:chars (proc (:value) :string))
          (set-re-string:chars (proc (:value :string) :unspecific))
          (re-string:posix (proc (:value) :value))
          (set-re-string:posix (proc (:value :value) :unspecific))

          re-trivial
          (re-trivial? (proc (:value) :boolean))

          (re-char-set? (proc (:value) :boolean))
          ((make-re-char-set re-char-set) (proc (:value) :value))
          (re-char-set:cset (proc (:value) :value))
          (set-re-char-set:cset (proc (:value :value) :unspecific))
          (re-char-set:posix (proc (:value) :value))
          (set-re-char-set:posix (proc (:value :value) :unspecific))

          re-empty
          (re-empty? (proc (:value) :boolean))
          re-bos          re-eos
          re-bol          re-eol

          ((re-bos? re-eos? re-bol? re-eol? re-any?)
           (proc (:value) :boolean))

          re-any
          re-nonl

          (regexp? (proc (:value) :boolean))
          (re-tsm (proc (:value) :exact-integer))

          ;; These guys can be in code produced by RX expander.
          (flush-submatches (proc (:value) :value))
          (uncase (proc (:value) :value))
          (uncase-char-set (proc (:value) :value))
          (uncase-string (proc (:string) :value))))

;;; These guys were made obsolete by the new SRE package and exist for
;;; backwards compatibility only.
(define-interface re-old-funs-interface
  (export
   (string-match (proc (:value :string &opt :exact-integer) :value))
   (make-regexp  (proc (:string) :value))
   (regexp-exec  (proc (:value :string &opt :exact-integer) :value))
   (->regexp     (proc (:value) :value))
   (regexp-quote (proc (:string) :value))))


(define-interface re-internals-interface
  ;; These are constructors for the Scheme unparser
  (export
   (make-re-string/posix (proc (:string :string :vector) :value))
   ((make-re-seq/posix make-re-choice/posix)
    (proc (:value :exact-integer :string :vector) :value))
   (make-re-char-set/posix (proc (:value :string :vector) :value))
   (make-re-repeat/posix (proc (:exact-integer :value :value :exact-integer :string :vector)
                                :value))
   (make-re-dsm/posix (proc (:value :exact-integer :exact-integer :string :vector)
                             :value))
   (make-re-submatch/posix (proc (:value :exact-integer :exact-integer :string :vector) :value))))

(define-interface re-match-internals-interface
  (export (regexp-match:string (proc (:value) :string))
          (regexp-match:submatches  (proc (:value) :vector))))

(define-interface posix-re-interface
  (export (regexp->posix-string (proc (:value) :string))        ; posixstr.scm
          (posix-string->regexp (proc (:string) :value))))      ; spencer

(define-interface re-subst-interface
  (export
   (regexp-substitute (proc (:value :value &rest :value) :value))
   (regexp-substitute/global (proc (:value :value :string &rest :value) :value))))

(define-interface re-folders-interface
  (export
   (regexp-fold (proc (:value (proc (:exact-integer :value :value) :value)
                              :value
                              :string
                              &opt (proc (:exact-integer :value) :value)
                              :exact-integer)
                      :value))
   (regexp-fold-right (proc (:value (proc (:value :exact-integer :value) :value)
                                    :value
                                    :string
                                    &opt (proc (:exact-integer :value) :value)
                                    :exact-integer)
                            :value))
   (regexp-for-each (proc (:value (proc (:value) :unspecific)
                                  :string &opt :exact-integer)
                          :unspecific))))

(define-interface re-level-0-interface
  (compound-interface posix-re-interface
                      basic-re-interface
                      (export (regexp-match? (proc (:value) :boolean))
                              (match:start (proc (:value &opt :exact-integer) :value))
                              (match:end   (proc (:value &opt :exact-integer) :value))
                              (match:substring (proc (:value &opt :exact-integer) :value))
                              (regexp-search (proc (:value :string &opt :exact-integer)
                                                   :value))
                              (regexp-search? (proc (:value :string &opt :exact-integer)
                                                   :boolean))
                              (sre->regexp (proc (:value) :value))
                              (regexp->sre (proc (:value) :value))
                              (simplify-regexp (proc (:value) :value)))))

(define-interface rx-lib-interface
  (compound-interface (export coerce-dynamic-regexp
			      coerce-dynamic-charset
			      spec->char-set
			      flush-submatches
			      uncase
			      uncase-char-set
			      uncase-string)
		      re-internals-interface))

(define-interface rx-syntax-interface (export (rx :syntax)))

(define-interface sre-syntax-tools-interface
  (export (if-sre-form :syntax)
          sre-form?
          parse-sre parse-sres
          regexp->scheme
          static-regexp?))

(define-interface re-match-syntax-interface
  (export (let-match  :syntax)
	  (if-match   :syntax)
	  (match-cond :syntax)))

(define-interface re-exports-interface
  (compound-interface re-level-0-interface
		      rx-syntax-interface
		      re-subst-interface
		      re-match-syntax-interface
		      re-folders-interface))
