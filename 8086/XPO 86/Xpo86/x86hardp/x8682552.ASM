       PAGE 80
       TITLE-- USING 8255



X868255   	SEGMENT

          	ASSUME CS:X868255, DS:X868255 ,ES:X868255
          	ORG 100H     	;COM FORMAT IS RECOMMENDED.

STRT: 	JMP 	SKIP_DATA 	;SKIP LOOK UP/ DATA BASES IF ANY

;ON KIT YOU NEED TO DO INIT FOR SP [TO SEPARATE STACK OF YOUR PROGRAME FROM
;MONITORS],DS AS SHOWN BELOW.SS,ES ARE SET TO 0000 AT POWER ON BY MONITOR.
;YOU CAN OFCOURSE CHANGE IT BY ADDING A FEW MORE MOVE`S.
;BUT WHILE WORKING ON PC YOU CAN`T TOUCH SEGMENT REGISTERS SINCE THEY ARE
;SET BY DOS LOADER,SO MANAGE THESE INSTRUCTIONS AS SHOWN IN COMMENT FIELD.  

SKIP_DATA:
	MOV     AX,10FFH  	; Init of SP for Kit
        MOV     AX,AX     	; On PC
        PUSH    CS        	; Init for DS
        POP     DS  
                            	; Load Kit Ints (A0-BF) 
        NOP               	; In PC using
        NOP               	; CALL in place of 3 NOP`S
        NOP               	;
				
        MOV     DX,8006H  	; Control Port of 8255L
        MOV     AX,8080H  	; Control word '80'H
        OUT     DX,AL		;
        MOV     DX,8807H  	; Control of 8255U
        OUT     DX,AL		;
AGAIN:  MOV     AX,5555H  	; Data '55'H 
        MOV     DX,8000H  	; Port addr of 8255L
        OUT     DX,AL		;
        MOV     DX,8801H  	; Port addr of 8255U
        OUT     DX,AL		;
        MOV     CX,7000H	;
        INT     0AAH      	; CALL Delay
        MOV     AX,0AAAAH 	; Data 'AA'
        MOV     DX,8000H	;
        OUT     DX,AL		;
        MOV     DX,8801H	;
        OUT     DX,AL		;
        INT     0AAH		; Delay
        JMP     AGAIN		; Continue

X868255   	ENDS
	END   	STRT

