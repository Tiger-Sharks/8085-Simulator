

;LIST 5

                   PAGE,80
       TITLE--USING 8253 PERIWARE.

;****Following listing is w.r.t. battery backed ram at 12EF:0100h but this 
;    programme can work in scratch pad ram located at 00000h. You can  
;    Enter the same from 0110:0100 and execute.

;A program to demonstrate the working of 8253 in Mode 4.
;After the mode is set,the output will be high, when the
;count is loaded, the counter will begin counting on 
;terminal count. The counter will go low for one input 
;clock period, then will go high again.

X86P53L5  SEGMENT

	ASSUME CS:X86P53L5, DS:X86P53L5 ,ES:X86P53L5
	ORG 100H 	;Com format is recommended.
STRT:	JMP  SKIP_DATA 		;Skip lookup/
				;bases if any

;On kit you need to do init for SP [to separate stack of your 
;programme from monitors], DS as shown below. SS, ES are 
;set to 0000 at power on by monitor. You can of course change 
;it by adding a few more move's but while working on PC you 
;can't touch segment registers since they are set by dos loader, 
;so manage these instructions as shown in comment field.

SKIP_DATA:
MOV   AX,10FFH		;Initof SP for Kit
MOV   SP,AX		;On PC
PUSH  CS		;Init for DS
POP   DS		;Load kit INTS 
			;(A0-BF) 
NOP			;In PC using
NOP			;CALL in place
NOP			;of 3 NOP`S

MOV  AL,18H	; Initialization-Counter 0,
		; Mode 4, Binary.
MOV  DX,01E6H
OUT  DX,AL

MOV  AL,08H	; Count value to be loaded.
MOV  DX,01E0H
OUT  DX,AL
MOV  DX,01E6H
IN   AL,DX	; No operation-alongwith the next
		; no op, provides a clock pulse to
		; load the counter with the count value.
IN   AL,DX	; No operation.
UP:	
MOV  DX,01E0H
IN   AL,DX	; Reads the present count.
CMP  AL,00H	; Checks for the end of count.
JNZ  UP
INT 0A5H


X86P53L5  ENDS
     END  STRT





