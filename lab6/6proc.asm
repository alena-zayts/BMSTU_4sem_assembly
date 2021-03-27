EXTRN NUMBER : WORD					; исходное беззнаковое число в 16 c/c, записанное как обычное

PUBLIC UB							; строка - беззнаковое в 2 с/с
PUBLIC SD							; строка - знаковое в 10 с/с

PUBLIC TO_UB						; перевод числа в беззнаковое в 2 с/с
PUBLIC TO_SD						; перевод числа в знаковое в 10 с/с

DATASEG SEGMENT PARA PUBLIC 'DATA'
    UB DB 16 DUP('$'), '$'
    SD DB ' ', 5 DUP('0'), '$'
DATASEG ENDS

CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG

TO_UB PROC NEAR
    MOV AX, NUMBER		; число записано в AX
    MOV DI, 15			; начинаем заполнять строку с конца	
    LOOP_UB:
        MOV DL, AL		; очередной младший бит будет в DL
        AND DL, 1
        ADD DL, '0'
        MOV UB[DI], DL	; записываем очередной младший бит
        MOV CL, 1
        SAR AX, CL		; переходим к следующему символу
        DEC DI
        CMP DI, -1
        JNE LOOP_UB
    RET
TO_UB ENDP

TO_SD PROC NEAR
		MOV DI, 5					; максимальное количество цифр
		MOV AX, NUMBER				; число записано в AX
		;BT  AX, 15					; извлечение заданного бита в флаг cf
		MOV BX, 32768				; 2 в 15
		AND BX, AX
		CMP BX, 0
		JE COUNT_DIGITS				; подсчет цифр
		;BTR AX, 15                 ; сбросить старший бит в 0
		SUB AX, 32768
		MOV SD[0], '-'
		
	
	COUNT_DIGITS:
		CMP AX, 10000
		JA START_SD
		DEC DI
		CMP AX, 1000
		JA START_SD
		DEC DI
		CMP AX, 100
		JA START_SD
		DEC DI
		CMP AX, 10
		JA START_SD
		DEC DI
		CMP AX, 1
		JA START_SD
		DEC DI
		
	START_SD:	
		MOV CX, DI
		MOV BX, 10
		LOOP_SD:
			MOV DX, 0
; если делитель размером в слово, то делимое должно быть расположено в паре регистров dx:ax, 
; причем младшая часть делимого находится в ax. После операции частное помещается в ax, а остаток — в dx;
			DIV BX
			MOV SD[DI], DL
			LOOP LOOP_SD
    RET
TO_SD ENDP

CODESEG ENDS
END