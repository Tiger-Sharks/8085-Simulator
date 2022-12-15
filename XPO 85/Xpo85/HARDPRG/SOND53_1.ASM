;8253 SOUND GENERATOR.
                CPU "8085.TBL"
		HOF "INT8"
DELAY:  EQU 0615H

        ORG 6090H
START:  MVI A,0B6H
        OUT 1BH
        MVI A,00H
        OUT 1AH
        MVI A,0FH
        OUT 1AH
        LXI D,0FFFFH
        CALL DELAY
        JMP START


