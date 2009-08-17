;;; -*- mode: scheme48; scheme48-package: (exec) -*-

(config)

(load "scsh-read.scm")
(open 'scsh-reader)
(set-reader 'scsh-read)
(load "interfaces.scm"
      "packages.scm")

(user)
(open 're-exports 'sre-syntax-tools)
