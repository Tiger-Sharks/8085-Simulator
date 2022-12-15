;LIST 3 (A)

;This program configures the 8255 in mode 2-Bidirectional STROBed I/O.
;This program demonstrates STROBed input of port A in Mode 2.
;PC3 here acts as INTR, so it has to be connected to RST 5.5 with patch cord.    
;PC4 here acts as STB and PC5 as IBF.
;Byte entered from port A is displayed on seven segments.
;Program returns to Command Mode.

PAGE,80
TITLE--USING 8255 PERIWARE.

X86P553A  SEGMENT

	ASSUME CS:X86P553A, DS:X86P553A ,ES:X86P553A
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

        MOV CX,AX               ;code seg copy

        MOV SI,OFFSET ISR       ;ISR addr to be store in SCPD NMI loc.
	MOV AL,90H		;INT Type 90-97 Through 8259 PIC
	INT 0BEH		;Store in interupt area 

        MOV AL,1BH              ;CSW FOR Edge INT,interval of 4,single 59
	MOV DX,9400H	;8259 ICW1 Addr
	OUT DX,AL
	MOV AL,90H		;ISR of IR0=INT 90
	MOV DX,9402H	;8259 ICW2 Addr
	OUT DX,AL
	MOV AL,01H		;8086,Normal,EOI,Non buffered,Non special,Nest
	OUT DX,AL		;8259 ICW4
	MOV AL,0FEH		;Enable IR0
	OUT DX,AL		;OCW1

        MOV AX,0000H    ;Set ES to 0000H
        MOV ES,AX
 
        MOV AL,0C0H             ; Control Word for Mode2.
	MOV DX,01E6H	;CSW address
	OUT DX,AL
	MOV AL,09H		; Enable INTR/PC4.
	OUT DX,AL
	MOV DX,01E0H
	IN  AL,DX		; Read port A.
HERE:   STI                     ; Enable Interrupt.
        NOP
        JMP HERE
ISR:
ISR055:
        CLI
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
        POP CX                  ;Remove address from stack
        POP CX
        INT 0A4H                ;GOTO Command Mode.

MSG:    DB "POTA  ",03H        ; End of text.

	X86P553A  ENDS
     	END  STRT


