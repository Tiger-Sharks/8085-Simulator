;LIST 1B
;This program configures the 8255 in Mode 0 (Simple I/O Mode.) Port B is
;configured as output port. The program receives a byte from keyboard and then
;it is written to port B.
;Program terminates in Command Mode.

PAGE,80
TITLE--USING 8255 PERIWARE.

X86P551B  SEGMENT

	ASSUME CS:X86P551B, DS:X86P551B ,ES:X86P551B
	ORG 100H 	;Com format is recommended.
STRT:	JMP  SKIP_DATA 	;Skip lookup/bases if any

;On kit you need to do init for SP [to separate stack of your 
;programme from monitors], DS as shown below. SS, ES are 
;set to 0000 at power on by monitor. You can of course change 
;it by adding a few more move's but while working on PC you 
;can't touch segment registers since they are set by dos loader, 
;so manage these instructions as shown in comment field.

SKIP_DATA:
	MOV  AX,10FFH	;Initof SP for Kit
	MOV  SP,AX	;On PC
	PUSH CS	;Init for DS
	POP  AX	;Load kit INTS 
	MOV  DS,AX	;(A0-BF) 
	NOP	;In PC using
	NOP	;CALL in place
	NOP	;of 3 NOP`S

	MOV AL,80H		; Control Word for Mode 0, B-output.
	MOV DX,01E6H	; CSW address
        OUT DX,AL               ; 80H To control register.

                        	; Note: Following ISR is used by Mode 0, Mode 1
ISRO55:	POP  BX	; Remove prog. counter from stack.
	INT 0ACH		;CRLF, Set cursor to left.
	MOV BX,OFFSET MSG	;Pointer for look up table.
	MOV AL,02H
	MOV AH,10H
	INT 0B9H		;RCVNO, Routine to receive number.
        MOV AL,DL
	MOV DX,01E2H
	OUT DX,AL		; Out data to port 3B.
	INT 0A4H		; Go to Command Mode.
				
MSG:    DB  "BYTE    ",03H      ; Look up table ASCII data for "BYTE"
                                ; End of text.

	X86P551B  ENDS
     	END  STRT


