;Требуется составить программу на языке ассемблера, которая обеспечит ввод
;матрицы, преобразование согласно индивидуальному заданию и вывод изменённой
;матрицы.
;В программе должна быть выделена память под матрицу 9х9. Фактический размер
;задаётся пользователем и не превышает 9х9.
;Матрицу считать статической (как если бы в Си она была объявлена char a[9][9])
;и работать с ней соответствующим образом.
;Тип “цифровая” означает, что элементом является цифра.

;прямоугольная цифровая
;заменить каждый элемент на результат сложения этого
;элемента с последующим. Последние элементы строк не
;менять. Вывести только последние цифры новых значений


;сегмент данных под матрицу
SD SEGMENT para public 'DATA'
	ROWS db ?					; количество строк
	COLS db ?					; количество столбцов
	MATRIX db 9*9 dup (?)       ; матрица размера 9 * 9
SD ENDS

STK SEGMENT PARA STACK 'STACK'		;имя  вырав  тип   класс
	db 100 dup(0)  					;выделить 1 байт * 100 и заполнить нулями
STK ENDS

CSEG SEGMENT para public 'CODE'
	assume CS:CSEG, DS:SD, SS:STK   	;связывем сегменты

;пробел(для красоты)))
show_space:
	mov ah, 02h					
	mov dl, 32					
	int 21h	
	ret
;новая строка(для красоты)))
show_line:
	mov ah, 2				;в ah команду 02 (Вывод символа в stdout)
	mov dl, 13				;выполнить команду - вывести символ c кодом из DL(13=00001101=CR-Возврат каретки)
	int 21h					;курсор или механизм печати к крайней левой позиции текущей строки
	mov dl, 10				;выполнить команду - вывести символ c кодом из DL(10=00001010=LF-Перевод строки)
	int 21h
	ret

;ввод цифры в al (именно цифра)
input_digit:						
	mov ah, 01h
	int 21h						;получаем значение от пользователя
	sub al, '0'  				;преобразуем сивол в цифру				
	ret

;вывод цифры из dl (именно цифры)
output_digit:						
	mov ah, 02h
	add dl, '0'					;преобразуем цифру в символ
	int 21h						;вывод
	ret
	
;ввод количества строк
input_rows:	
	call input_digit
	mov ROWS, al				;помещаем количество строк в ROWS
	call show_space
	ret

;ввод количества столбцов
input_cols:						
	call input_digit
	mov COLS, al				;помещаем количество столбцов в COLS	
	call show_space
	ret

;ввод матрицы
input_matrix:
	xor     cx,cx           ;чистим регистр cx
    lea     bx, MATRIX 		;начинаем с нулевой строки
    mov     cl, ROWS
in1:    ;цикл по строкам
	call show_line
    push    cx				;поместить cx в стек, уменьшив sp на размер cx
    mov     cl, COLS
    mov     si,0			;с нулевого столбца
in2:    ;цикл по столбцам
    call input_digit
    mov     [bx][si],al		;ввод очередного элемента
    inc     si
	call show_space
    loop    in2
	
	
    add     bl, cols		;на следующую строку
    pop     cx				;в cx снова по строкам
    loop    in1
	
	ret
	
;вывод матрицы
output_matrix:
	call show_line
	xor     cx,cx           ;чистим регистр cx
    lea     bx, MATRIX 		;начинаем с нулевой строки
    mov     cl, ROWS
out1:    ;цикл по строкам
	call show_line
    push    cx				;поместить cx в стек, уменьшив sp на размер cx
    mov     cl, COLS
    mov     si,0			;с нулевого столбца
out2:    ;цикл по столбцам
	mov dl, [bx][si]
	cmp 	dl, 9			;выводить только последнюю цифру
	ja	sub10
	jna continue
sub10:	sub dl, 10
continue:
    call output_digit		;вывод очередного элемента		
    inc     si
	call show_space
    loop    out2
 
    add     bl, cols
    pop     cx				;в cx снова по строкам
    loop    out1
	
	ret

;сложение
sum_matrix:
	xor     cx,cx           ;чистим регистр cx
    lea     bx, MATRIX 		;начинаем с нулевой строки
    mov     cl, ROWS
	dec		COLS			;последний столбец не менять
sum1:    ;цикл по строкам
    push    cx				;поместить cx в стек, уменьшив sp на размер cx
    mov     cl, COLS
    mov     si,0			;с нулевого столбца
sum2:    ;цикл по столбцам
	mov 	al, byte ptr [bx][si + 1]	;однобайтовая ячейка
	add 	byte ptr [bx][si], al       
    inc     si
    loop    sum2
 
    add     bl, cols
	inc		bl				;так как cols был уменьшен
    pop     cx				;в cx снова по строкам
    loop    sum1
	
	inc		COLS			;возвращаем исходное значение
	ret
	
	
main:
	mov ax, SD			
	mov ds, ax				;в ds адрес SD
	
	call input_rows			;вводим количество строк
	call input_cols			;вводим количество столбцов
	call input_matrix		;вводим матрицу
	call sum_matrix			;производим сложение по условию
	call output_matrix		;выводим матрицу
	
	mov ax, 4c00h			;4Ch Завершить программу с кодом al(00)
	int 21h
CSEG ENDS
END main					;завершение описания модуля c точкой входа main
