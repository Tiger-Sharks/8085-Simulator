
;LIST - 2
                   PAGE,80
       TITLE--USING 8259 PERIWARE IN MASTER MASTER MODE.

;****Following listing is w.r.t. battery backed ram at 1268:0100h but this 
;    programme can work in scratch pad ram located at 00000h. please 
;    Enter the same from 0110:0100 and execute.

;FOLLOWING PROGRAM IS WRITTEN FOR IR0 OF SLAVE (IRS0) AND IR1 OF MASTER (IRM1)
;IN MAIN LOOP THIS PROGRAM DISPLAY COUNTER UP/DOWN DEPENDING 
;ON THE INTERRUT RECEIVED. WHEN IRM1 IS ACTIVATED IT START 
;DOWN COUNTING. WHEN IRS0 IS ACTIVATED IT START UP COUNTING.
;TO COME OUT OF THIS PROGRAM PRESS RESET.


X86P59L2  SEGMENT
	ASSUME CS:X86P59L2, DS:X86P59L2 ,ES:X86P59L2
	ORG 100H 	;Com format is recommended.
STRT:	JMP  SKIP_DATA 		;Skip lookup/
				;bases if any
;On kit you need to do init for SP [to separate stack of your 
;programme from monitors], DS as shown below. SS, ES are 
;set to 0000 at power on by monitor. You can of course change 
;it by adding a few more move's. but while working on PC you 
;can't touch segment registers since they are set by dos loader, 
;so manage these instructions as shown in comment field.

SKIP_DATA:
MOV   AX,10FFH		;Initof SP for Kit
MOV   SP,AX		;On PC
PUSH  CS		;Init for DS
POP   AX		;Load kit INTS 
MOV   DS,AX			;A0-BF) 
MOV  CX,AX		;Seg Addr Of ISR for IR0
MOV  SI,OFFSET ISRM1 	;Offset Addr for Int IR1  
MOV  AL,91H		;of master. 
INT  0BEH		
MOV  SI,OFFSET ISRS0 	;Offset Addr for Int IR0  
MOV  AL,98H		;of slave. 
INT  0BEH		
MOV  AL,11H
MOV  DX,01A0H		;ICW1-edge triggered, cascade,
OUT  DX,AL             	;interval of 8.
MOV  AL,90H	   	;ICW2-Int type
MOV  DX,01A2H
OUT  DX,AL
MOV  AL,10H	   	;ICW3-IR4 of Master has Slave input.
OUT  DX,AL
MOV  AL,01H		;ICW4-non-buffered, 8086 mode.
OUT  DX,AL
MOV  AL,11H	;ICW1 for Slave-edge triggered, Cascade
MOV  DX,01E0H	;interval of 8.
OUT  DX,AL
MOV  AL,98H	;ICW2 Int type .
MOV  DX,01E2H
OUT  DX,AL
MOV  AL,04H	;ICW3 for Slave.
OUT  DX,AL
MOV  AL,01H	;ICW4 for Slave.
OUT  DX,AL
MOV  AL,00H	;OCW1-Enable all Interrupt 
OUT  DX,AL	;pins for both
MOV  DX,01A2H ;Master and Slave.
OUT  DX,AL

MAIN:STI		;Enable Interrupt.
MOV CL,00H		
INT 0ACH 
UP1:CMP CH,"U"  
JZ SKIP1
DEC CL
JMP SKIP2
SKIP1:INC CL
SKIP2:INT 0ABH

PUSH CX
MOV CX,1500H
INT 0AAH
POP CX 
MOV AL,02H
MOV DL,CL
INT 0AEH 
STI 
JMP UP1
   
ISR:MOV AL,20H 
MOV DX,01A0H 
OUT DX,AL 
MOV AL,20H 
MOV DX,01E0H 
OUT DX,AL 
IRET ;MOV  DL,CH		
ISRM1:MOV CH,"D" 
MOV CL,0FFH 
JMP ISR				
ISRS0: MOV CH,"U" 
MOV CL,00H 
JMP ISR 
;NOP
X86P59L2  ENDS
     END  STRT



