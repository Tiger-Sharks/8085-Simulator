;LIST 2

			PAGE,80
			TITLE--USING 8279 PERIWARE.

;****Following listing is w.r.t. battery backed ram at 138A:0100h but this 
;    programme can work in scratch pad ram located at 00000h. You can 
;    Enter the same from 0110:0100 and execute.

;Working of 8257 in DMA Write Mode is illustrated in this listing .In this mode
;8257 moves data from peripheral to the memory. During the initialization the 
;DMA controller actsin a Slave Mode set the data on the 8 bit port as given in 
;the list during the Master Mode 8257 enables port and writes data in given
;memory locations.

X86P57L2  SEGMENT

	ASSUME CS:X86P57L2, DS:X86P57L2 ,ES:X86P57L2
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
OUT  DX,AL        ; Out the control word reset the F/L
			; Flipflop.
MOV  AL,03H
MOV  DX,01EAH
OUT  DX,AL		; Out the terminal count LSB for ch2
MOV  AL,40H
OUT  DX,AL		; Out the terminal count MSB for ch2
			; enable DMA Write Mode. 
MOV  AL,00H
MOV  DX,01E8H
OUT  DX,AL		; Out the LSB of DMA starting address 
			; for ch2.
MOV  AL,0B0H
MOV  DX,01E8H
OUT  DX,AL  	; Out the MSB for DMA starting address.
MOV  AL,44H
MOV  DX,01F0H
OUT  DX,AL		; Out the control word to enable ch 2. set 
			; the terminal count bit also.
INT 0A5H		; Return to Command Mode.

X86P57L2  ENDS
     END  STRT


