;Program to find log to base 10 of a a number. The log is looked up 
;in a table. The log is stored as a multiplied by 10000 number. i.e.
;Actual answer that we get is 10000*log(number)
;THE LOG IS LOOKED UP A LOOKUP TABLE.
;A SECOND METHOD OF DOING LOG CALCULATIONS IS TO ADD THE LOG SERIES TO
;A PREDECIDED NUMBER OF ELEMENTS.

COMSEG SEGMENT
	ASSUME CS:COMSEG, DS:COMSEG, SS:COMSEG, ES:COMSEG
	
	ORG 0100H			;ORG FOR COM STRUCTURED PROGRAMS (ALL SEGMENTS IN ONE SEGMENT
						;AND PROGRAM MAXIMUM SIZE 64KbYTES.)
	
START:
	JMP SKIP_DATA		;SKIP OVER DATA DECLARATIONS

;--------------DEFINE DATA SIZES AND NAMES--------

TABLE DW 0,3010,4771,6021,6990,7782,8451,9031,9542,10000
	
NUM DB 2	
ANSWER DW ?
	
;--------------END OF DATA DEFINITION-------------
	
SKIP_DATA:
	MOV AX,10FFH		;Initof SP for Kit
	MOV SP,AX			;On PC

	PUSH CS			;Init for DS
	POP DS
	
	NOP
	NOP
	NOP
	
	MOV AH,00H
	MOV AL,BYTE PTR NUM			;GET NUMBER TO LOOKUP LOG OF
	JNZ LOOKUP						;IF NUMBER ZERO INDICATE ERROR
	MOV DX,0EEEEH
	JMP ENDPROG
LOOKUP:	
	SUB AL,1
	CBW
	ROL AL,1
	LEA BX,TABLE		;LOAD STARTING ADDRESS OF TABLE
	ADD BX,AX
	MOV DX,[BX]				;LOOKUP THE LOG
ENDPROG:
	MOV ANSWER,DX
	INT 0A5H
COMSEG ENDS	
END START
