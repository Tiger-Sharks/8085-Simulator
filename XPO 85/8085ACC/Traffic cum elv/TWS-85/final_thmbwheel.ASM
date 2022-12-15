     CPU "8085.TBL"
	HOF"INT8"
ORG 6000H

      
                            LXI  SP,2100H
                            MVI  A,89H
                            OUT  0BH
                     BACK:  MVI C,0EFH
                            CALL RUT1
			    MVI C,7FH
                            CALL RUT2
                            OUT 09H
                            JMP BACK
                     RUT1:  MOV A,C
                            OUT 08H
                            IN 0AH
                            XRI 0FFH
                            ANI 0FH
                            MOV B,A
                            
                            RET
                     RUT2:  MOV A,C
                            OUT 08H
                            IN 0AH
                            XRI 0FFH
                            MVI E,04H
                     LABLE1:RAL
                            DCR E
                            JNZ LABLE1
                            ANI 0F0H
                            ORA B
                            
                            RET
                    
            
                      
                         