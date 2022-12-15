
;LIST  :  2 (B)
			PAGE,80
			TITLE--USING 8251 PERIWARE.

;****Following listing is w.r.t. battery backed ram at 14FA:0100h but this 
;    programme can work in scratch pad ram located at 00000h. You can 
;    Enter the same from 0110:0100 and execute.

;This programme demonstrates 8251 Periware in its Synchronous Mode of 
;operation. It uses External SYNC Detection for the operation of receiver.


X86P512B  SEGMENT

	ASSUME CS:X86P512B, DS:X86P512B ,ES:X86P512B
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

INT  0ACH	; Set cursor to left position. 
              	; Clear screen
MOV  AL,00H	; Dummy Code
MOV  DX,01E2H
OUT  DX,AL
INT  0ACH	; Clear screen. Give delay
OUT  DX,AL	; Dummy Code
INT  0ACH	
OUT  DX,AL	; Dummy Code
INT  0ACH
MOV  AL,40H
OUT  DX,AL	; Reset code
INT  0ACH
MOV  AL,0CCH	; Mode word, Character 
		; Length=8 Bits
OUT  DX,AL	; External SYNC detect, no. of 
		; SYNC Char = 1
INT  0ACH
MOV  AL, 0AAH	; SYNC Character
OUT  DX,AL
MOV  AL,95H	; Command word, RxEnable=1, 
		; TxEnable=1, Error
OUT  DX,AL	; Reset=1.
LOOP8:	
MOV  DX,01E2H
IN   AL,DX	; Check for transmitter ready.
AND  AL,01H	; If no then remain in loop and 
                ; wait.
CMP  AL,01H
JNZ  LOOP8
		; Remove programme counter 
                ; form stack.
INT  0ACH 	; Set cursor to left
MOV  BX,OFFSET MSGBY ; Pointer for look up table
MOV  AL, 02H
MOV  AH,10H
INT  0B9H	; Routine to receive number	
MOV  AL,DL
MOV  DX,01E0H
OUT  DX,AL	; Send data to Transmitter Buffer

;Make SYNDET input pin high by connecting it to Vcc.

LOOP9:	
INT  0ACH
MOV  DX,01E2H
IN   AL,DX	; Check for receiver ready
AND  AL,02H	; If no then remain in loop and 
                ; wait.
CMP  AL,02H
JNZ  LOOP9

INT  0ACH
MOV  DX,01E0H
IN   AL,DX	; Receive the data from receiver 
                ; output.
CALL DSPLY	; Displays the byte on seven 
                ; segments.
JMP  LOOP9

INT  0A4H	; Go to Command Mode.

DSPLY PROC NEAR

PUSH CX 
INT  0ACH
MOV  ES:[1000H],AL ; Store received data in memory
MOV  BX,OFFSET MSGDA	; Pointer for look up table.
INT  0AFH          ; Calls display routine
MOV  DL,20H	   ;Out ascii space charater
MOV  AH,02H
INT  0A2H
MOV  DL,20H	   ;Out ascii space char.
MOV  AH,02H
INT  0A2H
MOV  AL,02H	   ; Number of digits to be displayed
		   ; in data segment.
MOV  DL,ES:[1000H] ; Load the data back to the ACC
INT  0AEH	   ; NMOUT routine is called
MOV  CX,0FFFFH	   ; Wait to stabilise the display
INT  0AAH          ; Calls delay routine
POP  CX
RET

DSPLY ENDP

MSGDA:  DB "DATA", 03H
MSGBY:  DB "BYTE", 03H

X86P512B  ENDS
     END  STRT
