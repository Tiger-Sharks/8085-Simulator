       PAGE,80
       TITLE-- USING RTC(58167).


X86RTCTM   	SEGMENT
		
          	ASSUME CS:X86RTCTM, DS:X86RTCTM ,ES:X86RTCTM
          	ORG 100H      	;COM FORMAT IS RECOMMENDED.

STRT: 	JMP 	SKIP_DATA      	;SKIP LOOK UP/ DATA BASES IF ANY

;ON KIT YOU NEED TO DO INIT FOR SP [TO SEPARATE STACK OF YOUR PROGRAME FROM
;MONITORS],DS AS SHOWN BELOW.SS,ES ARE SET TO 0000 AT POWER ON BY MONITOR.
;YOU CAN OFCOURSE CHANGE IT BY ADDING A FEW MORE MOVE`S.
;BUT WHILE WORKING ON PC YOU CAN`T TOUCH SEGMENT REGISTERS SINCE THEY ARE
;SET BY DOS LOADER,SO MANAGE THESE INSTRUCTIONS AS SHOWN IN COMMENT FIELD.  

SKIP_DATA:
	MOV     AX,10FFH  	;Init of SP for kit
        MOV 	AX,AX     	;MOV AX,AX   on PC
        PUSH	CS        	;Init for DS
        POP   	DS  
                            	;Load kit Int's (A0-BF) in PC using
        NOP               	;
        NOP               	;CALL in place of 3 NOP`S
        NOP               	;
        INT    	0ACH       	;Clear/refresh display
START:  MOV    	DX,0A009H
        IN     	AL,DX 	 	;Read hours from I/P port 0A008H
        MOV    	DL,AL      	;Hours are directly in BCDS
	MOV    	AL,02H     	;Display Hours (two digits)
        INT   	0AEH       	;On display
        MOV   	DL,20H     	;Display blank space
        MOV   	AH,02H		;
        INT   	0A2H       	;On the display
        MOV   	DX,0A007H	;
        IN    	AL,DX      	;Read minutes from I/P port 0A006H
        MOV   	DL,AL      	;in BCD format
        MOV   	AL,02H     	;Display minutes (two digits)
        INT   	0AEH       	;in BCD format
        MOV   	DL,20H     	;Display blank Space
        MOV   	AH,02H		;
        INT   	0A2H       	;on the display
        MOV   	DX,0A005H 	;
        IN    	AL,DX      	;Read second from I/P port 0A004H
        MOV   	DL,AL      	;in BCD format
        MOV   	AL,02H     	;Display seconds (two digits)
        INT   	0AEH       	;On the display
        INT   	0ABH       	;Curser at start position
        JMP   	START      	;Jump to start.
		
X86RTCTM  	ENDS
	END   	STRT
