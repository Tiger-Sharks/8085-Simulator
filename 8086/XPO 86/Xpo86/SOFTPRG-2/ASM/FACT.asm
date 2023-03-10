;Program to carry out factorial calculation by recursion.
;The final answer for the program is popped out in AX register. Since
;this register is only 16bits, the largest factorial that can be
;calculated is for 8 (40320 == 9D80H)

COMSEG SEGMENT
	ASSUME CS:COMSEG, DS:COMSEG, SS:COMSEG, ES:COMSEG
	
	ORG 0100H			;ORG FOR COM STRUCTURED PROGRAMS (ALL SEGMENTS IN ONE SEGMENT
						;AND PROGRAM MAXIMUM SIZE 64KbYTES.)
	
START:
	JMP SKIP_DATA		;SKIP OVER DATA DECLARATIONS

;--------------DEFINE DATA SIZES AND NAMES--------

NUMBER EQU 6
	
;--------------END OF DATA DEFINITION-------------
	
SKIP_DATA:
	MOV AX,10FFH		;Initof SP for Kit
	MOV SP,AX			;On PC

	PUSH CS			;Init for DS
	POP DS
	
	NOP
	NOP
	NOP
	
;--------END OF SEGMENT REGISTER INITIALIZATIONS-----

	SUB SP,0004H  
	MOV BP,SP  	
	MOV AX,NUMBER
	PUSH AX
	CALL FACT		;START RECURSIVE FACTORIAL CALCULATION
	POP AX
    POP AX
	INT 0A5H				;RETURN TO COMMAND MODE
	
;-------------END OF MAIN PROGRAM
	
	FACT PROC NEAR
	PUSHF
	PUSH AX
	PUSH DX
	PUSH BP 
	MOV BP,SP  	
	MOV AX,[BP+10]
	CMP AX,0001H
	JNE PROCEED
	MOV WORD PTR [BP+12],01H
	MOV WORD PTR [BP+14],00H
	JMP DONE
	
PROCEED:
	SUB SP,0004H
	DEC AX
	PUSH AX
	MOV BP,SP		
	CALL FACT

	MOV AX,[BP+2]
	MUL WORD PTR [BP+16]
	MOV [BP+18],AX
	MOV [BP+20],DX
	ADD SP,0006H
DONE:
	POP BP
	POP DX
	POP AX
	POPF
	RET
	FACT ENDP
	COMSEG ENDS	
	END START
