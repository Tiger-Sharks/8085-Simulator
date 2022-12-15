



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
SKIP_DATA:MOV AX,11FFH			;INIT OF SP FOR KIT
STRT1:  MOV SP,AX                       ;MOV AX,AX   ON PC
	PUSH CS				;THIS IS THE BEST WAY TO LOAD DS
	POP DS				;WITH SEGMENT VALUE.
	NOP				;LOAD KIT INT S (A0-BF) IN PC USING
	NOP				;CALL LDINPC
        NOP        ;PLACE ABOVE CALL IN PLACE OF 3 NOP`S
        MOV AL,80H                      ;SET ALL PORTS
        MOV DX,8006H                    ;OF LOWER 8255 AS
        OUT DX,AX                       ;OUTPUT PORTS
START:  MOV AL,61H                     ;TURN ALL RED SIGNALS
        MOV DX,8000H                    ;"ON"
        OUT DX,AL
        MOV AL,68H
        MOV DX,8002H
        OUT DX,AL
        MOV AL,86H
        MOV DX,8004H
        OUT DX,AL
        MOV AL,60H
        MOV DX,8000H                    ;TURN OFF 2 RED & 7 RED
        OUT DX,AL
        MOV AL,48H
        MOV DX,8002H
        OUT DX,AL
        MOV AL,64H                      ;TURN "ON" 2 GREEN AND 7 GREEN
        MOV DX,8000H
        OUT DX,AL
        MOV AL,58H
        MOV DX,8002H
        OUT DX,AL                       ;
        CALL DELAY1                   ;LOAD DELAY COUNT
        ;INT 0AAH                        ;CALL DELAY 4 TIMES
        ;INT 0AAH                        ;
       ; INT 0AAH                        ;
       ; INT 0AAH                        ;
        MOV AL,60H
        MOV DX,8000H                    ;TURN "OFF" 2 GREEN & 7 GREEN
        OUT DX,AL
        MOV AL,48H
        MOV DX,8002H
        OUT DX,AL
        MOV AL,62H                      ;TURN "ON" 2 GREEN & 7 YELLOW
        MOV DX,8000H
        OUT DX,AL                       ;
       CALL DELAY2                      ;
        MOV AL,60H                      ;TURN "OFF" 2 YELLOW & 7 YELLOW
        MOV DX,8000H
        OUT DX,AL
        MOV AL,61H
        MOV DX,8000H
        OUT DX,AL
        MOV AL,68H                     ;TURN "ON" ALL RED SIGNALS
        MOV DX,8002H                    ;
        OUT DX,AL                       ;
       CALL DELAY2                       ;
        MOV AL,41H                     ;TURN ON 3R & 9R
        MOV DX,8000H
        OUT DX,AL
        MOV AL,06H
        MOV DX,8004H
        OUT DX,AL
        MOV AL,49H                      ;TURN ON 3G & 9G
        MOV DX,8000H                    ;
        OUT DX,AL
        MOV AL,26H
        MOV DX,8004H
        OUT DX,AL
      CALL DELAY1                       ;CALL DELAY 4 TIMES
       ; INT 0AAH                        ;
       ; INT 0AAH                        ;
       ; INT 0AAH                        ;
        MOV AL,41H                      ;TURN "OFF" 3G & 9G
        MOV DX,8000H
        OUT DX,AL
        MOV AL,06H
        MOV DX,8004H
        OUT DX,AL
        MOV AL,51H                      ;TURN ON 3Y & 9Y
        MOV DX,8000H                     ;
        OUT DX,AL
        MOV AL,46H
        MOV DX,8004H
        OUT DX,AL
      CALL DELAY2                        ;CALL DELAY
        MOV AL,41H                      ;TURN "OFF"  3Y & 9Y
        MOV DX,8000H
        OUT DX,AL
        MOV AL,06H
        MOV DX,8004H
        OUT DX,AL
        MOV AL,61H                     ;TURN "ON" ALL RED SIGNALS
        MOV DX,8000H
        OUT DX,AL
        MOV AL,86H
        MOV DX,8004H
        OUT DX,AL
       CALL DELAY2                      ;CALL DELAY
        MOV AL,60H                     ;TURN "OFF" 5R & 6R
        MOV DX,8002H
        OUT DX,AL
        MOV AL,82H
        MOV DX,8004H
        OUT DX,AL
        MOV AL,62H                      ;TURN "ON" 5G & 6G
        MOV DX,8002H                    ;PEDESTRIAN CROSSING
        OUT DX,AL
        MOV AL,92H
        MOV DX,8004H
        OUT DX,AL
      CALL DELAY1                       ;
        MOV AL,60H                      ;TURN "OFF" 5G & 6G
        MOV DX,8002H
        OUT DX,AL
        MOV AL,82H
        MOV DX,8004H
        OUT DX,AL                       ;
        MOV AL,64H                     ;TURN "ON" 5R & 6R
        MOV DX,8002H                    ;
        OUT DX,AL                         ;CALL DELAY
        MOV AL,8AH
        MOV DX,8004H
        OUT DX,AL
        CALL DELAY2
        MOV AL,60H
        MOV DX,8002H                        ;TURN "OFF" 4R & 8R
        OUT DX,AL                       ;
        MOV AL,82H                      ;TURN "ON" 4G & 8G
        MOV DX,8004H                    ;
        OUT DX,AL
        MOV AL,68H
        MOV DX,8002H
        OUT DX,AL
        MOV AL,86H
        MOV DX,8004H
        OUT DX,AL
       CALL DELAY2                      ;CALL DELAY 4 TIMES
       ; INT 0AAH                        ;
       ; INT 0AAH                        ;
       ; INT 0AAH                        ;
        MOV AL,21H
        MOV DX,8000H                       ;TURN "OFF" 4G & 8G
        OUT DX,AL                       ;
        MOV AL,28H                      ;TURN "ON" 4Y & 8Y
        MOV DX,8002H                    ;
        OUT DX,AL
        MOV AL,29H
        MOV DX,8002H
        OUT DX,AL
        MOV AL,87H
        MOV DX,8004H
        OUT DX,AL
       CALL DELAY1                       ;CALL DELAY
        MOV AL,21H
        MOV DX,8002H
        OUT DX,AL
        MOV AL,86H      ;TURN "OFF" 4Y & 8Y
        MOV DX,8004H
        OUT DX,AL                       ;
        MOV AL,0A1H                     ;TURN "ON" 4R & 8R
        MOV DX,8000H                    ;
        OUT DX,AL
        MOV AL,0A8H
        MOV DX,8002H
        OUT DX,AL
       CALL DELAY2                       ;CALL DELAY
        MOV AL,21H
        MOV DX,8000H   ;TURN "OFF" 1R & 7R
        OUT DX,AL                       ;
        MOV AL,28H                      ;TURN "ON" 1G & 7G
        MOV DX,8002H                     ;
        OUT DX,AL
        MOV AL,61H
        MOV DX,8000H
        OUT DX,AL
        MOV AL,68H
        MOV DX,8002H
        OUT DX,AL
        CALL DELAY2
        JMP START
DELAY2:INT 0AAH
        INT 0AAH
        INT 0AAH
        RET
DELAY1: CALL DELAY2
        CALL DELAY2
        CALL DELAY2
        CALL DELAY2
        CALL DELAY2
        RET
TRAF3    ENDS                    ;READ FOR MORE INFO TITLE OF KIT_INTS.ASM
         END STRT
                                                                              


























Š




%%%%	 		 
