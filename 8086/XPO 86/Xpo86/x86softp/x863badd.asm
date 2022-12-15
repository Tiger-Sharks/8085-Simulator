	PAGE 80
	TITLE--	MULTIBYTE ADDITION WITH THREE VARIALES

;*****MULTY BYTE ADDITION WITH 3 VARIABLES-THIS EXAMPLE SHOWS THE 
;     ADDITION OF THREE VARIABLES.EACH IS A VERY LONG INTEGER STORED IN
;     8 BYTES AT 00F0:0103 AND 00F0:010B AND 00F0:0113 IN SCRATCH PAD 
;     RAM =0000:1003,100B,1013[PL.ENTER CONTENTS BY HAND.],CONTENTS OF
;     FIRST ARE ADDED TO SECOND VARIABLE THEN STORED INTO THIRD VARIABL

X863BADD 	SEGMENT
ASSUME CS:X863BADD, DS:X863BADD ,ES:X863BADD 

ORG 100H	          ;Com format 
                          ;is recommended.
STRT:	JMP SKIP_DATA   ;skip look up/ 
			    ;data bases if any
;On kit you need to do init for SP[to 
;separate stack of your program from
;monitors], DS as shown below. SS,ES are 
;set to 0000 at power on by monitor. You 
;can of course change it by adding a few 
;more moves. But while working on pc you 
;can't touch segment registers since 
;they are set by dos loader, so manage 
;these instructions as shown in comment 
;field.  

SKIP_DATA:
MOV	AX,11FFH     ;INIT OF SP FOR KIT 
MOV	SP,AX        ;MOV AX,AX   ON PC 
PUSH	CS           ;INIT FOR DS                    
POP	DS           ;                                
MOV	AX,00F0H     ;INIT FOR ES 
MOV	ES,AX        ;INTO SCPD AT 0000:1000
MOV	CX,0008H     ;NUMBER OF BYTES IN EACH 
		     ;VARIABL 
MOV	SI,0000H     ;INDEX INITIALIZED TO 0          
CLC	                                            
LUP:MOV	AL,ES:[SI+0103H];GET V1                         
	             ;ADD V2 ALONG WITH  PRV CY      
ADC	AL,ES:[SI+010BH]   
MOV	ES:[SI+0113H],AL;STORE THE RESULT BYTE           
INC	SI          ;BUMP INDEX POINTER               
LOOP	LUP         ;DECREMENT CX REPEAT TILL 0 
	            ;REPEATED 8 TIMES.
INT	0A5H        ;RETURN TO SAVING REGS

X863BADD	ENDS 
    END 	STRT
                         

                                            
