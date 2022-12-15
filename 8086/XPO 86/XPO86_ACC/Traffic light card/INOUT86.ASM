;This program inputs the data from port A and out the data to port B
            INOUT SEGMENT
            ASSUME CS:INOUT
            ASSUME DS:INOUT
            ASSUME ES:INOUT
             CONTWD EQU 8006H
            PORTA EQU 8000H
            PORTB EQU 8002H
            PORTC EQU 8004H
            ORG 0100H
      STRT: JMP SKIP_DATA
    SKIP_DATA:MOV AX,10FFH
            MOV SP,AX   ;Init. SP fpr KIT
            PUSH CS     ;Load DS with segment
            POP DS      ;Value
            MOV AX,0000H
            MOV ES,AX
            MOV AL,90H   ;Init. PortA of 8255 as
            MOV DX,CONTWD ;input and B as output
            OUT DX,AL     ;Port
    BACK:   MOV DX,PORTA  ;In the data from
            IN AL,DX      ;PortA
            MOV DX,PORTB  ;Out the data to
            OUT DX,AL     ;PortB
            MOV AH,08H
            INT 0A1H
            CMP AL,1BH
            JNE BACK
            INOUT ENDS
            END STRT
