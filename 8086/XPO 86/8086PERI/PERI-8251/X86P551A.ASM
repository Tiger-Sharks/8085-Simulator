;LIST 1A
;In this program 8255 is operated in Mode 0, Simple I/O Mode & PortA is ;configured as input port.
;A byte is read from port A and displayed

PAGE 80
TITLE -- USING 8255 PERIWARE.
X86P55A1  SEGMENT

	ASSUME CS:X86P55A1, DS:X86P55A1 ,ES:X86P55A1
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
	
	MOV AX,0000H	;Load ES as 0000H
	MOV ES,AX 
	MOV  AL,90H		; Control Word for Mode 0, A-input
	MOV DX,01E6H	; CSW Address in DX
	OUT DX,AL		; Write csw (OUT 90 to 01E6H)
	MOV DX,01E0H	; Port A Address in DX
	IN  AL,DX		; Read port A (IN from 01E0H)
                 
;Note: Following ISR will be used by Mode 0,1,2-input.

ISR055:
        MOV ES:[1000H],AL       ; Store received data in memory.
        INT 0ACH                ;Clear display

        MOV BX,OFFSET MSG       ;LXI  H,00H  43H, Pointer for look up table.
        INT 0AFH                ;CALL OUTMSG, Calls display routine.
        MOV BL,01H              ; Set counter for delay.(C)

LOOP:   MOV CX,00FFH   ;LXI  D,FFH  FFH, Wait to stabilise the display.
        INT 0AAH                ;CALL DELAY, Calls delay routine.
	
        MOV AL,ES:[1000H];Retrive port A received data for display purpose.
        MOV DL,AL
	MOV AL,02H		; Number of digits to be
				; displayed in data segment.
	INT 0AEH		;CALL NMOUT, NMOUT routine is called.
        DEC BL
        JNZ  LOOP
	INT 0A4H		;GOTO Command Mode.

MSG:    DB "POTA  ",03H        ; End of text.

	X86P55A1  ENDS
     	END  STRT


