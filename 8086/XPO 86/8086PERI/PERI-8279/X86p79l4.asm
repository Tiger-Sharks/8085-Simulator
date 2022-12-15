
;LIST 6
			PAGE,80
			TITLE--USING 8279 PERIWARE.

;****Following listing is w.r.t. battery backed ram at 139E:0100h but this 
;    programme can work in scratch pad ram located at 00000h. You can 
;    Enter the same from 0110:0100 and execute.

;In 8279 port A & port B can be used as 2 separate 4 bit  ports.
;CPU can write data to any one of them without  affecting the 
;data at other port by masking that port.This is demonstrated 
;in this experiment.

X86P79L6  SEGMENT

	ASSUME CS:X86P79L6, DS:X86P79L6 ,ES:X86P79L6
	ORG 100H 	;Com format is recommended.
STRT:	JMP  SKIP_DATA 	;Skip lookup/
			;bases if any

;On kit you need to do init for SP [to separate stack of your 
;programme from monitors], DS as shown below. SS, ES are 
;set to 0000 at power on by monitor. You can of course change 
;it by adding a few more move's but while working on PC you 
;can't touch segment registers since they are set by dos loader, 
;so manage these instructions as shown in comment field.

SKIP_DATA:
MOV  AX,10FFH  ;Initof SP for Kit
MOV  SP,AX     ;On PC
PUSH CS	   ;Init for DS
POP  AX	   ;Load kit INTS 
MOV  DS,AX	   ;(A0-BF) 
NOP		   ;In PC using
NOP		   ;CALL in place
NOP		   ;of 3 NOP`S


MOV  AL,0DFH	; Clear command is issued
MOV  DX,01E2H	
OUT  DX,AL	

MOV CX,0FFFH 	; Call delay to wait for 
INT 0AAH	; clear command  to complete.

MOV  AL,07H	; Decoded display Scan-
MOV  DX,01E2H	; Mode set.
OUT  DX,AL	

MOV  AL,80H	; Write display RAM 
OUT  DX,AL	; command.

MOV  AL,0A8H    ; C/W to inhibit port A for 
OUT  DX,AL	; writing.

MOV  AL,00H
MOV  DX,01E0H
OUT  DX,AL	; Write port B corresponding
                                                                                    ; all 4 segments lighted.

MOV  AL,0A4H
MOV  DX,01E2H
OUT  DX,AL	; C/W to inhibit port B for 
		; writing.
WRITE:
MOV  AL,00H
MOV  DX,01E0H
OUT  DX,AL	; Write port A corresponding
                                                                                    ;  all 4 segments lighted.
MOV  CX,0FFFH
INT 0AAH	; Call delay for display 
		; to become stable.
MOV  AL,0F0H
OUT  DX,AL	; Write port A Corresponding
                                                                                    ; all 4 segments switched off.


MOV  CX,0FFFH
INT 0AAH	; Call delay for display 
		; to become stable.
	
JMP  WRITE	; Jump back to write port 
		; A again.

X86P79L6  ENDS
     END  STRT


