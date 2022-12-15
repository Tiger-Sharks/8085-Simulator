;This program inputs the data from port A and out the data to port B
            SWAP SEGMENT
            ASSUME CS:SWAP
            ASSUME DS:SWAP
            ASSUME ES:SWAP
             CONTWD EQU 8006H
            PORTA EQU 8000H
            PORTB EQU 8002H
            PORTC EQU 8004H
            ORG 0100H
      STRT: JMP SKIP_DATA
    SKIP_DATA:MOV AX,10FFH
            MOV SP,AX
            PUSH CS
            POP DS
            MOV AX,0000H
            MOV ES,AX
      BACK: MOV AL,90H;Set portA as input and
            MOV DX,CONTWD;portB as output port
            OUT DX,AL
            MOV CH,08H;Laod counts for 8 bit loop
            MOV CL,01H;Rotate right counter
            MOV DH,01H;Data to mask sussesive bits
            MOV DL,00H;Save result after each turn
            PUSH DX
            MOV DX,PORTA;Read the data from portA
            IN AL,DX
            POP DX
            MOV BL,AL
   NEXTBIT: MOV AL,BL
            AND AL,DH;Mask the bit
            ROR AL,CL;Rotate the data
            INC CL   ;Increament data rotation
            INC CL   ;by two for next
            ROL DH,01H;Rotate the masking bit
            OR DL,AL; Save the bit
            DEC CH  ;dec. bit loop counter
            JNZ NEXTBIT;If 8 bit are completed
            MOV AL,DL ;out the data to port B
            MOV DX,PORTB
            OUT DX,AL
            MOV AH,08H
            INT 0A1H
            CMP AL,1BH
            JNE BACK
            INT 0A3H
            SWAP ENDS
            END STRT
