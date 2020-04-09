;(load "C://Users//Artur//Desktop//lisp//f.lsp")


; Ф-я условия, которая проверят, нужное ли число нашлось в данный момент
(defun condition (a b x)
	(or 
		(and (>= a x)(<= b x))
		(and (<= a x)(>= b x))))

; Функция поиска суммы нечетных чисел, находящихся в заданном интервале a b
(defun find-sum (lst a b sum)
	(cond
		((null lst) sum) ; Если список пустой, возвращает sum

		; Если первый элемент список – входим в рекурсию
		((listp (car lst)) (find-sum (cdr lst) a b (find-sum (car lst) a b sum)))

		; Если число и удовлетворяет условию, в sum записываем сумму
		((and
			(numberp (car lst))
			(evenp (car lst))
			(condition a b (car lst)))
		 (find-sum (cdr lst) a b (+ sum (car lst))))
		((find-sum (cdr lst) a b sum))))

; Проверяет, что в списке есть числа
(defun check-nums (lst check)
	(cond
		((or (null lst) check) check)
		((numberp (car lst)))
		((listp (car lst)) (check-nums (cdr lst) (check-nums (car lst) check)))
		((check-nums (cdr lst) check))))

; Функция вставки элемента на k-ую позицию:
(defun insert_element_helper (lst k element new_lst)
(cond
	((null lst) new_lst)
	((= k 0) (insert_element_helper (cdr lst) (- k 1) element (cons (car lst) (cons element new_lst))))
	((insert_element_helper (cdr lst) (- k 1) element (cons (car lst) new_lst)))))
 
; Вспомогательная функция-обертка для вставки элемента на k-ую позицию:
(defun insert_element_wrapper (lst k element)
	(reverse (insert_element_helper lst k element nil)))
 
; Функция, которая определяет, есть ли в списке числа, если есть, то она вычисляет сумму четных чисел между a и b и вставляет на k-ую позицию списка, иначе выводит сообщение, что чисел нет:
(defun main (lst a b k)
	(cond
		((check-nums lst nil) (insert_element_wrapper lst k (find-sum lst a b 0)))
		((princ "No numbers in the list"))))
