.MODEL TINY

CODESEG SEGMENT
    ASSUME CS:CODESEG, DS:CODESEG
    ORG 100H                    ; 256 байт под PSP - Program Segment Prefix

MAIN:
    JMP INSTALL					 ; при первом заходе устанавливаем
    SAVED8H DD ?				 ; старый вектор прерывания	
    FLAG DB '1'                  ; установлен или нет
    

NEW8H PROC
    PUSH AX					; сохраняем старые регистры и флаги
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    PUSH SI
    PUSH ES
    PUSH DS
    PUSHF

    CALL CS:SAVED8H				; вызываем старый обработчик
	
	CMP ARG, 0
	JE NEW_MAX
	JNE CONT
NEW_MAX:
	MOV ARG, 64
CONT:
	DEC ARG
	
	MOV AH, 0F3h
	MOV AL, 96
	ADD AL, ARG
    OUT 60H, AX ; Порт 60h
								;доступен для записи и обычно принимает пары байтов последовательно: первый - код
								;команды, второй - данные. В частности, команда F3h отвечает за параметры режима
								;автоповтора нажатой клавиши.

;7 бит (старший) - всегда 0
;5,6 биты - пауза перед началом автоповтора (250, 500, 750 или 1000 мс)
;4-0 биты - скорость автоповтора (от 0000b (30 символов в секунду) до 11111b - 2
; ';символа в секунду).


    EXIT_NEW8H:
        POP DS
        POP ES

        POP SI
        POP DI
        POP DX
        POP CX
        POP BX
        POP AX

        IRET

NEW8H ENDP

INSTALL:						; установка
    MOV AX, 3508H 				; AH = 35H возвращает значение вектора прерывания для INT (AL); то есть, 
								; загружает в BX 0000:[AL*4], а в ES - 0000:[(AL*4)+2].
							
								;Прерывания, вызванные приходом кодов нажатия и отпускания клавиш, обрабатывает BIOS Int 9h. 
								;Результат обработки (как правило, ASCII-символ в младшем байте и скан-код в старшем) 
								;помещается в клавиатурный буфер, расположенный в ОЗУ. 
    INT 21H

    CMP ES:FLAG, '1'
    JE UNINSTALL

    							; сохраняем старый обработчик прерывания
    MOV WORD PTR SAVED8H, BX		
    MOV WORD PTR SAVED8H + 2, ES

	MOV AX, 2508H				; устанавливаем новый вектор прерывания
    MOV DX, OFFSET NEW8H 
    INT 21H
	
    MOV DX, OFFSET INSTALL_MSG
    MOV AH, 9
    INT 21H

    MOV DX, OFFSET INSTALL				; DX = адрес первого байта за резидентным участком программы (DX интерпретируется как смещение от PSP (DS/ES при запуске)
    INT 27H						; Эта функция завершает программу, оставляя резидентную часть (обработчик прерывания) в памяти.					


UNINSTALL:
    PUSH ES								; сохраняем ES и DS в стеке
    PUSH DS

    MOV DX, WORD PTR ES:SAVED8H          
    MOV DS, WORD PTR ES:SAVED8H + 2     
    MOV AX, 2508H                       ; устанавливаем старый вектор прерывания
    INT 21H

    POP DS
    POP ES

    MOV AH, 49H					; Освобождает блок памяти, начинающийся с адреса ES:0000. этот блок становится доступным для других запросов системы.
    INT 21H						; ES = сегментный адрес (параграф) освобождаемого блока памяти

    MOV DX, OFFSET UNINSTALL_MSG
    MOV AH, 9H
    INT 21H

    MOV AX, 4C00H
    INT 21H
	
	ARG DB 63
    INSTALL_MSG   DB 'Installed$'
    UNINSTALL_MSG DB 'Uninstalled$'


CODESEG ENDS
END MAIN
