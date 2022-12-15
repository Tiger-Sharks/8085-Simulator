
;TITLE : DIVISION TWO ONE BYTE BINARY NUMBER.


                   CPU"8085.TBL"   ;CPU USED IS 8085.
                   HOF"INT8"       ;INTELHEX 8 BIT FORMAT IS USED.


               RESULT:  EQU 20C0H
                    ORG 6480H

                    LXI H,HEXDTA
                    LXI B,0000H
                    MOV A,M
           LOOP:    SUI 64H
                    JC LOOP1
                    INR B
                    JMP LOOP
           LOOP1:   ADI 64H
           LOOP2:   SUI 0AH
                    JC LOOP3
                    INR C
                    JMP LOOP2
           LOOP3:   ADI 0AH
                    LXI H,RESULT
                    MOV M,B
                    MOV B,A
                    MOV A,C
                    RLC
                    RLC
                    RLC
                    RLC
                    ADD B
                    INX H
                    MOV M,A
                    RST 1
          HEXDTA:   DFB 47H

