;LIST  :  1 (A)

			PAGE,80
			TITLE--USING 8251 PERIWARE.

;****Following listing is w.r.t. battery backed ram at 1404:0100h but this 
;    programme can work in scratch pad ram located at 00000h. You can 
;    Enter the same from 0110:0100 and execute.

;This programme demonstrates 8251 Periware in Asynchronous Mode of operation 
;using polling.

X86P511A  SEGMENT

	ASSUME CS:X86P511A, DS:X86P511A ,ES:X86P511A
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
MOV  AX,10FFH   ;Initof SP for Kit
MOV  SP,AX      ;On PC
PUSH CS	   	;Init for DS
POP  AX	   	;Load kit INTS 
MOV  DS,AX	;(A0-BF) 
NOP		;In PC using
NOP		;CALL in place
NOP		;of 3 NOP`S

MOV  AX,0000H
MOV  ES,AX
MOV  AL,00H	; Dummy code.
MOV  DX,01E2H
OUT  DX,AL
INT  0ACH	; Clear screen. Give delay.
OUT  DX,AL	; Dummy code.
INT  0ACH
OUT  DX,AL	; Dummy code.
INT  0ACH
MOV  AL,40H
OUT  DX,AL	; Reset code
INT  0ACH
MOV  AL,4DH
OUT  DX,AL	; Mode word, Stop Bits=1, 
		; Character Length=8 Bits
INT  0ACH	; Baud Rate Factor = 1
MOV  AL,27H
OUT  DX,AL	; Command Word, Rx 
		; Enable=1,  TxEnable=1 
		; DSR=1
LOOP1:
IN   AL,DX	; Check for transmitter ready.
AND  AL,81H	; If no then remain in loop and 
		; wait.
CMP  AL,81H	
JNZ  LOOP1
POP  BX		; Remove programme counter 
		; from stack.
INT  0ACH	; Set cursor to left.

MOV  BX,OFFSET MSGBY ; Pointer for look up table
MOV  AL, 02H
MOV  AH,10H
INT  0B9H	; Routine to receive number	
MOV  AL,DL
MOV  DX,01E0H
OUT  DX,AL	; Send data to Transmitter Buffer
LOOP2:
MOV  DX,01E2H
IN   AL,DX	; Check for receiver ready.
AND  AL,02H	; If no then remain in loop and 
		; wait.		
CMP  AL,02H	
JNZ  LOOP2
MOV  DX,01E0H		
IN   AL,DX	; Receive the data from
           	; receiver output.
CALL DSPLY	; Displays the byte on seven 
		; segments
INT  0A4H   	; Go to Command Mode.
		; without disturbing display.
DSPLY PROC NEAR
INT  0ACH
MOV  ES:[1000H],AL ; Store received data in memory
MOV  BX,OFFSET MSGDA	; Pointer for look up table.
INT  0AFH          ; Calls display routine
MOV  DL,20H	;Out ascii space charater
MOV  AH,02H
INT  0A2H
MOV  DL,20H	;Out ascii space char.
MOV  AH,02H
INT  0A2H
LOOP3:	
MOV  CX,0FFFFH	   ; Wait to stabilise the display
INT  0AAH          ; Calls delay routine
		
MOV  AL,02H	   ; Number of digits to be displayed
		   ; in data segment.
MOV  DL,ES:[1000H] ; Load the data back to the ACC
INT  0AEH	   ; NMOUT routine is called
RET

DSPLY ENDP


MSGDA:  DB "DATA", 03H
MSGBY:  DB "BYTE", 03H

X86P511A  ENDS
     END  STRT

