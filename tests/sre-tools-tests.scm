(define (test-sre-tools)
  (check (if-sre-form (: "foo" "bar") 'yes 'no) => 'yes)
  (check (if-sre-form 'foo 'yes 'no) => 'no)
  (let-syntax ((regexp-bind (syntax-rules ()
                              ((regexp-bind name sre body)
                               (if-sre-form sre
                                            (let ((name (rx sre)))
                                              body)
                                            (if #f #f))))))
    (check (regexp-bind s (: "blah" (* digit))
                        (regexp-fold s (lambda (i m count) (+ count 1)) 0
                                     "blah23 foo bar blah baz233")) => 2)
    (check (regexp-bind s blah s) => (if #f #f))))
