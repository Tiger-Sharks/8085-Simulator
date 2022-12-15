
;LIST  1

			PAGE,80
			TITLE--USING 8257 PERIWARE.

;****Following listing is w.r.t. battery backed ram at 138A:0100h but this 
;    programme can work in scratch pad ram located at 00000h. You can 
;    Enter the same from 0110:0100 and execute.

;This program is written to illustrate the working of 8257 DMA controller in DMA 
;Read Mode. In this Mode 8257 will transfer data from memory to peripheral. 
;During the initialization the output of 8 bit port remains low. During that 
;time 8257  works in Slave Mode. Once the initialization is complete 8257 takes 
;the control of the Bus and starts acting in the Master Mode. It transfers data 
;directly to the peripheral device without further intervention of the CPU.

X86P57L1  SEGMENT

	ASSUME CS:X86P57L1, DS:X86P57L1 ,ES:X86P57L1
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
PUSH CS	       ;Init for DS
POP  AX	       ;Load kit INTS 
MOV  DS,AX     ;(A0-BF) 
NOP	       ;In PC using
NOP	       ;CALL in place
NOP	       ;of 3 NOP`S

MOV  CX,0C000H
MOV  AX,0000H  ; Load 1st data byte in the memory
MOV  SI,AX 
MOV  AL,55H
INT  0B0H
MOV  AX,0002H  ; Load 2nd data byte in the memory.
MOV  SI,AX
MOV  AL,0AAH
INT  0B0H

MOV  AL,00H
MOV  DX,01F0H
OUT  DX,AL	; Out the Control Word to reset F/L FF.
MOV  AL,01H
MOV  DX,01EAH
OUT  DX,AL	; Out the required terminal count LSB to 
		; ch2
MOV  AL,80H
OUT  DX,AL	; Out the MSB of terminal count to ch2
		; DMA Read Mode is also initialised.
MOV  AL,00H
MOV  DX,01E8H
OUT  DX,AL	; Out the DMA starting address LSB for 
		; ch2.
MOV  AL,0B0H
OUT  DX,AL	; Out the DMA starting address MSB for 
		; ch2
MOV  AL,01H
MOV  DX,01EEH
OUT  DX,AL	; Out the terminal count LSB for ch3.
MOV  AL,80H	
OUT  DX,AL	; Out the terminal count MSB for ch3.
		; DMA Read Mode is also initialized.
MOV  AL,00H
MOV  DX,01ECH
OUT  DX,AL	; Out the DMA starting address LSB for 
		; ch3.
MOV  AL,0B0H	
OUT  DX,AL	; Out the DMA starting address MSB for 
		; ch3.
MOV  AL,84H
MOV  DX,01F0H
OUT  DX,AL	; Out the Control Word to enable ch2 and 
		;  set Auto Load Mode also.
INT 0A5H	; Return to Command Mode.

X86P57L1  ENDS
     END  STRT


