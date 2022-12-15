;LIST 5 (A)

       TITLE--USING 8279 PERIWARE.

;****Following listing is w.r.t. battery backed ram at 1362:0100h but this 
;    programme can work in scratch pad ram located at 00000h. You can 
;    Enter the same from 0110:0100 and execute.

;In this experiment 8-8 bit characters from 0 to 7  are 
;sequentially written in a single display RAM  location.
;They are displayed sequentially.


X86P795A  SEGMENT

	ASSUME CS:X86P795A, DS:X86P795A ,ES:X86P795A
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

LOOP:
MOV  AL,00H	   ; C/W for 8-8 bit 
MOV  DX,01E2H  ; character display.
OUT  DX,AL		
MOV  AL,0DFH	   ; Issue clear command.
OUT  DX,AL	
MOV  AL,87H	   ; Command to write 8th 
OUT  DX,AL	   ; display RAM location.
MOV  CL,07H	   ; Set counter for look up 
		   ; table.
CALL DISPLAY   ; Call display routine.
JMP  LOOP	   ; Jump to start.

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

X86P795A  ENDS
     END  STRT


