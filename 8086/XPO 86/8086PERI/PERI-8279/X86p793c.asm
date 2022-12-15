
;LIST 5 (C)
			PAGE,80
			TITLE--USING 8279 PERIWARE.

;****Following listing is w.r.t. battery backed ram at 138C:0100h but this 
;    programme can work in scratch pad ram located at 00000h. You can 
;    Enter the same from 0110:0100 and execute.

;In the right entry mode the characters are displayed like the characters  in
;the calculator. First entry is on the rightmost display. When next character is
;entered first one is shifted to its left and the sequence continues. The 9th
;character is again  entered in the rightmost  display because this is 8 
;character  right entry mode.

X86P795C  SEGMENT

	ASSUME CS:X86P795C, DS:X86P795C ,ES:X86P795C
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

START:	
	MOV  AL,10H	  ; C/Wfor 8-8 bit 
	MOV  DX,01E2H ; character left entry.
	OUT  DX,AL    ; character left entry.
	MOV  AL,0DFH
	OUT  DX,AL	; Issue clear command.
	MOV  AL,90H ; Set Auto Increment 
	OUT  DX,AL	; mode to write
			; Display RAM.
	MOV  CL,07H	; Set counter for look up 
			; table.
	CALL DISPLAY ; Call display routine.
	JMP  START

DISPLAY PROC NEAR
	
MOV  BX,OFFSET DATA ; Set memory ptr. to look 
NEXT:		   ; up table starting address.
MOV  AL,[BX]   ; Move  data byte to 
		   ; ACC.
MOV  DX,01E0H
OUT  DX,AL	   ; Out first data byte to display.
INC  BX	   ; increment the look up 
		   ; table ptr.
DEC  CL 	   ; Decrement the counter.
JNS  NEXT
RET		   ; Return to main program

DISPLAY ENDP

DATA: DB  0C0H,0F9H,0A4H,0B0H,99H,92H,82H,0F8H,80H,90H
      DB  88H,83H,0C6H,0A1H,86H,8EH

X86P795C  ENDS
     END  STRT

