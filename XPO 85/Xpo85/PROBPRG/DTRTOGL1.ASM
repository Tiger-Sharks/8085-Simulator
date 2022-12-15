;TOGGLING OF DTR (8251)
                CPU "8085.TBL"
		HOF "INT8"
DELAY:  EQU 0615H
CW51:   EQU 29H

        ORG 64D0H
START:  MVI A,37H
        OUT CW51
        LXI D,0FFFFH
        CALL DELAY
        MVI A,35H
        OUT CW51
        LXI D,0FFFFH
        CALL DELAY
        JMP START
