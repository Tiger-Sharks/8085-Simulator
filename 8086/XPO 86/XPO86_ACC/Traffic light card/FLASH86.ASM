



        PAGE,70
        TITLE-- TRAF3
;
TRAF3     SEGMENT
        ASSUME CS:TRAF3, DS:TRAF3 ,ES:TRAF3
	ORG 100H		;COM FORMAT IS RECOMMENDED.
STRT:	JMP SKIP_DATA			;SKIP LOOK UP/ DATA BASES IF ANY
;ON KIT YOU NEED TO DO INIT FOR SP [TO SEPARATE STACK OF YOUR PROGRAME FROM
;MONITORS],DS AS SHOWN BELOW.SS,ES ARE SET TO 0000 AT POWER ON BY MONITOR.
;YOU CAN OFCOURSE CHANGE IT BY ADDING A FEW MORE MOVE`S.
;BUT WHILE WORKING ON PC YOU CAN`T TOUCH SEGMENT REGISTERS SINCE THEY ARE
;SET BY DOS LOADER,SO MANAGE THESE INSTRUCTIONS AS SHOWN IN COMMENT FIELD.  
SKIP_DATA:MOV AX,11FFH                  ;Init. of SP for KIT
STRT1:  MOV SP,AX                       ;Mov AX,AX on PC
        PUSH CS                         ;This is the best way to load DS
        POP DS                          ;With segment value
        NOP                             ;Load Kit INT S
        NOP                             ;Call LDINPC
        NOP                             ;Place above call in place of NOP
        MOV AL,80H                      ;Set all port of
        MOV DX,8006H                    ;lower 8255 as output ports
        OUT DX,AX
START:  MOV AL,61H                     ;Turn all red signals ON
        MOV DX,8000H
        OUT DX,AL
        MOV AL,68H
        MOV DX,8002H
        OUT DX,AL
        MOV AL,86H
        MOV DX,8004H
        OUT DX,AL
        CALL DELAY2                   ;Delay for 4 sec.
        MOV AL,92H                    ;Turn all yellow signals ON
        MOV DX,8000H
        OUT DX,AL
        MOV AL,84H
        MOV DX,8002H
        OUT DX,AL
        MOV AL,48H
        MOV DX,8004H
        OUT DX,AL
        CALL DELAY1                 ;Delay for 2 sec.
        MOV AL,0CH                  ;Turn all green signals ON
        MOV DX,8000H
        OUT DX,AL
        MOV AL,13H
        MOV DX,8002H
        OUT DX,AL
        MOV AL,31H
        MOV DX,8004H
        OUT DX,AL
        CALL DELAY2               ;Delay for 4 sec.
        JMP START                 ;Repeat the same
DELAY2:INT 0AAH
        INT 0AAH
        INT 0AAH
        INT 0AAH
        RET
DELAY1: CALL DELAY2
        CALL DELAY2
         RET
TRAF3    ENDS                    ;READ FOR MORE INFO TITLE OF KIT_INTS.ASM
         END STRT
                                                                              


























Š




%%%%	 		 
