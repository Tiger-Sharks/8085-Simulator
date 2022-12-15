77
;TITLE : SUBSTRACTION OF 16 BIT BCD NUMBER.

;TO SUBSTRACT 16 BIT BCD NUMBER STORED FROM LOCATION X FROM ANOTHER
;16 BIT BCD NUMBER STORED AT LOCATION Y.STORE THE RESULT IN LOCATION 
;Z AND DISPLAY THE RESULT IN DATA FIELD OR ADDRESS FIELD.

;100'S COMPLEMENT METHODE IS USED TO SUBSTRACT THE TWO BCD NUMBER.
;A LOWER BYTE OF SECOND OPERAND IS SUBSTRACTED FROM 100 AND YOU WILL 
;GET 100'S COMPLEMENT OF LOWER BYTE OF SECOND OPERAND. ADD IT TO 
;LOWER BYTE OF 1st OPERAND.DAA CONVERTS RESULT TO BCD.IF BARROW
;IS GENERATED i.e. CARRY FLAG IS RESET(CY=0) THEN ADD 01H TO HIGHER
;BYTE OF 2nd OPERAND.DO SAME SUBSTRACTION FOR THE HIGHER BYTE.
;RESULT IS SAVED AT MEM. LOC.RESULTB(20C0H),RESULTH(20C1H),RESULTL
;(20C2H).AND DISPLAYED IN ADDRESS FIELD. 

;INPUT TO PROGRAM :-
;X LOCATION : 604AH
;Y LOCATION : 604CH

;OUTPUT OF PROGRAM :-
;RESULT BARROW AT LOCATION 20C0H
;RESULT HIGHER BYTE AT LOCATION 20C1H
;RESULT LOWER BYTE AT LOCATION 20C2H
;AND DISPLAYED IN ADDRESS FIELD

;REGISTERS MODIFIED ALL


                     CPU"8085.TBL"  ;8085 CPU USED. 
                     HOF"INT8"      ;INTELHEX 8 BIT FORMAT

              CRLF:   EQU 048AH     ;CLEAR DISPLAY.   
              NMOUT:  EQU 036CH     ;OUT NUMBER ON DISPLAY.
              CMDWDP: EQU 0013H     ;RETURN TO COMMAND MODE
                                    ;WITHOUT DISTURBING DISPLAY.

                     ORG 6410H
                   
                     LXI H,OPR2L    ;2nd OPERAND LOWER BYTE
                     MOV E,M        ;CALCULATE 100'S COMPLEMENT-
                     MVI A,99H      ;SUBSTRACT A NUMBER FROM 100.
                     SUB E          ;HERE SUBSTRACTED FROM 99 AND-
                     ADI 01H        ;ONE IS ADDED.  
                     MOV E,A        ;SAVE IN E.

                     LXI H,OPR2H    ;2nd OPERAND HIGHER BYTE
                     MOV C,M        ;CALCULATE 100'S COMPLEMENT AS  
                     MVI A,99H      ;DISCRIBED ABOVE.
                     SUB C
                     ADI 01H
                     MOV C,A        ;SAVE IN C. 

                     LXI H,OPR1L    ;LOWER BYTE OF 1st OPERAND.
                     MOV A,M
                     ADD E          ;ADD 2nd OPERAND.
                     DAA            ;ADJUST FOR BCD.
                     MOV E,A
                     JC XX          ;IF BARROW IS GENERATED i.e.
                     MOV A,C        ;IF CARRY FLAGE IS RESET
                     SUI 01H        ;THEN SUBTRACT 01H FROM HIGHER BYTE
                     MOV C,A        ;OF 2nd OPERAND.

                 XX: LXI H,OPR1H    ;HIGHER BYTE OF 1'st OPERAND. 
                     MOV A,M
                     ADD C          ;ADD 100'S COMPLEMENT.
                     DAA            ;CONVERT TO BCD 
                     MOV D,A        ;SAVE RESULT
            
                     JC YY          ;SAVE BARROW IN
                     MVI C,01H      ;IN C REGISTER.
                     JMP ZZ
                 YY: MVI C,00H
                    
                 ZZ: MOV A,C         
                     STA 20C0H      ;SAVE BARROW TO RESULTB
                     MOV A,D
                     STA 20C1H      ;SAVE HIGHER BYTE OF RESULT TO RESULTH
                     MOV A,E
                     STA 20C2H      ;SAVE LOWER BYTE OF RESULT TO RESULTL
                     

                     CALL CRLF      ;CLEAR DISPLAY.
                     MVI B,04H
                     CALL NMOUT     ;OUT RESULT IN ADDRESS FIELD.  
                     JMP CMDWDP    ;RETURN TO COMMAND MODE
                                    ;DISTURBING DISPLAY.
                    OPR1H: DFB 82H  ;HIGHER BYTE OF 1st OPERAND.
                    OPR1L: DFB 82H  ;LOWER BYTE OF 1nd OPERAND.
                    OPR2H: DFB 48H  ;HIGHER BYTE OF 2nd OPERAND. 
                    OPR2L: DFB 48H  ;LOWER BYTE OF 2nd OPERAND.


;END OF PROGRAM
