(define (square n) (* n n))

(define (pow base exp)
  (if (zero? exp)
      1  ;; 任何数的 0 次方都是 1 (注意没有括号)
      (if (odd? exp)
          ;; 奇数分支: base * (base^((exp-1)/2))^2
          (* base (square (pow base (/ (- exp 1) 2))))
          ;; 偶数分支: (base^(exp/2))^2
          (square (pow base (/ exp 2))))))
(define (repeatedly-cube n x)
  (if (zero? n)
      x
      (let ((y (repeatedly-cube (- n 1) x)))
        (* y y y))))

(define (cddr s) (cdr (cdr s)))

(define (cadr s) (car (cdr s)))

(define (caddr s) (car (cddr s)))
