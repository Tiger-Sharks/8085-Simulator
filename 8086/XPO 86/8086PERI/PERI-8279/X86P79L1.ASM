;LIST 1
       TITLE--USING 8279 PERIWARE.

;****Following listing is w.r.t. battery backed ram at 1315:0100h but this 
;    programme can work in scratch pad ram located at 00000h. You can 
;    Enter the same from 0110:0100 and execute.

;Program in list 1 illustrates the operation of 8279
;in input mode. It detects valid key closure & immediately 
;reads corresponding Scan lines, Return lines, CNTL & SHIFT
;line status. It is displayed on 8 bit Data Bus LEDs.

X86P79L1  SEGMENT

	ASSUME CS:X86P79L1, DS:X86P79L1 ,ES:X86P79L1
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
MOV  AX,10FFH	;Initof SP for Kit
MOV  SP,AX	;On PC
PUSH CS		;Init for DS
POP  AX		;Load kit INTS 
MOV  DS,AX	;(A0-BF) 
NOP		;In PC using
NOP		;CALL in place
NOP		;of 3 NOP`S


MOV  AL,00H	; Control Word for 
MOV  DX,01E2H	; encoded Scan keyboard
OUT  DX,AL	; 2 key lockout.

STS: 
MOV  DX,01E2H
IN   AL,DX	; Read FIFO status to 
		; check key press.
AND  AL,07H	; If no key press is found 
JZ   STS	; go back.
		
MOV  DX,01E0H 	; Read FIFO to get code of 
IN   AL,DX	; key pressed.
JMP  STS	; Go back to check other 
		; key press.

X86P79L1  ENDS
     END  STRT

