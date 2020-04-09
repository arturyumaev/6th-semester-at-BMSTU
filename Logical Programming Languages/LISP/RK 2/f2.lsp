; Получаем список четных чисел между a и b
(defun between (lst a b)
	(mapcan #'(lambda (x)
		(cond
			((and
				(numberp x)
				(evenp x)
				(or
					(and (>= a x)(<= b x))
					(and (<= a x)(>= b x))))
			 (cons x nil))
			((listp x) (between x a b)))
		) lst))

; Cумма четных чисел между a и b
(defun get_sum (lst a b)
       (reduce #'+ (between lst a b)))
 
; Функция, возвращающая список из t и nil, соответствующих проверке каждого элемента на число
(defun is_nums (lst)
	(mapcan #'(lambda (x)
		(cond
			((numberp x) (cons t nil))
			((listp x) (is_nums x))
			((cons nil nil)))
		) lst))

; Функция, проверяющая, есть ли в списке числа
(defun check_nums (lst)
	(and lst (reduce #'(lambda (a b) (or a b)) (is_nums lst))))

; Функция, которая определяет, есть ли в списке числа, если есть,
; то она вычисляет сумму четных чисел между a и b
; и вставляет ее в конец списка, иначе выводит сообщение, что чисел нет:
(defun main (lst a b)
	(cond
		((check_nums lst) (nconc lst (cons (get_sum lst a b) nil)))
		((princ "No numbers in the list"))))
