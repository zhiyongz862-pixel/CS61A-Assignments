
; 这个是生成代码的
(define (curry-cook formals body) 
  (if (null? (cdr formals))  ;如果说还剩下一个元素直接 lambda就可以
  `(lambda (,(car formals)) ,body)
  `(lambda (,(car formals)) ,(curry-cook (cdr formals) body))
  )

)

; 这个是直接求值的
(define (curry-consume curry args)
  (if (null? args)
      ;; 假设 2：如果 args 为空，说明已经完全应用或无需进一步应用，直接返回结果
      curry
      ;; 递归步骤：将 args 的第一个元素喂给 curry 函数，
      ;; 得到的结果（可能是新 lambda 或最终值）继续与剩余的 args 递归
      (curry-consume (curry (car args)) (cdr args))))

(define-macro (switch expr options)
  (switch-to-cond (list 'switch expr options)))

; 不理解
(define-macro (switch expr options) (switch-to-cond (list 'switch expr options)))

(define (switch-to-cond switch-expr)
  (cons 'cond  ; 第一个空：cond 结构的起始符号
    (map
      (lambda (option) 
        (cons `(equal? ,(car (cdr switch-expr)) ,(car option)) (cdr option))) ; 第二个空：构造测试条件
      (car (cdr (cdr switch-expr))))))
