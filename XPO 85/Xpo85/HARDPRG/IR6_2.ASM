;8259/IR6
		CPU "8085.TBL"
		HOF "INT8"
CRLF:   EQU 048AH
CRONLY: EQU 0497H
OUTMSG: EQU 03D8H
CRLF:   EQU 048AH
WRTENB: EQU 027BH
WRTDSB: EQU 029DH
DELAY:  EQU 0615H
IR6VECT: EQU 6270H
        ORG 6210H
        MVI A,53H  ;52 CHANGED TO 53
        OUT 20H
        MVI A,62H
        OUT 21H
        ;MVI A,61H
        ;OUT 21H
        MVI A,00H  ;CHANGED
        OUT 21H    ;CHANGED
        MVI A,0BFH ;CHANGED
        OUT 21H    ;CHANGED
        ;MVI A,0BFH
        ;OUT 21H
        CALL WRTENB
        LXI H,IR6VECT
        MVI A,0C3H
        MOV M,A
        LXI H,IR6
        SHLD 6271H
        CALL WRTDSB
LOOP:   LXI H,DBAS1
        CALL CRLF
        CALL OUTMSG
        LXI D,0FFFFH
        CALL DELAY
        EI
        JMP LOOP
IR6:    LXI H,DBAS2
        CALL CRLF
        CALL OUTMSG
        LXI H,0FFFFH
        CALL DELAY
        MVI A,20H
        OUT 20H
        RET
DBAS1:  DFB 58H
        DFB 50H
        DFB 4FH
        DFB 20H
        DFB 4BH
        DFB 49H
        DFB 54H
        DFB 03H
DBAS2:  DFB 38H
        DFB 32H
        DFB 35H
        DFB 39H
        DFB 20H
        DFB 49H
        DFB 52H
        DFB 36H
        DFB 03H

