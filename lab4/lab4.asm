;Требуется написать программу в которой ввести строку в один сегмент данных,
;затем скопировать первые 4 символа в переменную в другом сегменте данных и
;вывести 2-й из них на экран.

;2 сегмента данных, которые расположатся друг за другом
;первый - для ввода строки по адресу DS:DX
SD1 SEGMENT para public 'DATA'
	STRING db 101 dup ('$')       ;выделим 101 байт и заполним символом окончания строки $
SD1 ENDS

;второй - для копирования первых 4 символов в es
SD2 SEGMENT para public 'DATA'
	STR_PART db 5 dup ('$')       ;выделим 5 байт и заполним символом окончания строки $
SD2 ENDS


CSEG SEGMENT para public 'CODE'
	assume CS:CSEG, DS:SD1, ES:SD2    		;связывем сегменты
	
;блок команд вводит строку в переменную STRING из сегмента DS
input:
	mov si, 0
	mov STRING[si], 100		;готовим буфер - указываема максимально допустимую длину ввода (от 1 до 254)
	
	lea dx, STRING			;в dx - буфер - переменную STRING. Смещение 0 относительно ds
							;вычисляет эффективный адрес (БАЗА + СМЕЩЕНИЕ + ИНДЕКС) 
	;mov dx, 0				;или так
	;mov dx, STRING			;почему не работает? memory-to-memory
	mov ah, 10				;в ah команду 10(0Ah) считать строку из stdin в буфер
							;max len ввод, заканчивающийся символом CR
	int 21h
	ret						;RET возращает управление по адресу из стека.
	
;блок команд копирует первые 4 символа STRING в STR_PART
copy4:
	mov cx, 4 				;повторяем 4 раза
copy1:
	sub cx, 1				;копируем в индексы 3,2,1,0
	mov di, cx
	add cx, 2				;нам нужно скопировать символы с индексами 5,4,3,2
							;так как первые 2 - max, len
	mov si, cx
	mov ah, STRING[si]
	mov STR_PART[di], ah
	sub cx, 1
	loop copy1		

	ret						;RET возращает управление по адресу из стека.
	
;блок команд возвращает каретку, переводит строку и выводит 2 символ переменной STR_PART из ES
output2:
	mov ah, 2				;в ah команду 02 (Вывод символа в stdout)

	mov dl, 13				;выполнить команду - вывести символ c кодом из DL(13=00001101=CR-Возврат каретки)
	int 21h					;курсор или механизм печати к крайней левой позиции текущей строки
	
	mov dl, 10				;выполнить команду - вывести символ c кодом из DL(10=00001010=LF-Перевод строки)
	int 21h
	
	mov si, 1
	mov dl, STR_PART[si]	
	int 21h					;выполнить команду - вывести 2 символ из STR_PART
	
	ret						;RET возращает управление по адресу из стека.
	
main:
	mov ax, SD1				
	mov ds, ax				;в ds адрес SD1
	
	mov ax, SD2				
	mov es, ax				;в es адрес SD2
	
	call input				;вводим строку в переменную STRING из сегмента DS
	call copy4				;копируем первые 4 символа STRING в STR_PART
	call output2			;выводим 2 символ переменной STR_PART из ES
	
	mov ax, 4c00h			;4Ch Завершить программу с кодом al(00)
	int 21h
CSEG ENDS
END main					;завершение описания модуля c точкой входа main
