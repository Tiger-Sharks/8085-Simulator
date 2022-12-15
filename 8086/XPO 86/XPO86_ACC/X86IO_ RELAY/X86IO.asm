;OPTOISOLATED RELAY CARD (DATE 20/2/04)
;Processor interface is provided via 26 pin FRC.
;PROGRAM FOR SQUARE GENERATION
             IO SEGMENT
             ASSUME CS:IO
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

               MOV DX,CR55  ;Init port A,B
               MOV AL,80H   ;C as OP
               OUT DX,AL                              

         STRT: MOV DX,PORTA
               MOV AL,55H   ;o/p data
               OUT DX,AL    ;on port A
               MOV DX,PORTC
               MOV AL,0D0H  ;& C(upper) 
               OUT DX,AL    
               MOV CX,0FFFFH
               INT 0AAH     ;CALL DELAY
               MOV DX,PORTA
               MOV AL,0AAH  ;toggle data
               OUT DX,AL    ;o/p to port A
               MOV DX,PORTC
               MOV AL,0E0H  ;& C(upper) 
               OUT DX,AL    
               MOV CX,0FFFFH
               INT 0AAH     ;CALL DELAY
               MOV AH,0BH
               INT 0A1H     ;READ K/B
               CMP AL,00H   ;if key pressed
               JNZ EXIT     ;exit
               JMP STRT     ;else continue
        EXIT:  INT 0A3H     ;COMMAND MODE
                     
        IO ENDS
               END STRT


