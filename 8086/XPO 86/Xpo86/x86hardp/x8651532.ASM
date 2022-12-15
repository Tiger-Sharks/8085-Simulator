       PAGE,80
       TITLE-- USING 8253 & 8251


X865153   	SEGMENT

          	ASSUME CS:X865153, DS:X865153 ,ES:X865153
          	ORG 100H     	;COM FORMAT IS RECOMMENDED.

STRT: 	JMP 	SKIP_DATA      	;SKIP LOOK UP/ DATA BASES IF ANY

;ON KIT YOU NEED TO DO INIT FOR SP [TO SEPARATE STACK OF YOUR PROGRAME FROM
;MONITORS],DS AS SHOWN BELOW.SS,ES ARE SET TO 0000 AT POWER ON BY MONITOR.
;YOU CAN OFCOURSE CHANGE IT BY ADDING A FEW MORE MOVE`S.
;BUT WHILE WORKING ON PC YOU CAN`T TOUCH SEGMENT REGISTERS SINCE THEY ARE
;SET BY DOS LOADER,SO MANAGE THESE INSTRUCTIONS AS SHOWN IN COMMENT FIELD.  

MSG: 	DB "ANSHUMAN        SERIAL   LINK  ",03H
		
SKIP_DATA:
	MOV     AX,10FFH 	;Init of SP for kit
        MOV     AX,AX    	;On PC
        PUSH    CS       	;Init for DS
        POP     DS  
                     ;Load Kit INTS (A0-BF) 
        NOP          ;In PC using
        NOP          ;Place CALL in Place of 3 NOP`S
        NOP          ;

        MOV     CX,052DH 	;Init of 8253 chanel#0
                           	;Set Baud rate to 110
                           	;052DH= Count for 8253
        MOV     DX,8C07H     	;
        MOV     AL,36H		;Init Counter 0,
        OUT     DX,AL		;mode 3.
        MOV     DX,8C01H	;
        MOV     AL,CL		;set Cntr 0 LSB
        OUT     DX,AL		;
        MOV     AL,CH		;set Cntr 0 MSB
        OUT     DX,AL		;
        MOV     DX,9002H 	;Init of 8251
                           	;Command Register
        MOV     AL,00H   	;Send 0`S to Ensure that
                           	;8251 is in Command.
        OUT     DX,AL		;
        MOV     CX,000FH	;
        INT     0AAH     	;Delay Required While
                           	;Doing Init of 8251
        OUT     DX,AL		;
        INT     0AAH		;
        OUT     DX,AL		;
        INT     0AAH		;
        MOV     AL,40H		;
        OUT     DX,AL		;
        INT     0AAH		;
        MOV     AL,0CEH  	;Mode Word-2 Stop Bit,
                           	;No Parity,No of Bits 8
		               	;Baud rate factor *16.
        OUT     DX,AL		;
        INT     0AAH		;
        MOV     AL,37H   	;Command Word DTR=0=RTS,
                           	;T R Enable,Normal
        OUT     DX,AL		;
        INT     0ACH     	;Start Sending And
                           	;Receiving Alternately
	MOV     BX,OFFSET MSG 	;Message Pointer

NEXT:   MOV     DL,[BX]		;	
        CMP     DL,03H   	;End of Transmition
        JZ      TEND		;
        MOV     AH,02H		;
        INT     0A9H     	;Send TO T+D of 8251
        INC     BX		;
        MOV     AH,08H		;
        INT     0A8H     	;Read The CHR From R+D
                           	;It is Assumed that PIN 2 & 3
                           	;of 25 D are shorted externaly.
        MOV     AH,02H		;
        INT     0A2H     	;Display at present consol
        JMP     NEXT		;
TEND:   INT     0A4H     	;Return to Command mode.
			

X865153  	ENDS
   	END	STRT
