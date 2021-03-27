PUBLIC NUMBER						; исходное беззнаковое число в 16 c/c, записанное как обычное

PUBLIC INPUT_CMD					; ввод номера команды в регистр SI
PUBLIC INPUT_UH						; ввод беззнакового в 16 с/c

DATASEG SEGMENT PARA PUBLIC 'DATA'
    NUMBER DW 0
	INPUT_UH_MSG DB 'Enter unsigned hexadecimal number (from 0000 to FFFF): $'
DATASEG ENDS

CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG

INPUT_CMD PROC NEAR					; ввод номера команды в регистр SI
    MOV AH, 1						; считать символ в al
    INT 21H
    SUB AL, '0'						; перевод в числовое значение
    MOV CL, 2
    MUL CL							; домножаем на 2 (размер команды 2 байта)
    MOV SI, AX
    RET
INPUT_CMD ENDP

INPUT_UH PROC NEAR					; ввод беззнакового в 16 с/c
		MOV AH, 9					; вывод сстроки из DS:DX
		MOV DX, OFFSET INPUT_UH_MSG
		INT 21H

		MOV BX, 0					; вводить число будем в BX

    INSYMB:
        MOV AH, 1					; считать символ в al
        INT 21H
        CMP AL, 13					; если ввели enter - закончить
        JE END_INPUT_UH
		SUB AL, '0'
		CMP AL, 9					; если ввели букву - вычесть 7 (до кода ASCII)
		JL ADD_NUMBER
		SUB AL, 7
	ADD_NUMBER:	
		MOV CL, 4
		SAL BX, CL					; сдвинуть уже записанное число
		ADD BL, AL					; добавить в него очередную "цифру" 
        JMP INSYMB					; считать следующий символ

    END_INPUT_UH:					; конец ввода
		MOV NUMBER, BX				; перемещаем число в NUMBER
		RET
INPUT_UH ENDP

CODESEG ENDS
END