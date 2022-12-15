        CPU "8085.TBL"
        HOF "INT8"
        ORG 75C3H
        PORTA: EQU 08H
        PORTB: EQU 09H
        CONTW: EQU 0BH
        CMDWDP: EQU 0013H
        TEST: EQU 2072H
BACK:   MVI A,90H ;Set port A as input and port B as output port
        OUT CONTW
        MVI H,08H ;Load counts for 8 bit loop
        MVI C,01H ;Rotate right counter
        MVI D,01H ;Data to mask sussesive bits
        MVI E,00H ;Save result after each turn
        IN PORTA  ;Read the data from pore A
        MOV B,A
NEXTBIT:MOV A,B
        ANA D    ;Mask the bit
        PUSH H   ;Make resistor usable
        MOV H,C  ;Load number of rotations
ROTATE: RRC      ;rotate right
        DCR H
        JNZ ROTATE
        INR C    ;Increament number of rotations
        INR C    ;by two
        MOV L,A
        MOV A,D  ;Rotate masking bit to next
        RLC
        MOV D,A
        MOV A,E  ;Save that bit to corrosponding
        ORA L    ;swapped position
        MOV E,A
        POP H
        DCR H    ;Check for 8 times operation
        JNZ NEXTBIT
        MOV A,E
        OUT PORTB ;Out the swapped data to port B
        CALL TEST
        JNC CMDWDP
        JMP BACK
        END
