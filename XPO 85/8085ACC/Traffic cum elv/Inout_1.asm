        CPU "8085.TBL"
        HOF "INT8"
        ORG 75B2H
        PORTA: EQU 08H
        PORTB: EQU 09H
        CONTW: EQU 0BH
        CMDWDP: EQU 0013H
        TEST: EQU 2072H
        MVI A,90H
        OUT CONTW
 BACK:  IN PORTA
        OUT PORTB
        CALL TEST
        JNC CMDWDP
        JMP BACK
        END
