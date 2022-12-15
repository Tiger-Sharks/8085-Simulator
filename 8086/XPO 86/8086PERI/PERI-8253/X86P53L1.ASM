;LIST 1
                   PAGE,80
       TITLE--USING 8253 PERIWARE.

;****Following listing is w.r.t. battery backed ram at 12A0:0100h but this 
;    programme can work in scratch pad ram located at 00000h. You can  
;    Enter the same from 0110:0100 and execute.


;This is a sample program to illustrate the 8253 in Mode 0. In this mode, 
;the output will be low initially after the Mode Set operation. After the 
;count is loaded, into the selected count register, the output will remain 
;low and the counter will count. When the terminal count is reached, the 
;output will go high and remain high until the new count is loaded. In the 
;Interrupt service routine of RST5.5, "XPO" is displayed.


X86P53L1  SEGMENT

	ASSUME CS:X86P53L1, DS:X86P53L1 ,ES:X86P53L1
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
MOV  AX,10FFH		;Initof SP for Kit
MOV  SP,AX		;On PC
PUSH CS		        ;Init for DS
POP  AX		        ;Load kit INTS 
MOV  DS,AX		;(A0-BF) 
NOP			;In PC using
NOP			;CALL in place
NOP			;of 3 NOP`S

MOV  CX,AX         ;SEG ADDR OF ISR FOR IR0
MOV  SI,OFFSET ISR ;OFFSET ADDR  
MOV  AL,90H	   ;INIT OF 0000:0240H-44H BYTES SO 
		   ;ON INTERRUPT IR0 "INT 90,91..
		   ;ARE EXECUTED.
INT  0BEH          ;                       
MOV  AL,1BH    	   ;EDGE,SINGLE	
		   ;ICW1 A1=0                         
MOV  DX,9400H      ;                      
OUT  DX,AL         ;                    
MOV  AL,90H	   ;ISR OF IR0 =INT 90H ETC
MOV  DX,9402H      ;A1=1	
OUT  DX,AL 	   ;ICW2	
MOV  AL,01H	   ;8086,NORMAL EOI,NON BUFERED,
		   ;NON SPECIAL,NEST
OUT  DX,AL	   ;ICW4,A1=1
MOV  AL,0FEH	   ;ENABLE IR0.
OUT  DX,AL 	   ;OCW1                             

MOV AL,10H	;Initialization-Counter 0,
MOV DX,01E6H	;Mode 0, Binary.
OUT DX,AL

MOV AL, 04H	;Count value to be loaded.
MOV DX,01E0H
OUT DX,AL

MOV DX,01E6H
IN  AL,DX    	;No operation-alongwith the next no op.
		;provides a clock pulse to load the
		;counter with the count value.
IN  AL,DX	; No operation.
MOV DX,01E0H
UP:
IN  AL,DX	; Reads present count.
CMP AL,00H	; Checks for the end of count.
JNZ UP
STI
WET: JMP WET


ISR:  
MOV BX,OFFSET DATA ;Pointer to message database.
INT 0ACH	;Clear Display.
INT 0AFH        ;Display message.
MOV CX,0FFFFH	;Delay count.
INT 0AAH	;Provides delay to stabilise display.
INT 0A5H        ;Resister saving interrupt.
IRET

DATA:	DB "XPO" ,03H ;XPO DATA.


X86P53L1  ENDS
     END  STRT


