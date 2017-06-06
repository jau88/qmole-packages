;;; -*-  Mode: Lisp; Package: Maxima; Syntax: Common-Lisp; Base: 10 -*- ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;     The data in this file contains enhancments.                    ;;;;;
;;;                                                                    ;;;;;
;;;  Copyright (c) 1984,1987 by William Schelter,University of Texas   ;;;;;
;;;     All rights reserved                                            ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package :maxima)

(macsyma-module newinv)

(declare-top (special *ptr* *ptc* *iar* *nonz* detl* *r0 mul* $sparse *det* *rr* ax))

(defun multbk (l ax m)
  (prog (e)
     (do ((j (1+ m) (1+ j)))
	 ((> j (* 2 m)))
       (setq e (car l) l (cdr l))
       (do ((i 1 (1+ i))) ((> i m))
	 (setf (aref ax i j) (rattimes e (aref ax i j) t))))))

(defun ctimemt (x y)
  (prog (c)
   loop (cond ((null y) (return c)))
   (setq c (nconc c (list (timesrow x (car y))))
	 y (cdr y))
   (go loop)))


(defun stora (ax m ei r)
  (declare (fixnum m r))
  (prog (det (i 0) (j 0) ro mat)
     (declare(fixnum i j))
     (setq i 0)
     loop0 (cond ((null ei) (return nil)))
     (setq mat (car ei) ei (cdr ei))
     (setq det (caar mat) mat (cdr mat))
     loop (setq j r)
     (cond ((null mat) (go loop0)))
     (setq i (1+ i) ro (car mat) mat (cdr mat))
     loop2 (cond ((null ro) (go loop)))
     (incf j)
     (setf (aref ax i (+ m j)) (ratreduce (caar ro) det))
     (setf (aref ax (aref *ptr* i) (aref *ptc* j)) nil)
     (setq ro (cdr ro))
     (go loop2)))

(defun prodhk (ri d r m)
  (declare (fixnum r m))
  (prog (ei e *rr* *r0 co)
     (setq *r0 r ei ri)
     loop (cond ((null ei)
		 (stora ax m (append co (list d)) r)
		 (setq detl* (cons (car d) detl*))
		 (return (cons (list d)
			       (mapcar #'(lambda (x y) (nconc x (list y)))
				       ri (nreverse *rr*))))))
     (setq e (car ei) ei (cdr ei))
     (setq co (cons (bmhk e d co r detl*) co))
     (go loop)))

(defun obmtrx (ax r s i j)
  (declare (fixnum r s i j ))
  (prog (ans (dj 0) (ds 0) dr d)
     (declare(fixnum ds dj))
     (setq ds s dj j)
     loop (cond ((= i 0) (return ans)))
     loop1 (cond ((= j 0)
		  (setq j dj
			s ds
			ans (cons (nreverse dr) ans))
		  (setq dr nil r (1- r) i (1- i))
		  (go loop)))
     (setq s (1+ s) j (1- j))
     (setq d (aref ax (aref *ptr* r) (aref *ptc* s)))
     (cond ((or *nonz* (equal d 0)) nil)
	   (t (setq *nonz* t)))
     (setq dr (cons d dr))
     (go loop1)))

(defun bmhk (da b nc c0 detl)
  (prog (c a sum det dy *nonz* x y)
     (setq det (car b) b (cdr b) a (car da) da (cdr da))
     (setq nc (reverse nc))
     (setq da (reverse da))
     (setq c (obmtrx ax *r0 c0 (length(cdr a)) (length b)))
     (setq *rr* (cons c *rr*))
     (cond ((null *nonz*) (return (cons '(1 . 1) c))))
     (setq sum (multmat c b))
     (setq *r0 (- *r0 (length (cdr a))))
     loop (cond ((null da) (go on)))
     (setq x (car da) y(car nc) dy (car y) y (cdr y))
     (setq x (multmat x y))
     (setq sum (addmatrix1 (ctimemt (cons (pminus (caar detl)) 1) sum) x))
     (setq det dy detl (cdr detl))
     (setq da (cdr da) nc (cdr nc))
     (go loop)
     on  (setq det (cons (ptimes (pminus (caar a)) (car det)) 1))
     (return (cons det (multmat(cdr a) sum)))))

(declare-top (special bl))

;; tmlattice returns the block structure in the form of a list of blocks
;; each in the form of ((i1 j1) (i2 j2) etc))

(defun newinv (ax m n)
  (declare (fixnum m n ))
  (prog (j mmat bl d bm detl* dm ipdm dm2 r i ei)
     (declare (special bl))	       ;Why?  I don't know why.  --gsb
     (do ((i m (1- i)))
	 ((= i 0))
       (declare (fixnum i))
       (setq mmat (cons (aref ax i (+ i m)) mmat)))
     (setq *ptr* (make-array (1+ m)))
     (setq  *ptc* (make-array (1+ m)))
     (setq bl (tmlattice ax '*ptr* '*ptc* m))
     (cond ((null bl) (merror (intl:gettext "newinv: matrix is singular."))))
     (setq bl (mapcar #'length bl))
     (setq bm (apply #'max bl))		;Chancey.  Consider mapping.
     (setq *iar* (make-array (list (1+ bm) (1+ (* 2 bm)))))
     (setq r 0)
     loop1 (cond ((null bl)
		  (tmunpivot ax '*ptr* '*ptc* m n)
		  (return (multbk mmat ax m))))
     (setq i (car bl))
     (setq dm i)
     (setq dm2 (* 2 dm))
     loop2 (cond ((= i 0) (go inv)))
     (setq j dm2 ipdm (+ i dm))
     loop3 (cond ((= j 0) (setq i (1- i)) (go loop2)))
     (setf (aref *iar* i j)
	   (cond ((> j dm)
		  (cond ((= j ipdm) '(1 . 1))
			(t '(0 . 1))))
		 (t (aref ax (aref *ptr* (+ r i)) (aref *ptc*(+ r j))))))
     (decf j)
     (go loop3)
     inv  (cond ((= r 0)
		 (setq ei (tmlin '*iar* dm dm dm))
		 (setq ei (list (cons (caar ei) (cdr ei))))
		 (stora ax m ei r)
		 (setq ei (list ei))(go next)))
     (setq d (tmlin '*iar* dm dm dm))
     (setq d (cons (caar d) (cdr d)))
     (setq ei (prodhk ei d r m))
     (setq d nil)
     next  (incf r (car bl))
     (setq bl (cdr bl))
     (go loop1)))

(declare-top (unspecial bl *nonz* detl* *r0 mul* *det* *rr* ax))
