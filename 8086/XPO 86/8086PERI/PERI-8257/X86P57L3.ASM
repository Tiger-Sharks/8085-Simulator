
;LIST 3


			PAGE,80
			TITLE--USING 8279 PERIWARE.

;****Following listing is w.r.t. battery backed ram at 138A:0100h but this 
;    programme can work in scratch pad ram located at 00000h. You can 
;    Enter the same from 0110:0100 and execute.

;8257 working in DMA Burst Mode is illustrated in this software. Before 
;executing this program clear the memory locations from B000 to B7FF by loading 
;byte 00. Set the data on the 8 bit port during the initialization. 8257 writes 
;the full 2k memory with the data given on the port.


X86P57L3  SEGMENT

	ASSUME CS:X86P57L3, DS:X86P57L3 ,ES:X86P57L3
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
MOV  SP,AX	   ;On PC
PUSH CS	   ;Init for DS
POP  AX	   ;Load kit INTS 
MOV  DS,AX	   ;(A0-BF) 
NOP		   ;In PC using
NOP		   ;CALL in place
NOP		   ;of 3 NOP`S

MOV  AL,00H	
MOV  DX,01F0H
OUT  DX,AL	; Out the control word to reset F;L FF.
MOV  AL,0FEH
MOV  DX,01EAH
OUT  DX,AL	; Out the LSB of terminal count for ch2.
MOV  AL,47H
OUT  DX,AL	; Out the MSB of terminal count for ch2.
		; DMA Write Mode is also initialized.
	
MOV  AL,00H
MOV  DX,01E8H
OUT  DX,AL	; Out the LSB of DMA starting address
		; for ch 2.
MOV  AL,0B0H
OUT  DX,AL	; Out the MSB of DMA starting address
		;for ch 2.
MOV  AL,44H
MOV  DX,01F0H
OUT  DX,AL	; Out the Control Word to enable ch 2.

INT 0A5H	; Return to Command Mode.

X86P57L3  ENDS
     END  STRT


