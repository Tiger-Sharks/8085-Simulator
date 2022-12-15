;STAUTUS INDICATOR OPTO ISOLATED I/O RELAY CARD
;Processor interface is provided via 26 pin FRC.
             STAT SEGMENT
             ASSUME CS:STAT
                CR55 EQU 8006H
                PORTB EQU 8002H
                PORTC EQU 8004H
                PORTA EQU 8000H

                 ORG 100H
               MOV AX,0000H
               MOV ES,AX                              
               MOV SS,AX                              
               MOV AX,11F0H  ;Init .SP
               MOV SP,AX                              
               PUSH CS       ;Set CS=DS                          
               POP DS

               MOV DX,CR55  ;Init port A,
               MOV AL,83H   ;C(upper) as OP
               OUT DX,AL    ;B,C(lower) as IP                          

         STRT: MOV DX,PORTB ;read data from
               IN AL,DX     ;port B
               MOV DX,PORTA 
               OUT DX,AL    ;O/P data to 
               MOV BL,AL    ;port A & CL

               MOV DX,PORTC ;read port C 
               IN AL,DX     ;lower
               MOV DH,AL
               AND DH,0FH
               MOV DL,BL
               INT 0ABH    ;CRONLY
               MOV AL,04H
               INT 0AEH    ;display status
               MOV AL,DH
               MOV CL,04H
               SAL AL,CL
               MOV DX,PORTC ;o/p data to 
               OUT DX,AL    ;port C upper
               MOV AH,0BH
               INT 0A1H     ;READ K/B
               CMP AL,00H   ;if key pressed
               JNZ EXIT     ;exit
               JMP STRT     ;else continue
        EXIT:  INT 0A3H     ;COMMAND MODE
                     
        STAT ENDS
               END STRT


