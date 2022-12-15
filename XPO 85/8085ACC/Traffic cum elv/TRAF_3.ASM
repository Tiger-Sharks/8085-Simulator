
 ;PROGRAM FOR TRAFFIC LIGHT CONTROLLER

        CPU "8085.TBL"
        HOF "INT8"

DELAY:  EQU 0615H 

        ORG 75F5H
        LXI SP,2100H       ;INITIALISE STACK POINTER
        MVI A,80H          ;CLEAR ALL PORTS 
        OUT 0BH            ;SET ALL PORTS AS OUTPUT PORTS
        MVI A,61H         ;TURN ALL THE RED SIGNALS ON
        OUT 08H
        MVI A,68H
        OUT 09H
        MVI A,86H
        OUT 0AH
START:  MVI A,60H          ;TURN OFF PA0  AND PB5
        OUT 08H
        MVI A,48H
        OUT 09H
        MVI A,64H          ;TURN ON PA2 AND PB4
        OUT 08H
        MVI A,58H
        OUT 09H
        CALL DELAY1        ;TIME TO KEEP GREEN SIGNAL ON
        MVI A,60H          ;TURN OF PA2 AND PB4
        OUT 08H
        MVI A,48H
        OUT 09H
        MVI A,62H         ;TURN ON PA1
        OUT 08H
        CALL DELAY2        ;TIME TO KEEP YELLOW SIGNAL ON
        MVI A,60H        ;TURN OFF PA1
        OUT 08H
        MVI A,61H        ;TURN ON PA0  AND PB5
        OUT 08H
        MVI A,68H          ;TURN ON 3G AND 9G
        OUT 09H
        CALL DELAY2
        MVI A,41H          ;TURN OFF PA5 AND PC7
        OUT 08H
        MVI A,06H
        OUT 0AH
        MVI A,49H
        OUT 08H
        MVI A,26H
        OUT 0AH
        CALL DELAY1        ;TIME TO KEEP GREEN SIGNAL ON
        MVI A,41H          ;TURN OFF PA5 AND PC5
        OUT 08H
        MVI A,06H
        OUT 0AH
        MVI A,51H          ;TURN ON PA4 AND PC6
        OUT 08H
        MVI A,46H
        OUT 0AH
        CALL DELAY2        ;TIME TO KEEP YELLOW SIGNAL ON
        MVI A,41H          ;TURN OFF PA4 AND PC6
        OUT 08H
        MVI A,06H
        OUT 0AH
        MVI A,61H          ;TURN ON PA5 AND PC7
        OUT 08H
        MVI A,86H
        OUT 0AH
        CALL DELAY2
        MVI A,60H          ;TURN OFF PB3 AND PC2
        OUT 09H
        MVI A,82H
        OUT 0AH
        MVI A,62H          ;TURN ON PB1 AND PC4
        OUT 09H
        MVI A,92H
        OUT 0AH
        CALL DELAY1        ;TIME TO KEEP GREEN SIGNAL ON
        MVI A,60H         ;TURN OFF PB1 AND PC4
        OUT 09H
        MVI A,82H
        OUT 0AH
        MVI A,64H         ;TURN ON PB2 AND PC3
        OUT 09H
        MVI A,8AH
        OUT 0AH
        CALL DELAY2        ;TIME TO KEEP YELLOW SIGNAL ON
        MVI A,60H          ;TURN OFF PB2 AND PC3
        OUT 09H
        MVI A,82H
        OUT 04H
        MVI A,68H          ;TURN ON PB3 AND PC2
        OUT 09H
        MVI A,86H
        OUT 0AH
        CALL DELAY2
        MVI A,21H          ;TURN OFF PA6 AND PB6
        OUT 08H
        MVI A,28H
        OUT 09H
        MVI A,29H          ;TURN ON PB0 AND PC0
        OUT 09H
        MVI A,87H
        OUT 0AH
        CALL DELAY1        ;TIME TO KEEP GREEN SIGNAL ON
        MVI A,21H          ;TURN OFF PB0 AND PC0
        OUT 09H
        MVI A,86H
        OUT 0AH
        MVI A,0A1H         ;TURN ON PA7 ANDPB7
        OUT 08H
        MVI A,0A8H
        OUT 09H
        CALL DELAY2        ;TIME TO KEEP YELLOW SIGNAL ON
        MVI A,21H          ;TURN OFF PA7 AND PB7
        OUT 08H
        MVI A,28H
        OUT 09H
        MVI A,61H          ;TURN ON PA6 AND PB6
        OUT 08H
        MVI A,68H
        OUT 09H
        CALL DELAY2
        JMP START 
           
          	          
DELAY1: LXI D,0FFFFH      ;DELAY COUNT
        CALL DELAY
        CALL DELAY
        CALL DELAY
        CALL DELAY
        RET
DELAY2: LXI D,0FFFFH
        CALL DELAY
        RET
        END


