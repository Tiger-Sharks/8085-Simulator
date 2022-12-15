;PROGRAM FOR SOUND GENERATION FROM 40 Hz TO 10 KHz.
        CPU "8085.TBL"
        HOF "INT8"
DELAY:    EQU 0615H

        ORG 6585H
        LXI SP,27F0H    ;INIT STACK PTR

START:  LXI B,042FH
LOOP:   MVI A,0B6H
        OUT 1BH
        MOV A,C
        OUT 1AH
        MOV A,B
        OUT 1AH
        LXI D,085EH
        CALL DELAY
        DCX B
        MVI A,00H
        CMP B
        JNZ LOOP
        MVI A,0F9H
        CMP C
        JNZ LOOP
        JMP START
