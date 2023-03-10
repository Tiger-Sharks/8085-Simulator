	
	PAGE 80
	TITLE-- DECIMAL COUNTER

;*****FOLLOWING LISTING IS W.R.T. BATTERY BACKED RAM AT 10000H BUT THIS
;     PROGRAMME CAN WORK IN SCRATCH PAD RAM LOCATED AT 00000H .PL. ENTER
;     THE SAME FROM 012B:0100 AND EXECUTE.
;
;***MULTY BYTE ADDITION-THIS EXAMPLE SHOWS THE ADDITION OF TWO VARIABLES.
;   EACH IS A VERY LONG INTEGER STORED IN 8 BYTES AT 0100:0000 AND
;   0100:0010 IN SCRATCH PAD RAM [PL.ENTER CONTENTS BY HAND.],CONTENTS 
;   OF FIRST ARE ADDED TO SECOND VARIABLE.


X86MBADD   SEGMENT

          ASSUME CS:X86MBADD, DS:X86MBADD ,ES:X86MBADD
          ORG 100H                        ;COM FORMAT IS RECOMMENDED.

STRT:    JMP SKIP_DATA                   ;SKIP LOOK UP/ DATA BASES IF ANY

;ON KIT YOU NEED TO DO INIT FOR SP [TO SEPARATE STACK OF YOUR PROGRAME FROM
;MONITORS],DS AS SHOWN BELOW.SS,ES ARE SET TO 0000 AT POWER ON BY MONITOR.
;YOU CAN OFCOURSE CHANGE IT BY ADDING A FEW MORE MOVE`S.
;BUT WHILE WORKING ON PC YOU CAN`T TOUCH SEGMENT REGISTERS SINCE THEY ARE
;SET BY DOS LOADER,SO MANAGE THESE INSTRUCTIONS AS SHOWN IN COMMENT FIELD.  

SKIP_DATA:MOV     AX,10FFH  ;INIT OF SP FOR KIT
          MOV     AX,AX     ;MOV AX,AX   ON PC
          PUSH    CS        ;INIT FOR DS
          POP     DS  
                            ;LOAD KIT INTS (A0-BF) IN PC USING
          NOP               ;
          NOP               ;PLACE CALL IN PLACE OF 3 NOP`S
          NOP               ;

          MOV	AX,0100H                            
          MOV	ES,AX                              
          MOV	CX,0008H   ;NO OF BYTES IN EACH 
				     ;VARIABLE
          MOV	SI,0000H   ;OFFSET OF FIRST VARIABL
          MOV	DI,0010H   ;OFFSET OF SECOND
          CLC	           ;CLEAR CARRY FOR STARTER
NEXT:     MOV	AL,ES:[SI]   ;GET NEXT SOURCE BYTE
          ADC	ES:[DI],AL   ;ADD TO DESTINATION BYTE
          INC	SI                                 
          INC	DI                                 
          LOOP	NEXT       ;LOOP TILL CX=0        
          INT	0A5H       ;RETURN TO COMAND= AFTER
				     ;SAVING REGISTERS.   

X86MBADD  ENDS
    END   STRT

