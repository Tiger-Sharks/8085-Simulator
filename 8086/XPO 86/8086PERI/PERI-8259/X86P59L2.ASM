
;LIST - 2
                   PAGE,80
       TITLE--USING 8259 PERIWARE IN MASTER MASTER MODE.

;****Following listing is w.r.t. battery backed ram at 1250:0100h but this 
;    programme can work in scratch pad ram located at 00000h. please 
;    Enter the same from 0110:0100 and execute.

;NOTE : In this program, when ISRM4 Interrupt is activated, this message 
;displayed will be of routine ISRS7 since IR4 of Master is connected to 
;INTR of Slave. On default, the Slave 8259 gives IR7 the highest priority.

;Here two IC 8259 devices are used in Master-Slave combination. The INTR of 
;Slave is routed through IR4 of Master 8259 to the microprocessor. Thus a 15 
;level Interrupt is created. In the main program, "XPO" is displayed. In the 
;Interrupt service routine,"INT M/S  0/1/2/3/4/5/6/7"  is displayed depending 
;upon the device and the Interrupt number.


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
NOP			;In PC using
NOP			;CALL in place
NOP			;of 3 NOP`S

MOV  CX,AX		;Seg Addr Of ISR for IR0
MOV  SI,OFFSET ISRM0 	;Offset Addr IR0 Master. 
MOV  AL,90H		;Init Of 0000:0240H-44H Bytes So 
			;On Int IR0 "INT 90,91..
INT  0BEH		;are Executed.

MOV  SI,OFFSET ISRM1 	;Offset Addr for Int IR1  
MOV  AL,91H		;of master. 
INT  0BEH		

MOV  SI,OFFSET ISRM2 	;Offset Addr for Int IR2  
MOV  AL,92H		;of master. 
INT  0BEH		

MOV  SI,OFFSET ISRM3 	;Offset Addr for Int IR3  
MOV  AL,93H		;of master. 
INT  0BEH		

MOV  SI,OFFSET ISRM4 	;Offset Addr for Int IR4  
MOV  AL,94H		;of master. 
INT  0BEH		

MOV  SI,OFFSET ISRM5 	;Offset Addr for Int IR5  
MOV  AL,95H		;of master. 
INT  0BEH		

MOV  SI,OFFSET ISRM6 	;Offset Addr for Int IR6  
MOV  AL,96H		;of master. 
INT  0BEH		

MOV  SI,OFFSET ISRM7 	;Offset Addr for Int IR7  
MOV  AL,97H		;of master. 
INT  0BEH		

MOV  SI,OFFSET ISRS0 	;Offset Addr for Int IR0  
MOV  AL,98H		;of slave. 
INT  0BEH		

MOV  SI,OFFSET ISRS1 	;Offset Addr for Int IR1  
MOV  AL,99H		;of slave. 
INT  0BEH		

MOV  SI,OFFSET ISRS2 	;Offset Addr for Int IR2  
MOV  AL,9AH		;of slave. 
INT  0BEH		

MOV  SI,OFFSET ISRS3 	;Offset Addr for Int IR3  
MOV  AL,9BH		;of slave. 
INT  0BEH		

MOV  SI,OFFSET ISRS4 	;Offset Addr for Int IR4  
MOV  AL,9CH		;of slave. 
INT  0BEH		

MOV  SI,OFFSET ISRS5 	;Offset Addr for Int IR5  
MOV  AL,9DH		;of slave. 
INT  0BEH		

MOV  SI,OFFSET ISRS6 	;Offset Addr for Int IR6  
MOV  AL,9EH		;of slave. 
INT  0BEH		

MOV  SI,OFFSET ISRS7 	;Offset Addr for Int IR7  
MOV  AL,9FH		;of slave. 
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
		;Master and Slave.


MOV  DX,01A2H
OUT  DX,AL

STI		;Enable Interrupt.

UP1:		
MOV  AX,00FFH	;DELAY COUNT
UP2:   
MOV  CX,00FFH	;DELAY COUNT
INT  0AAH	;DELAY
DEC  AX		;
JNZ  UP2	;
INT  0ACH	;CLEAR DISPLAY
MOV  BX,OFFSET MSG01 ;POINTER TO "XPO"
INT  0AFH	;OUTMSG UTILITY 
MOV  AH,0BH	;TEST FOR KEY PRESS
INT  0A1H	;LOGICAL I/O
CMP  AL,0FFH
JZ   RDESC		
JMP  DN1		
RDESC:
MOV  AH,08H	;READ KEY
INT  0A1H	;LOGICAL I/O
CMP  AL,1BH
JZ   EXIT
DN1:
STI
JMP  UP1
EXIT: 
INT 0A3H       	;CMD MODE.
NOP	                                   
NOP	                                   
NOP	                                   
NOP
NOP

ISR:  
INT 0ACH		; Clear to new line.
MOV BX, OFFSET MSG02 	; Pointer to message -"INT"
INT 0AFH		; Display the message.
MOV  DL,20H		; Display  space.
MOV  AH,02H		; 02H for logical write.
INT  0A2H		; Logical write.
MOV  DL,CH		; Load the code for Master or Slave.
INT  0A2H		; Logical write.
MOV  DL,20H		; Display  space.
INT  0A2H		; Logical write.
MOV  DL,CL		; Load the code for INTR number.
INT  0A2H		; Logical write.
MOV  AL,20H		; OCW2-non specific EOI.
MOV  DX,01A0H
OUT  DX,AL 	
MOV  AL,20H
MOV  DX,01E0H
OUT  DX,AL
IRET

NOP
NOP
NOP

ISRM0: MOV  CL,4DH 	; Load the code to display Master.
MOV  CH,30H		; Code to display "0"
JMP  ISR		; Jump  to display MSG02.
NOP

ISRM1: MOV  CL,4DH	; Code to display Master.
MOV  CH,31H		; Code to display "1".
JMP  ISR		; Jump to display MSG02.
NOP

ISRM2: MOV  CL,4DH	; Code to display Master.
MOV  CH,32H		; Code to display "2".
JMP  ISR		; Jump to display MSG02.
NOP

ISRM3: MOV  CL,4DH	; Code to display Master.
MOV  CH,33H		; Code to display "3".
JMP  ISR		; Jump to display MSG02.
NOP

ISRM4: MOV  CL,4DH	; Code to display Master.
MOV  CH,34H		; Code to display "4".
JMP  ISR		; Jump to display MSG02.
NOP

ISRM5: MOV  CL,4DH	; Code to display Master.
MOV  CH,35H		; Code to display "5".
JMP  ISR		; Jump to display MSG02.
NOP

ISRM6: MOV  CL,4DH	; Code to display Master.
MOV  CH,36H		; Code to display "6"
JMP  ISR	   	; Jump  to display MSG02.
NOP

ISRM7: MOV  CL,4DH	; Code to display Master.
MOV  CH,37H		; Code to display "7".
JMP  ISR		; Jump to display MSG02.
NOP

ISRS0: MOV  CL,53H	; Code to display Slave.
MOV  CH,30H		; Code to display "0".
JMP  ISR		; Jump to display MSG02.
NOP

ISRS1: MOV  CL,53H	; Code to display Slave.
MOV  CH,31H		; Code to display "1".
JMP  ISR		; Jump to display MSG02.
NOP

ISRS2: MOV  CL,53H	; Code to display Slave.
MOV  CH,32H		; Code to display "2".
JMP  ISR		; Jump to display MSG02.
NOP

ISRS3: MOV  CL,53H	; Code to display Slave.
MOV  CH,33H		; Code to display "3".
JMP  ISR		; Jump to display MSG02.
NOP

ISRS4: MOV  CL,53H	; Code to display Slave.
MOV  CH,34H		; Code to display "4"
JMP  ISR		; Jump  to display MSG02.
NOP

ISRS5: MOV  CL,53H	; Code to display Slave.
MOV  CH,35H		; Code to display "5".
JMP  ISR		; Jump to display MSG02.
NOP

ISRS6: MOV  CL,53H	; Code to display Slave.
MOV  CH,36H		; Code to display "6".
JMP  ISR		; Jump to display MSG02.
NOP

ISRS7: MOV  CL,53H	; Code to display Slave.
MOV  CH,37H		; Code to display "7".
JMP  ISR		; Jump to display MSG02.
NOP

MSG01: DB  "XPO",03H 	; Database to display "XPO".
			; End of text.

MSG02: DB  "INT",03H	; Database to display "INT"
			; End of text.


X86P59L2  ENDS
     END  STRT



