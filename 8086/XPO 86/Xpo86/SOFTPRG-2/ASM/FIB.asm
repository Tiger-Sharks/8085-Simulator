;TO GENERATE FIBONACCI SERIES.
;NOTE:-PROGRAM GENERATE THE FIBONACCI SERIES UP TO THE NUMBMER DEFINE
;USING THE INSTRUCTION 'N DB 14'THUS FIBBONACCI SERIES IS
   ; FIBBO:-0,1,1,2,3,5,8,D
;SO EVERY ELEMENT IS ADDITION OF PREVIOUS TWO ELEMENTS.
;THE PROGRAM USES RECURSIVE CALL TO A PROCEDURE TO CALCULATE THE NEXT
;ELEMENT.THE SAME SERIES CAN BE GENERATED USING LOOPING CONSTRUCTS AS WELL,
;HOWEVER THIS IS DONE TO DEMONSTRATE RECURSIVE CALLING TECHNIQUES.


COMSEG SEGMENT
	ASSUME CS:COMSEG, DS:COMSEG, SS:COMSEG, ES:COMSEG
	
	ORG 0100H			;ORG FOR COM STRUCTURED PROGRAMS (ALL SEGMENTS IN ONE SEGMENT
						;AND PROGRAM MAXIMUM SIZE 64KBYTES.)
	
START:
	JMP SKIP_DATA		;SKIP OVER DATA DECLARATIONS

;--------------DEFINE DATA SIZES AND NAMES--------
	
N DB 14
FIB DB 15 DUP (?)

;--------------END OF DATA DEFINITION-------------

SKIP_DATA:	
	MOV AX,10FFH
	MOV SP,AX
	
	MOV AX,0000H
	MOV SS,AX
	MOV ES,AX
	
	PUSH CS
	POP DS
	
	NOP
	NOP
	NOP	
	
	MOV BX,00H
NT:
    MOV DL,00H
	PUSH BX
	CALL FIBO
	POP BX
	CMP DL,N
	JA DONE
	CMP DL,00H
	JE NO_STORE
	MOV FIB[BX],DL
NO_STORE:	
	INC BX
	JMP NT
DONE:INT 0A5H
	
;--------------MAIN PROGRAM ENDS HERE----------

	FIBO PROC NEAR
	
	CMP BX,0
	JE EXIT1
	
	CMP BX,1
	JE EXIT2
	
	DEC BL
	PUSH BX
	CALL FIBO
	POP BX
	DEC BX
	CALL FIBO
	RET
EXIT1:
	RET
EXIT2:
	INC DL
	RET
	
	FIBO ENDP
	
COMSEG ENDS
END START
	
	