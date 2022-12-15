

;        TITLE-- 8253 Event Counter
;REMOVE SHORT LINK 1,2
;OF L15
;AND ALSO REMOVE 6 PIN CONNECTOR WHEN NOT IN USE
;to give a pulse hold an obstacle
;or your little finger between
;IR diode and photo transistor.
X86LIGHT SEGMENT

ASSUME CS:X86LIGHT,DS:X86LIGHT,ES:X86LIGHT

                ORG 0100H        ;COM FORMAT IS RECOMMENDED.

STRT: 	JMP 	SKIP_DATA   	;SKIP LOOK UP/ DATA BASES IF ANY

;ON KIT YOU NEED TO DO INIT FOR SP [TO SEPARATE STACK OF YOUR PROGRAME FROM
;MONITORS],DS AS SHOWN BELOW.SS,ES ARE SET TO 0000 AT POWER ON BY MONITOR.
;YOU CAN OFCOURSE CHANGE IT BY ADDING A FEW MORE MOVE`S.
;BUT WHILE WORKING ON PC YOU CAN`T TOUCH SEGMENT REGISTERS SINCE THEY ARE
;SET BY DOS LOADER,SO MANAGE THESE INSTRUCTIONS AS SHOWN IN COMMENT FIELD.  

SKIP_DATA:
	MOV     AX,10FFH  	; Initof SP for Kit
        MOV     SP,AX           ; On PC
        PUSH    CS        	; Init for DS
        POP     DS  
                	; Load kit INTS (A0-BF) 
        NOP             ; In PC using
        NOP             ; CALL in place of 3 NOP`S
        NOP             ;
        START:
        MOV     AX,0000H
        MOV     CX,0000H
	MOV 	DX,0000H	
	MOV 	AL,0B0H 	;Init the 8253 in 
        MOV 	DX,8C07H	;counter 2 mode 0
        OUT 	DX,AL		;
        MOV     DX,8C05H
        MOV     AL,1FH          ;Load LSB count of
                                ;counter
        OUT     DX,AL
        MOV     AL,00H          ;Load MSB count of
        OUT 	DX,AL		;counter
        NOP
        NOP
        NOP
ABOVE:  IN AL,DX		;Wait for 1st pulse to give data
        MOV CL,AL		; to 8253 register
        IN AL,DX		
        MOV CH,AL
        MOV AL,CL
        CMP  AL,1FH
        JNZ ABOVE
ROUTINE:NOP
        NOP
        NOP
        MOV     DX,8C05H	;start detecting pulses
        IN AL,DX		;read register of 8253 counter
        MOV CL,1FH
        SUB CL,AL

        INC CL
        IN AL,DX
        MOV CH,AL
        INT 0ACH	;clear the display
        INT 0ABH	;bring cursor to LHS
        MOV DL,CL
        MOV AL,02H
        INT 0AEH	;DISPALY THE NUMBER OF PULSES
        MOV AL,CL
        CMP AL,1FH	;check whether last count is reached
	JZ LOOP		;if last count jump to command mode
        JMP ROUTINE	; if not zero jump to count pulses
LOOP:  INT 0A3H		;jump to command mode
X86LIGHT         ENDS
        END  STRT
