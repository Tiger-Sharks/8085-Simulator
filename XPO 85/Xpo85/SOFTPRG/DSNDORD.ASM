
; TITLE : TO  ARRANGE N-ONE BYTE NUMBERS IN DESCENDING ORDER USING BUBBLE
;         SORT. N-IS STORED AT LOCATION X i.e.[TNUM] AND NUMBERS START
;         FROM LOCATION X+1 i.e.[START].

;A PROGRAM LOADS TWO COUNTERS. 
;PROGRAM COPIES A NUMBER SPECIFIED BY HL PAIR  COMPAIRS WITH NEXT 
;SUCCESSIVE NUMBER AND STORES SMALL NUMBER OUT OF TWO AT HIGHER MEM. 
;LOCATION AND INCREMENT MEM. POINTER.AT THE END OF FIRST COUNTER SMALLEST 
;NUMBER IS AT THE BOTTOM.DESCRESE SECOND COUNTER SUCCESSIVELY BY ONE 
;AND LOAD FIRST COUNTER WITH VALUE OF SECOND. AT THE END OF SECOND COUNTER 
;YOU WILL GET SORTED ARRAY.

;REGISTER MODIFIED : A,B,C,D,E,H,L.

;MEMORY LOCATION MODIFIED: FROM START(20C1H) TO START+TNUM (20C1+TNUM).
                    
;INPUT TO PROGRAM
;TOTAL NUMBERS FOR SORTING AT LOCATION X =START=20C1H
;NUMBERS STORED FOR SORTING IN MEM. FROM X+1 LOCATION ONWARD

;OUTPUT OF PROGRAM
;SORTED NUMBERS FROM LOCATION =START+1=20C2H

;OUTPUT OF PROGRAM


               CPU"8085.TBL"      ;PROGRAM EXECUITABLE ON 8085 CPU
               HOF"INT8"          ;HEX FILE OF INTELHEX FORMAT
                    

;MONITOR SUBROUTINE EQUITIES



                     ORG 6370H    ;START  PROGRAM FROM 6000H

;START OF PROGRAM

                     LXI H,20C0H  ;TNUM = MEM. LOCATION OF N
                                  ;i.e.TOTAL NUMBERS FOR ARRANGING.
                     MOV D,M      ;COUNTER
                     MOV B,M      ;COUNTER
                     INX H
           LOOP1:    MOV C,B  
           LOOP:     MOV A,M
                     INX H
                     CMP M 
                     JNC LARGE    ;JUMP IF 1st IS LARGE
                                        
                     MOV E,A
                     MOV A,M      ;INTERCHANGE THE NUMBERS
                     DCX H        ;IN MEMORY
                     MOV M,A
                     INX H
                     MOV M,E
                    
            LARGE:   DCR C
                     JNZ LOOP
                     LXI H,20C1H  ;LOAD STARTING ADDRESS
                     DCR B
                     JNZ LOOP1
                     
                     RST 1
            
            

           

;END OF PROGRAM                              
