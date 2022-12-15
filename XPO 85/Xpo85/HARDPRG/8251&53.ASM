
		CPU "8085.TBL"
		HOF "INT8"
DELAY:  EQU 0615H
CRLF:   EQU 048AH
WRITE:  EQU 2078H
CMDWDP: EQU 0013H
        ORG 60B0H
        LXI D,01FFH   ;
        MVI A,36H
        OUT 1BH
        MVI A,2DH
        OUT 18H
        MVI A,05H
        OUT 18H
        MVI A,00H
        OUT 29H
        CALL DELAY
        OUT 29H
        CALL DELAY
        OUT 29H
        CALL DELAY
        MVI A,40H
        OUT 29H
        CALL DELAY
        MVI A,0CEH
        OUT 29H
        CALL DELAY
        MVI A,37H
        OUT 29H
        CALL CRLF
        LXI H,TABLE
LOOP:   MOV A,M
        CPI 03H
        JZ FINIT
SEND:   IN 29H
        ANI 01H
        JZ SEND
        MOV A,M
        OUT 28H
        INX H
RECIV:  IN 29H
        ANI 02H
        JZ RECIV
        IN 28H
        CALL WRITE
        CALL DELAY
        JMP LOOP
FINIT:  JMP CMDWDP
;DISPLAYS "ANSHUMAN SERIAL LINK"
TABLE:  DFB 41H
        DFB 4EH
        DFB 53H
        DFB 48H
        DFB 55H
        DFB 4DH
        DFB 41H
        DFB 4EH
        DFB 20H
        DFB 20H
        DFB 20H
        DFB 20H
        DFB 20H
        DFB 20H
        DFB 20H
        DFB 20H
        DFB 53H
        DFB 45H
        DFB 52H
        DFB 49H
        DFB 41H
        DFB 4CH
        DFB 20H
        DFB 20H
        DFB 20H
        DFB 4CH
        DFB 49H
        DFB 4EH
        DFB 4BH
        DFB 20H
        DFB 20H
        DFB 03H





