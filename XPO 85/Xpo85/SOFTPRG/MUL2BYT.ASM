
;TITLE : MULTIPLICATIONOF TWO ONE BYTE BINARY NUMBER.

;TO MULTIPLY TWO ONE BYTE BINARY NUMBERS STORED AT LOCATION X & Y 
;DISPLAY THE RESULT IN ADDRESS FIELD.

;ADDRESS OF FIRST OPERAND X LOCATION = OPR1:
;ADDRESS OF SECOND OPERAND Y LOCATION = OPR2:

;REGISTERS USED ALL

;INPUT TO THE PROGRAM
;INPUT1 STORED AT X LOCATION =OPR1:
;INPUT2 STORED AT Y LOCATION =OPR2:

;OUTPUT OF PROGRAM ON DISPLAY .

                   CPU"8085.TBL"   ;CPU USED IS 8085.
                   HOF"INT8"       ;INTELHEX 8 BIT FORMAT IS USED.


               CRLF:   EQU 048AH   ;CLEAR DISPLAY.
               NMOUT:  EQU 036CH   ;OUT THE NUMBER TO DISPLAY.
               CMDWDP: EQU 0013H   ;RETURN TO COMMAND MODE WITHOUT
                                   ;DISTURBING DISPLAY.
                    ORG 6340H
                    LXI H,OPR1     ;FIRST OPERAND.
                    MOV E,M        ;SAVE FIRST OPERAND IN
                    MVI D,00H      ;DE RESISTER PAIR.
                    LXI H,OPR2     ;SECOND OPERAND.
                    MOV A,M
                    MOV C,A        ;C SECOND OPERAND USED AS COUNTER
                    LXI H,0000H    ;MAKE HL 00H
                    CPI 00H        ;GOTO DISPLAY IF SECOND OPERAND
                    JZ ZERO        ;IS ZERO.
                   
                XX: DAD D          ;ADDS FIRST OPERAND UNTIL
                    DCR C          ;SECOND OPERAND BECOMES ZERO.
                    JNZ XX
                                  
              ZERO: CALL CRLF      ;CLEAR DISPLAY.
                    MOV D,H
                    MOV E,L
                    MVI B,04H
                    CALL NMOUT     ;DISPLAY RESULAT IN ADDRESS FIELD.
                    CALL CMDWDP    ;GOTO COMMAND MODE.
                    
              OPR1: DFB 04H        ;FIRST OPERAND
              OPR2: DFB 02H        ;SECOND OPERAND
     
;END OF PROGRAM
                      
