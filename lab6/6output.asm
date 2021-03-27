EXTRN TO_UB : NEAR					; перевод числа в беззнаковое в 2 с/с
EXTRN TO_SD : NEAR					; перевод числа в знаковое в 10 с/с
EXTRN UB : BYTE						; строка - беззнаковое в 2 с/с
EXTRN SD : BYTE						; строка - знаковое в 10 с/с

PUBLIC NEW_STR						; возврат картеки и перевод на новую строку
PUBLIC OUTPUT_UB					; вывод беззнакового в 2 с/с
PUBLIC OUTPUT_SD					; вывод знакового в 10 с/с

DATASEG SEGMENT PARA PUBLIC 'DATA'
    OUTPUT_UB_MSG DB 'Unsigned binary number: $'
    OUTPUT_SD_MSG DB 'Signed decimal number: $'
DATASEG ENDS

CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG

NEW_STR PROC NEAR					; возврат картеки и перевод на новую строку
    MOV AH, 2
    MOV DL, 13
    INT 21H
    MOV DL, 10
    INT 21H
    RET
NEW_STR ENDP

OUTPUT_UB PROC NEAR					; вывод беззнакового в 2 с/с
    MOV AH, 9						; вывод сообщения
    MOV DX, OFFSET OUTPUT_UB_MSG
    INT 21H

    CALL TO_UB						; перевод числа 

    MOV AH, 9						; вывод числа
    MOV DX, OFFSET UB
    INT 21H

    CALL NEW_STR
    CALL NEW_STR

    RET
OUTPUT_UB ENDP

OUTPUT_SD PROC NEAR					; вывод знакового в 10 с/с
    MOV AH, 9						; вывод сообщения
    MOV DX, OFFSET OUTPUT_SD_MSG
    INT 21H

    CALL TO_SD						; перевод числа

    MOV AH, 9						; вывод числа
    MOV DX, OFFSET SD
    INT 21H

    CALL NEW_STR
    CALL NEW_STR

    RET
OUTPUT_SD ENDP

CODESEG ENDS
END