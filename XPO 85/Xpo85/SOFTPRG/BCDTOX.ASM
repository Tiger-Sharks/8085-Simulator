
;TITLE : BCD TO HEX CONVERSION.


                   CPU"8085.TBL"   ;CPU USED IS 8085.
                   HOF"INT8"       ;INTELHEX 8 BIT FORMAT IS USED.


               RESULT:  EQU 20C0H
                    ORG 64B0H

                    LXI H,BCDATA
                    MOV A,M
                    ADD A
                    MOV B,A
                    ADD A
                    ADD A
                    ADD B
                    INX H
                    ADD M
                    STA RESULT
                    RST 1
           BCDATA:  DFB 02H
                    DFB 09H

