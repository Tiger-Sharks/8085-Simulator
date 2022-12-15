
;LIST 3

       TITLE--USING 8279 PERIWARE.

;****Following listing is w.r.t. battery backed ram at 133C:0100h but this 
;    programme can work in scratch pad ram located at 00000h. You can 
;    Enter the same from 0110:0100 and execute.

;How 8279 responds in Sensor Matrix Mode is illustrated here.  
;In this experiment we have used encoded Scan Sensor Matrix Mode. 
;In this mode the internal debounce logic is inhibited. On 
;detection of  any change in the Sensor status IRQ line goes high.
;Status of the Sensor  is directly inputted to the Sensor RAM. 
;Each row in the Sensor RAM corresponds to the row in the matrix
;being scanned.

X86P79L3  SEGMENT

        ASSUME CS:X86P79L3, DS:X86P79L3 ,ES:X86P79L3
	ORG 100H 	;Com format is recommended.
STRT:	JMP  SKIP_DATA 		;Skip lookup/
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

MOV  AL,04H     ;Control Word to set
MOV  DX,01E2H   ;encoded Scan Sensor
OUT  DX,AL      ;Matrix mode.
MOV  AL,45H     ;C/W to read 6th row of 
OUT  DX,AL      ;Sensor RAM.

READ:
MOV  DX,01E0H
IN   AL,DX      ;Read Sensor RAM.
OUT  DX,AL
JMP  READ       ;Back to check Sensor 
                ;value change.

X86P79L3  ENDS
     END  STRT

