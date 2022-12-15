;LIST 4

;This program configures the 8255 in BSR mode.
;PC3 is toggled by setting and resetting again and again.
;This program remains in loop. To come out of it press Reset.

PAGE 80
TITLE -- USING 8255 PERIWARE.
X86P554  SEGMENT

	ASSUME CS:X86P554, DS:X86P554 ,ES:X86P554
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
	
	MOV  AL,80H		; Control Word for port C - output
	MOV DX,01E6H	; CSW Address in DX
	OUT DX,AL		; Write csw (OUT 90 to 01E6H)
BACK:	MOV AL,07H		;Control word to set PC3.
	OUT DX,AL
	MOV CX,0FFFFH	;Delay count
	INT 0AAH		;Delay routine
	
	MOV AL,06H		;Control word to reset PC3.
	OUT DX,AL
	MOV CX,0FFFFH	;Delay count
	INT 0AAH		;Delay routine
    
    JMP  BACK

	X86P554  ENDS
     	END  STRT


