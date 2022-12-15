;ADDITION OF 2 BCD NUMBERS
		CPU "8085.TBL"
		HOF "INT8"
CRLF:   EQU 048AH
NMOUT:  EQU 036CH
CRONLY: EQU 0497H
CMDWDP: EQU 0013H
DATA1:   EQU 2100H
        ORG 62F0H
        LXI SP,27F0H
        XRA A
        MOV D,A
        LXI H,DATA1
        MOV A,M
        INX H
        MOV B,M
        ADD B
        DAA
        CC CARRY
        MOV E,A
        CALL CRLF
        MVI B,04H
        CALL NMOUT
        CALL CMDWDP
CARRY:  INR D
        RET






