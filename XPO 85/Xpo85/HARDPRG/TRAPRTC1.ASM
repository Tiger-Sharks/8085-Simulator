        CPU 8085
        
TEST:   EQU 2072H
CRLF:   EQU 048AH
NMOUT:  EQU 036CH
CMDWDP: EQU 0013H
CRONLY: EQU 0497H
WRITE:  EQU 2078H
        ORG 6130H
        LXI SP,27F0H
        CALL CRLF
        XRA A
        STA 2100H
        STA 2101H
        STA 2102H
        STA 2103H
        STA 2104H
        MVI A,0C3H
        STA 2051H
        LXI H,ISR
        SHLD 2052H
        MVI A,7EH
        OUT 1BH
        MVI A,24H
        OUT 19H
        MVI A,0F4H
        OUT 19H
        JMP DSPLY
LOOP:   LDA 2103H
        CPI 00H
        JZ LOOP
        LDA 2102H
        ADI 01H
        DAA
        CPI 60H
        JZ NXT1
        STA 2102H
        XRA A
        STA 2103H
        JMP DSPLY
NXT1:   XRA A
        STA 2102H
        LDA 2101H
        ADI 01H
        DAA
        CPI 60H
        JZ NXT2
        STA 2101H
        XRA A
        STA 2103H
        JMP DSPLY
NXT2:   XRA A
        STA 2101H
        LDA 2100H
        ADI 01H
        DAA
        CPI 13H
        JZ END
        STA 2100H
        XRA A
        STA 2103H
DSPLY:  MVI B,02H
        LDA 2100H
        MOV E,A
        CALL NMOUT
        MVI A,20H
        CALL WRITE
        LDA 2101H
        MOV E,A
        CALL NMOUT
        MVI A,20H
        CALL WRITE
        LDA 2102H
        MOV E,A
        CALL NMOUT
        CALL CRONLY
        CALL TEST
        JC LOOP
END:    MVI A,76H
        OUT 1BH
        JMP CMDWDP
        NOP
ISR:    PUSH B
        PUSH D
        PUSH H
        PUSH PSW
        LDA 2104H
        INR A
        CPI 28H
        JNZ SKIP1
        MVI A,00H
        STA 2104H
        MVI A,01H
        STA 2103H
        JMP SKIP3
SKIP1:  STA 2104H
SKIP3:  POP PSW
        POP H
        POP D
        POP B
        RET
        END




