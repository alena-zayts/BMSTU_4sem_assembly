EXTRN INPUT_CMD: NEAR				; ввод номера команды в регистр SI
EXTRN INPUT_UH: NEAR				; ввод беззнакового в 16 с/c

EXTRN OUTPUT_UB: NEAR				; вывод беззнакового в 2 с/с
EXTRN OUTPUT_SD: NEAR				; вывод знакового в 10 с/с
EXTRN NEW_STR: NEAR					; возврат картеки и перевод на новую строку

DATASEG SEGMENT PARA PUBLIC 'DATA'
    MENU DB 'Available actions:', 13, 10, 10
         DB '1. Input unsigned hexadecimal number;', 13, 10
         DB '2. Convert to unsigned binary number;', 13, 10
         DB '3. Convert to signed decimal number;', 13, 10, 10
         DB '0. Exit program.', 13, 10, 10
         DB 'Choose action: $'
    ACTIONS DW  EXIT, INPUT_UH, OUTPUT_UB, OUTPUT_SD
DATASEG ENDS


STACKSEG SEGMENT PARA STACK 'STACK'
    DB 200H DUP(0)
STACKSEG ENDS

CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG, SS:STACKSEG

OUTPUT_MENU PROC NEAR					; вывод меню
    MOV AH, 9
    MOV DX, OFFSET MENU
    INT 21H
    RET
OUTPUT_MENU ENDP

EXIT PROC NEAR							; выход из программы
    MOV AX, 4C00H
    INT 21H
EXIT ENDP

MAIN:
    MOV AX, DATASEG
    MOV DS, AX
	
    MAINLOOP:							; основной цикл
        CALL OUTPUT_MENU
        CALL INPUT_CMD
        CALL NEW_STR
        CALL ACTIONS[SI]
        JMP MAINLOOP

CODESEG ENDS
END MAIN