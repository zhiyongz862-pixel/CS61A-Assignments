(define (over-or-under num1 num2) (
  cond ((> num1 num2) 1)  ;这里不能写 (num1) 因为他不是一个函数
       ((< num1 num2) -1)
       (else 0)
  ))

(define (make-adder num) (
  lambda (x) (+ num x) 
))

(define (composed f g) 
 (
  lambda (x) (f (g x)
 )
) )

(define (repeat f n) 

  (define (repeat_real f x n)
      (
        if(= n 0) x (repeat_real f (f x) (- n 1))
      ))
  (lambda (x) (repeat_real f x n))
)

(define (max a b)
  (if (> a b)
      a
      b))

(define (min a b)
  (if (> a b)
      b
      a))

(define (gcd a b) 
 
 (if (zero? (modulo (max a b) (min a b))) (min a b) (gcd (max a b) (modulo (max a b) (min a b))))

)
