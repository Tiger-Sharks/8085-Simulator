;TOGGLING OF DTR (8251)
                CPU "8085.TBL"
		HOF "INT8"
DELAY:  EQU 0615H

        ORG 64F0H
START:  MVI A,0C0H
        SIM
        LXI D,0FFFFH
        CALL DELAY
        MVI A,40H
        SIM
        LXI D,0FFFFH
        CALL DELAY
        JMP START
