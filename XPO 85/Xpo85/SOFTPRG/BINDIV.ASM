
;TITLE : DIVISION TWO ONE BYTE BINARY NUMBER.


                   CPU"8085.TBL"   ;CPU USED IS 8085.
                   HOF"INT8"       ;INTELHEX 8 BIT FORMAT IS USED.


               REMNDR:  EQU 20C0H
               QUTINT:  EQU 20C1H
                    ORG 6460H

                    LDA DIVSOR
                    MOV B,A
                    LDA DIVDND
                    MVI C,00H
                    CMP B
                    JC LOOP
           LOOP1:   SUB B
                    INR C
                    CMP B
                    JNC LOOP1
            LOOP:   STA REMNDR
                    MOV A,C
                    STA QUTINT
                    RST 1

            DIVSOR: DFB 08H
            DIVDND: DFB 42H
     
;END OF PROGRAM
                      
