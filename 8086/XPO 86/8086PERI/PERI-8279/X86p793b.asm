

;LIST  5 (B)

TITLE--USING 8279 PERIWARE.

;****Following listing is w.r.t. battery backed ram at 1377:0100h but this 
;    programme can work in scratch pad ram located at 00000h. You can 
;    Enter the same from 0110:0100 and execute.


;16-8 bit characters are sequentially written in the last  
;16th display RAM location and are displayed sequentially.


X86P795B  SEGMENT

	ASSUME CS:X86P795B, DS:X86P795B ,ES:X86P795B
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
	MOV  AL,18H
	MOV  DX,01E2H ; C/W for 16-8 bit 
	OUT  DX,AL	 ; character display.
	MOV  AL,0DFH	 ; Issue clear command.
	OUT  DX,AL	
	MOV  AL,8FH	 ; Command to write 15th 
	OUT  DX,AL	 ; display RAM location.
	MOV  CL,0FH	 ; Set counter for look up table.
	CALL DISPLAY
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

X86P795B  ENDS
     END  STRT

