

;TITLE : 16 BIT BINARY SUBSTRACTION.

;TO SUBSTRACT 16 BIT BINARY NUMBER STORED FROM LOCATION X FROM 
;ANOTHER 16 BIT BINARY NUMBER STORED FROM LOCATION Y.STORE THE 
;RESULT IN LOCATION Z AND DISPLAY THE RESULT IN DATA OR ADDRESS 
;FIELD.

;A PROGRAM COPYS 1st OPERAND IN BC REGISTER PAIR AND 2nd OPERAND
;IN DE REGISTER PAIR. FIRST SUBSTRACTS E FROM C (C-E) AND RESULT 
;COPYES TO C REGISTER (LOWER BYTE OF ACTUAL RESULT) THEN IT 
;SUBSTRACTS D FROM B (B-D) AND RESULT  COPYS TO B (HIGHER BYTE OF
;ACTUAL RESULT).SAVE RESULT IN LOCATION RESULTH AND RESULTL.AND 
;DISPLAY THE RESULT IN ADDRESS FIELD. 

;ADDRESS OF MEM. LOC. OF FIRST OPERAND LOCATION X = OPR1.  
;ADDRESS OF MEM. LOC. OF SECOND OPERAND LOCATION Y = OPR2. 
;ADDRESS OF MEM. LOC. OF HIGHER BYTE OF RESULT = RESULTH(20C0H).
;ADDRESS OF MEM. LOC. OF LOWER BYTE OF RESULT = RESULTL(20C1H). 

;REGISTER MODIFIED ALL
;MEM. LOCATION MODIFIED : RESULTL,RESULTH.
                
;INPUT TO PROGRAM  :
;FIRST NUMBER AT MEM. LOCATION X = OPR1
;SECOND NUMBER AT MEM. LOCATION Y= OPR2

;OUTPUT OF PROGRAM :
;LOWER BYTE OF RESULT AT MEMORY LOCATION RESULTL=20C0H
;HIGHER BYTE OF RESULT AT MEMORY LOCATION RESULTH=20C1H

                    CPU"8085.TBL"          ;CPU USED IS 8085.
                    HOF"INT8"              ;INTELHEX 8 BIT FORMAT USED.

                        
                    CRLF:   EQU 048AH      ;CLEAR DISPLAY.
                    NMOUT:  EQU 036CH      ;OUT THE NUMBER.
                    CMDWDP: EQU 0013H      ;RETURN TO COMMAND MODE
                                           ;WITHOUT DISTURBING DISPLAY.
                      
                       ORG 6310H

                       LXI H,OPR1          ;1st OPERAND.
                       MOV B,M             ;SAVE 1st OPERAND-
                       INX H               ;IN BC RESISTER.  
                       MOV C,M
                       LXI H,OPR2          ;2nd OPERAND.
                       MOV D,M             ;SAVE 2nd OPERAND-
                       INX H               ;IN DE RESISTER.
                       MOV E,M
                      
                       MOV A,C             ;SUBSTRACT LOWER BYTE OF
                       SUB E               ;SECOND OPERAND FROM FIRST.
                       MOV C,A
                       MOV A,B             ;SUBSTRACT WITH BARROW HIGHER
                       SBB D               ;BYTE OF SECOND OPERAND FROM FIRST.
                       MOV B,A
                       
                       STA 20C0H           ;SAVE HIGHER BYTE OF RESULT
                       MOV A,C             ;SAVE LOWER BYTE OF RESULT-
                       STA 20C1H           ;AT MEM. LOC. RESULTL.
                       
                       CALL CRLF           ;CLEAR DISPLAY.
                       MOV D,B
                       MOV E,C
                       MVI B,04H
                       CALL NMOUT          ;OUT RESULT TO ADDRESS FIELD.
                       CALL CMDWDP         ;RETURN TO COMMAND MODE.
                       
                       RST 1                       

                OPR1:  DFB 00H,0AH         ;FIRST OPERAND.
                OPR2:  DFB 00H,02H         ;SECOND OPERAND.
 

;END OF PROGRAM                               
