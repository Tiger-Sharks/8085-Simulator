;DISPLAY 00 & FF ALTERNATELY ON DISPLAY

		CPU "8085.TBL"
		HOF "INT8"
CRLF:   EQU 048AH
NMOUT:  EQU 036CH
DELAY:  EQU 0615H
CRONLY: EQU 0497H
        ORG 6390H

        LXI SP,27F0H
        CALL CRLF
START:  MVI E,00H
        MVI B,02H
        CALL NMOUT
        LXI D,0FFFFH
        CALL DELAY
        CALL CRONLY ;LF
        ;LXI D,0FFFFH
        ;CALL DELAY
        MVI E,0FFH
        CALL NMOUT
        LXI D,0FFFFH
        CALL DELAY
        CALL CRONLY ;LF
        ;LXI D,0FFFH
        ;CALL DELAY
        JMP START



