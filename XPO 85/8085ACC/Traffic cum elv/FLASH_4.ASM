
 ;PROGRAM FOR TRAFFIC LIGHT CONTROLLER

        CPU "8085.TBL"
        HOF "INT8"

DELAY:  EQU 0615H 

        ORG 7700H
        LXI SP,2100H       ;INITIALISE STACK POINTER
        MVI A,80H          ;CLEAR ALL PORTS 
        OUT 0BH            ;SET ALL PORTS AS OUTPUT PORTS
 START: MVI A,61H         ;TURN ALL THE RED SIGNALS ON
        OUT 08H
        MVI A,68H
        OUT 09H
        MVI A,86H
        OUT 0AH
        CALL DELAY1     ;DELAY FOR 4 SEC.
        MVI A,92H          ;TURN ALL YELLOW SIGNALS ON
        OUT 08H
        MVI A,84H
        OUT 09H
        MVI A,48H
        OUT 0AH
        CALL DELAY2        ;DELAY FOR 2 SEC.
        MVI A,0CH       ;TURN ALL GREEN SIGNALS ON
        OUT 08H
        MVI A,13H
        OUT 09H
        MVI A,31H
        OUT 0AH
        CALL DELAY1  ;DELAY FOR 4 SEC.
        JMP START
DELAY1: LXI D,0FFFFH      ;DELAY COUNT
        CALL DELAY
        CALL DELAY
        CALL DELAY
        CALL DELAY
        RET
DELAY2: LXI D,0FFFFH
        CALL DELAY
        CALL DELAY
        RET
        END


