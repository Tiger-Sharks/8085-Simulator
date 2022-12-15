;RST7.5
                CPU "8085.TBL"
		HOF "INT8"
CRLF:   EQU 048AH
OUTMSG: EQU 03D8H
DELAY:  EQU 0615H

        ORG 6000H
        LXI H, RST75
        SHLD 205EH
        MVI A,1BH
        SIM
LOOP:   LXI H,DBASE1
        CALL CRLF
        CALL OUTMSG
        LXI D,0FFFFH
        CALL DELAY
        EI
        JMP LOOP
        NOP
        NOP
        NOP
        NOP
RST75:  LXI H,DBASE2
        CALL CRLF
        CALL OUTMSG
        LXI D,0FFFFH
        CALL DELAY
        RET
DBASE1: DFB 58H
        DFB 50H
        DFB 4FH
        DFB 20H
        DFB 4BH
        DFB 49H
        DFB 54H
        DFB 03H
DBASE2: DFB 52H
        DFB 53H
        DFB 54H
        DFB 20H
        DFB 37H
        DFB 2AH
        DFB 35H
        DFB 20H
        DFB 03H


