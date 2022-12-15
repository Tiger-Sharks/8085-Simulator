; PROGRAM TO REVERSE A STORED STRING.
; THE PROGRAM GETS A STRING TO REVERSE FROM THE USER ON SERIAL PORT.
; THE STRING IS ECHOED BACK AS IT IS ENTERED. WHEN USER PRESSES ENTER
; THE STRING RECEIVED TILL THAT POINT IS REVERSED AND ECHOED BACK.

COMSEG SEGMENT
	ASSUME CS:COMSEG, DS:COMSEG, SS:COMSEG, ES:COMSEG
	
	ORG 0100H			;ORG FOR COM STRUCTURED PROGRAMS (ALL SEGMENTS IN ONE SEGMENT
						;AND PROGRAM MAXIMUM SIZE 64KbYTES.)
	
START:
	JMP SKIP_DATA		;SKIP OVER DATA DECLARATIONS
	
;--------------DEFINE DATA SIZES AND NAMES--------

MAXM_STRING EQU 1000
STRINGTOREVERSE DB MAXM_STRING DUP(?)
REVERSESTRING DB MAXM_STRING DUP(?)
	
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
	
	MOV CX,00H		;NUMBER OF CHARACTERS RECEIVED.
	MOV SI,OFFSET STRINGTOREVERSE
	
READ_STRING:	
	MOV AH,01H		;GET CHARACTER ON SERIAL PORT WITH ECHO BACK AND STORE 
	INT 0A2H		;IT TO LOCATION POINTED TO BY SI.
	CMP AL,13		;CHECK IF RECEIVED CHARACTER IS CR OR LF
	JE STRING_DONE
	CMP AL,10
	JE STRING_DONE	;IF EITHER CHARACTER IS RECEIVED DECLARE COMPLETE STRING
	MOV [SI],AL	;HAS BEEN RECEIVED.
	INC CX			;INCREMENT NUMBER OF CHARACTERS RECEIVED.
	INC SI			;INCREMENT STORAGE POINTER
	JMP READ_STRING
STRING_DONE:	
	
	CMP CX,0		;IF USER PRESSED ENTER DIRECTLY, EXIT
	JE DONE
	
	PUSH CX
	MOV BX,OFFSET STRINGTOREVERSE
	MOV SI,OFFSET REVERSESTRING
	ADD SI,CX
	DEC SI			;REVERSE THE STRING USING BX AS THE SOURCE POINTER
					;AND SI AS THE DESTINATION POINTER.
REVERSELOOP:
	MOV AL,[BX]	;BEGIN MOVING THE STRING FROM END OF STRING TOWARDS START.
	MOV [SI],AL
	INC BX
	DEC SI
	LOOP REVERSELOOP
	
	POP CX
	MOV BX,OFFSET REVERSESTRING
	
	MOV SI,OFFSET REVERSESTRING
	ADD SI,CX
	MOV AL,03H
	MOV [SI],AL

	INT 0AFH		;UPLOAD THE STRING ON SERIAL PORT.
	
DONE:
	INT 0A5H
	
	
COMSEG ENDS
END START	