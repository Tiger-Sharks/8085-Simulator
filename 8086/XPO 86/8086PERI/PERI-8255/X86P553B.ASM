;LIST 3 (B)

;This program configures the 8255 in Mode 2-Bidirectional STROBed I/O.
;This program demonstrates STROBed output of port A in Mode 2 PC3.
;Here acts as  INTR, so it has to be connected to RST 5.5 with patch cord.
;PC6 here acts as STB and PC7 as OBF. This program asks for byte to be entered 
;through keyboard which then is written on port A.
;Program remains in loop. to come out of it, press Esc or Reset.


PAGE,80
TITLE--USING 8255 PERIWARE.

X86P552B  SEGMENT

	ASSUME CS:X86P552B, DS:X86P552B ,ES:X86P552B
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

	MOV CX,AX		;Copy code seg.
	MOV SI,OFFSET ISR055	;ISR addr to be store in SCPD NMI loc.
	MOV AL,90H		;INT Type 90-97 Through 8259 PIC
	INT 0BEH		;Store in interupt area 

	MOV AL,1BH		;CSW FOR Level INT,interval of 4,single 59
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

      MOV AL,0C0H            	 ; Control Word for Mode2.
	MOV DX,01E6H	;CSW address
	OUT DX,AL
	MOV AL,0DH		; Enable INTR.
	OUT DX,AL
	MOV DX,01E0H

      JMP  ISR055	; Go to read byte from keyboard
	; and output to port B.
ISR055:	POP  BX	; Remove prog. counter from stack.
	INT 0ACH		;CRLF, Set cursor to left.
	MOV BX,OFFSET MSG	;Pointer for look up table.
	MOV AL,02H
	MOV AH,10H
	INT 0B9H		;RCVNO, Routine to receive number.
      MOV AL,DL
	MOV DX,01E0H
	OUT DX,AL		; Out data to port A.
SELF:	STI			;Enable Interrupt.
	JMP SELF		; SELF Jump.
				;ORG  43H  0AH
MSG:  DB  "BYTE    ",03H      ; Look up table ASCII data for "BYTE"
                                ; End of text.

	X86P552B  ENDS
     	END  STRT


