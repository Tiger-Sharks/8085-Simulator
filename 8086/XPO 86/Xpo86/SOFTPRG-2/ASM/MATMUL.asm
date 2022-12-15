;Program to carry Three by Three matrix multiplication
;MATRIX 1 IS SCANNED ROW BY ROW, FOR EVERY ELEMENT IN A ROW IN FIRST MATRIX
;ONE COLUMN OF THE SECOND MATRIX IS PROCESSED. THIS PROCESS IS CONTINUED
;TILL ALL ROW OF FIRST MATRIX ARE SCANNED.
;THIS PROCEDURE IS PERFORMED USING A REPEATITIVE CALL TO A PROCEDURE (ROUTINE)
;THAT PERFORMS THE ROW*COL MULTIPLICATION TO GET VALUE OF THE ELEMENT AT 
;CURRENT LOCATION.

COMSEG SEGMENT
	ASSUME CS:COMSEG, DS:COMSEG, SS:COMSEG, ES:COMSEG
	
	ORG 0100H			;ORG FOR COM STRUCTURED PROGRAMS (ALL SEGMENTS IN ONE SEGMENT
						;AND PROGRAM MAXIMUM SIZE 64KbYTES.)
	
START:
	JMP SKIP_DATA		;SKIP OVER DATA DECLARATIONS

;--------------DEFINE DATA SIZES AND NAMES--------

AR1 DB 1,2,-3		;Matrix 1 Row 1
AR2 DB 4,5,6		;Matrix 1 Row 2
AR3 DB 2,-1,3		;Matrix 1 Row 3
	
BC1 DB 2,4,-4		;Matrix 2 Row 1
BC2 DB 3,-2,5		;Matrix 2 Row 2
BC3 DB 1,5,2		;Matrix 3 Row 3
	
CO DB 9 DUP(?)
J2 DB ?				;Counters
J1 DB ?

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
	MOV BP,00H
	MOV J2,3
	LEA SI,AR1
	
	MOV CX,3
	
LOOP1:
	LEA DI,BC1
    MOV AX,3
    SUB AX,CX
    PUSH DI
    ADD DI,AX
	CALL MATMUL		;PERFORM MULTIPLICATION OF ROW*COLUMN TO GET CURRENT ELEMENT.
	POP DI
	MOV DS:CO[BP],DL
	INC BP
	
	LOOP LOOP1		;PROCESS THE NEXT ROW.
	
	MOV CX,3
	ADD SI,3
	DEC J2
	JNE LOOP1

	INT 0A5H
	
;----------END OF MAIN PROGRAM----------

	MATMUL PROC NEAR
	
	PUSH CX
	PUSH SI
	
	MOV CX,3
	MOV DL,0
	
AGAIN:
	MOV AL,BYTE PTR[SI]
	IMUL BYTE PTR [DI]
	ADD DL,AL
	ADD DI,3
	INC SI
	LOOP AGAIN
	POP SI
	POP CX
	RET
	
	MATMUL ENDP
	
COMSEG ENDS
END START
