
;LIST 4
                   PAGE,80
       TITLE--USING 8253 PERIWARE.

;****Following listing is w.r.t. battery backed ram at 12DC:0100h but this 
;    programme can work in scratch pad ram located at 00000h. You can 
;    Enter the same from 0110:0100 and execute.

;A program to demonstrate the 8253 in Mode 3, which is also 
;called as Square-Wave Generator. The output will remain high
;until one half the count has been completed. (for even numbers)
;and go low for the other half of the count. If the count is odd 
;and the output is high, the first clock pulse decrements the 
;count by 1 subsequent clock pulses decrement the clock by 2. 
;After time out, the output goes low and the full count is reloaded,
;the first clock pulse decrements the counter by 3 subsequent
;clock pulses decrement the count by 2, until timeout. In this
;way if the count is odd the output will be high for (n+1) / 2 
;counts and low for (n-1) / 2 counts.



X86P53L4  SEGMENT

	ASSUME CS:X86P53L4, DS:X86P53L4 ,ES:X86P53L4
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

MOV  AL,96H	; Initialization-Counter2, 
		;Mode3, Binary.
MOV  DX,01E6H
OUT  DX,AL
MOV  AL,08H	; Count value to be loaded.
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
JMP  UP

X86P53L4  ENDS
     END  STRT


