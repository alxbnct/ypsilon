(import (core) (test-lite))

(display "(ypsilon c-ffi) testing\n\n")

(test-begin "c-function")
(test-eval! (import (core) (ypsilon c-ffi)))
(test-eval! (define sqrt (c-function double sqrt (double))))
(test-eval! (define n (sqrt 100)))
(test-equal "sqrt" n => 10.0)
(test-end)

(test-begin "c-function/weak")
(test-eval! (import (core) (ypsilon c-ffi)))
(test-eval! (define sqrt (c-function/weak double sqrt (double))))
(test-eval! (define n (sqrt 10000.0)))
(test-equal "sqrt" n => 100.0)
(test-end)

(test-begin "c-callback")
(test-eval! (import (core) (ypsilon c-ffi)))
(test-eval! (define comparison
              (c-callback int (void* void*)
                (lambda (a1 a2)
                  (let ((n1 (bytevector-u32-native-ref (make-bytevector-mapping a1 4) 0))
                        (n2 (bytevector-u32-native-ref (make-bytevector-mapping a2 4) 0)))
                    (cond ((= n1 n2) 0)
                          ((< n1 n2) 1)
                          (else -1)))))))
(test-eval! (define qsort (c-function/weak void qsort (void* int int void*))))
(test-eval! (define nums (uint-list->bytevector '(10000 1000 10 100000 100) (native-endianness) 4)))
(test-eval! (qsort nums 5 4 comparison))
(test-equal "qsort" (bytevector->uint-list nums (native-endianness) 4)  => (100000 10000 1000 100 10))
(test-end)

(test-begin "c-function variadic")
(test-eval! (import (core) (ypsilon c-ffi) (ypsilon c-types)))
(test-eval! (define snprintf (c-function int snprintf (void* size_t void* long double) (void* size_t void*))))
(test-eval! (define output (make-bytevector 128 0)))
(test-eval! (define n (snprintf output 128 (make-c-string "%lu %.3lf") 246 123.4)))
(test-eval! (define s (c-string-ref output)))
(test-equal "snprintf" n  => 11)
(test-equal "snprintf" s  => "246 123.400")
(test-end)
