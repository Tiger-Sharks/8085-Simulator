       PAGE,80
       TITLE-- USING SLAVE MICRO.


		
X86SLVKD   	SEGMENT

          	ASSUME CS:X86SLVKD, DS:X86SLVKD ,ES:X86SLVKD
          	ORG 100H   	;COM FORMAT IS RECOMMENDED.

STRT: 	JMP 	SKIP_DATA 	;SKIP LOOK UP/ DATA BASES IF ANY

;ON KIT YOU NEED TO DO INIT FOR SP [TO SEPARATE STACK OF YOUR PROGRAME FROM
;MONITORS],DS AS SHOWN BELOW.SS,ES ARE SET TO 0000 AT POWER ON BY MONITOR.
;YOU CAN OFCOURSE CHANGE IT BY ADDING A FEW MORE MOVE`S.
;BUT WHILE WORKING ON PC YOU CAN`T TOUCH SEGMENT REGISTERS SINCE THEY ARE
;SET BY DOS LOADER,SO MANAGE THESE INSTRUCTIONS AS SHOWN IN COMMENT FIELD.  
					
SKIP_DATA:
	MOV     AX,10FFH  	; Init of SP for KIT
        MOV   	AX,AX   	; On PC
        PUSH    CS      	; Init for DS
        POP     DS  
                        ;Load KIT INT'S (A0-BF) 
        NOP             ;in PC using
        NOP             ;Place CALL in place of 3 NOP`S
        NOP           	;

        INT	0ACH          ;Clear display.

RDKEY:  MOV     AL,8EH        ; Out 8EH to  
        MOV     DX,9C00H      ; Read From 0EH.
        OUT     DX,AL         ; Out to Port. 
        MOV     CX,0004H      ; Minumum 40 microsec
        INT     0AAH          ; Delay 
        MOV     DX,9C01H
	IN      AL,DX         ; Read Character
        OR      AL,AL         ; Check For Key press.
        JNS     RDKEY         ; If not go back.
        AND     AL,7FH        ; Get ascii code in AH
        INT     0ABH          ; Move cursor to left.
        MOV     DL,AL         ; 
        MOV     AL,02H        ; Display only two digits.
        INT     0AEH          ; Display ascii code.
        JMP	RDKEY         ; Jump to start.

X86SLVKD  	ENDS
    	END   	STRT
