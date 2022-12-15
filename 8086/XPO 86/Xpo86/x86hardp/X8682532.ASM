	PAGE,80
       	TITLE-- 8253 SOUND GENERATOR.




X868253   	SEGMENT

          	ASSUME CS:X868253, DS:X868253 ,ES:X868253
          	ORG 100H 	;COM FORMAT IS RECOMMENDED.

STRT: 	JMP 	SKIP_DATA   	;SKIP LOOK UP/ DATA BASES IF ANY

;ON KIT YOU NEED TO DO INIT FOR SP [TO SEPARATE STACK OF YOUR PROGRAME FROM
;MONITORS],DS AS SHOWN BELOW.SS,ES ARE SET TO 0000 AT POWER ON BY MONITOR.
;YOU CAN OFCOURSE CHANGE IT BY ADDING A FEW MORE MOVE`S.
;BUT WHILE WORKING ON PC YOU CAN`T TOUCH SEGMENT REGISTERS SINCE THEY ARE
;SET BY DOS LOADER,SO MANAGE THESE INSTRUCTIONS AS SHOWN IN COMMENT FIELD.  

SKIP_DATA:
	MOV     AX,10FFH  	; Initof SP for Kit
        MOV     AX,AX     	; On PC
        PUSH    CS        	; Init for DS
        POP     DS  
                	; Load kit INTS (A0-BF) 
        NOP             ; In PC using
        NOP             ; CALL in place of 3 NOP`S
        NOP             ;
						
START:  MOV 	AL,0B6H 	;Init the 8253 in 
        MOV 	DX,8C07H	;counter 2 mode 3
        OUT 	DX,AL		;
        MOV 	AL,00H        	;Load LSB count of      
        MOV 	DX,8C05H	;timer for 1KHz freq.
        OUT 	DX,AL                                          		;
        MOV 	AL,0FH        	;Load MSB count of 
        OUT 	DX,AL		;timer for 1KHZ freq. 
        MOV 	CX,0FFFFH     	; Delay Count  
        INT 	0AAH          	; Delay 
        JMP 	START		; Jump to start.
		
X868253   	ENDS
	END   	STRT



