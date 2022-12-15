
		CPU "8085.TBL"
		HOF "INT8"
CRLF:   EQU 048AH
NMOUT:  EQU 036CH
CRONLY: EQU 0497H
CMDWDP: EQU 0013H
DATA:   EQU 2100H
RESULT: EQU 2200H
        ORG 62C0H
        LXI SP,27F0H
        LXI H,DATA
        MOV C,M
        INX H
        XRA A
        MOV D,A
NXTBYT: CALL ADDTN
        INX H
        MOV E,A
        DCR C
        JNZ NXTBYT
        LXI H,RESULT
        MOV M,E
        INX H
        MOV M,D
        CALL CRLF
        MVI B,04H
        CALL NMOUT
        CALL CMDWDP
ADDTN:  ADD M
        RNC
        MOV E,A
        MOV A,D
        ADI 01H
        MOV D,A
        MOV A,E
        RET




