;LIST 3
                   PAGE,80
       TITLE--USING 8253 PERIWARE.

;****Following listing is w.r.t. battery backed ram at 12C9:0100h but this 
;    programme can work in scratch pad ram located at 00000h. You can 
;    Enter the same from 0110:0100 and execute.


;A program to demonstrate the 8253 in Mode 2. Here the output will go
;low for ONE period of the clock input. The period from one output pulse
;to the next equals the number of input counts in the count register.

X86P53L3  SEGMENT

	ASSUME CS:X86P53L3, DS:X86P53L3 ,ES:X86P53L3
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


MOV  AL,94H	; Initialization-Counter 2,
MOV  DX,01E6H
OUT  DX,AL	; Mode 2, Binary.

MOV  AL,04H	; Count value to be loaded.
MOV  DX,01E4H
OUT  DX,AL
MOV  DX,01E6H
IN   AL,DX	; No operation-alongwith the next
		; no op, provides a clock pulse to
		; load the counter with the count value.
IN   AL,DX	; No operation.
UP:	
MOV  DX,01E4H
IN   AL,DX	; Reads the present count.
CMP  AL,01H     ; Checks for the end of count.
JNZ  UP
INT 0A5H


X86P53L3  ENDS
     END  STRT





