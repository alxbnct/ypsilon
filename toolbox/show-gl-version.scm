(import (ypsilon gl) (ypsilon glut) (ypsilon c-types))
(glutInit (make-c-int (c-main-argc)) (c-main-argv))
(glutCreateWindow (string->utf8/nul "Ypsilon"))
(format #t "~a~%~!" (utf8->string (make-bytevector-mapping (glGetString GL_VERSION) 1024)))
