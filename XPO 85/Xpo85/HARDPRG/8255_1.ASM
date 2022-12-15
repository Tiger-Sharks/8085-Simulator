;8255 FLASHING LEDS
                CPU "8085.TBL"
		HOF "INT8"
DELAY:  EQU 0615H

        ORG 6045H
        MVI A,80H
        OUT 03H
        OUT 0BH
FLASH:  MVI A,55H
        OUT 00H
        OUT 08H
        LXI D,0FFFFH
        CALL DELAY
        MVI A,0AAH
        OUT 00H
        OUT 08H
        CALL DELAY
        JMP FLASH

