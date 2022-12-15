
;LIST  :  1 (B)
                   PAGE,80
       TITLE--USING 8251 PERIWARE.

;****Following listing is w.r.t. battery backed ram at 14A8:0100h but this 
;    programme can work in scratch pad ram located at 00000h. You can  
;    Enter the same from 0110:0100 and execute.

;This programme demonstrates 8251 Periware in Asynchronous Mode of operation 
;using Interrupt IR0.


X86P511B  SEGMENT

	ASSUME CS:X86P511B, DS:X86P511B ,ES:X86P511B
	ORG 100H 		;Com format is recommended.
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

MOV  CX,AX       ;SEG ADDR OF ISR FOR IR0
MOV  SI,OFFSET ISR ;OFFSET ADDR  
MOV  AL,90H      ;INIT OF 0000:0240H-44H BYTES SO 
		 ;ON INTERRUPT IR0 "INT 90,91..
		 ;ARE EXECUTED.
INT  0BEH        ; 
MOV  AL,1BH      ;EDGE,SINGLE
		 ;ICW1 A1=0
MOV  DX,9400H    ; 
OUT  DX,AL       ; 
MOV  AL,90H	 ;ISR OF IR0 =INT 90H ETC
MOV  DX,9402H    ;A1=1	
OUT  DX,AL 	 ;ICW2	
MOV  AL,01H	 ;8086,NORMAL EOI,NON BUFERED,
		 ;NON SPECIAL,NEST
OUT  DX,AL	 ;ICW4,A1=1
MOV  AL,0FEH	 ;ENABLE IR0.
OUT  DX,AL 	 ;OCW1 

MOV  AL,00H	 ; Dummy code.
MOV  DX,01E2H
OUT  DX,AL
INT  0ACH	 ; Clear screen. Give delay.
OUT  DX,AL	 ; Dummy code
INT  0ACH	
OUT  DX,AL	 ; Dummy code
INT  0ACH
MOV  AL,40H
OUT  DX,AL  	; Reset code
INT  0ACH
MOV  AL,4DH
OUT  DX,AL  	; Mode word, Stop Bits=1, 
		; Character Length=8 Bits
INT  0ACH   	; Baud Rate Factor =1.
MOV  AL,27H
OUT  DX,AL  	; Command Word, 
		; RxEnable=1, TxEnable=1
		; DSR=1
LOOP4:
MOV  DX,01E2H
IN   AL,DX	; Check for transmitter ready
AND  AL,81H	; If no then remain in loop and 
		; wait.
CMP  AL,81H	
JNZ  LOOP4

INT  0ACH	; Set cursor to left

MOV  BX,OFFSET MSGBY ; Pointer for look up table
MOV  AL, 02H
MOV  AH,10H
INT  0B9H	; Routine to receive number	

MOV  AL,DL
MOV  DX,01E0H
OUT  DX,AL	; Send data to Transmitter Buffer

HERE:
STI
JMP  HERE

ISR:           	;ISR for receiving data byte

CLI		; Disable Interrupt
MOV  DX,01E0H
IN   AL,DX	; Receive the data from receiver 
		; output.
CALL DSPLY	; Displays the byte on seven 
		; segments.
INT 0A4H	;Resister saving interrupt.
		; Go to Command Mode.
IRET	

DSPLY PROC NEAR
INT  0ACH
MOV  ES:[1000H],AL   ; Store received data in memory
MOV  BX,OFFSET MSGDA ; Pointer for look up table.
INT  0AFH	; Calls display routine
MOV  DL,20H	;Out ascii space charater
MOV  AH,02H
INT  0A2H
MOV  DL,20H	;Out ascii space char.
MOV  AH,02H
INT  0A2H
MOV  CX,0FFFFH	; Wait to stabilise the display
INT  0AAH	; Calls delay routine
MOV  AL,02H	; Number of digits to be displayed
		; in data segment.
MOV  DL,ES:[1000H] ; Load the data back to the ACC
INT  0AEH	; NMOUT routine is called
RET

DSPLY ENDP

MSGDA:  DB "DATA", 03H
MSGBY:  DB "BYTE", 03H

X86P511B  ENDS
END  STRT

