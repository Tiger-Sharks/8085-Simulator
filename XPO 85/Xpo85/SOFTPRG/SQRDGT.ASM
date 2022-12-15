
;TITLE : PROGRAM TO FINDOUT SQUARE OF A NUMBER.

;TO PREPARE A LOOKUP TABLE FOR A SQUARE OF ONE DIGIT DECIMAL NUMBER
;READ A ONE DIGIT DECIMAL NUMBER FROM A KEYBOARD OBTAIN ITS SQUARE
;FROM THE LOOKUP TABLE. DISPLAY THE DIGIT IN THE ADDRESS FIELD AND 
;ITS SQUARE IN DATA FIELD.

;A PROGRAM TAKES INPUT FROM KEBOARD IN ASCII FORMAT.SUBSTRACTS 30H FROM 
;IT AND CONVRTS IT TO A DECIMAL NUMBER.ADDS THAT NUMBER IN STARTING ADDRESS
;OF LOOKUP TABELE AND GETS ADDRESS OF THE SQUIRE OF THE NUMBER.READS IT
;AND DISPLAYS NUMBER IN ADDRESS FIELD AND SQUARE IN DATA FIELD.  

;STARTING ADDRESS OF ASCII STRING IS = ENTER:
;STARTING ADDRESS OF LOOKUP TABLE = LOOKUP:

;INPUT TO PROGRAM FROM KEYBOARD

;OUTPUT OF PROGRAM ON DISPLAY

                       CPU "8085.TBL"  ;CPU USED IS 8085.
                       HOF "INT8"      ;INTELHEX 8 BIT FORMAT USED.
                    
                 CRLF:     EQU 048AH   ;CLEAR DISPLAY & LINE FEED.
                 NMOUT:    EQU 036CH   ;DISPLAY THE NUMBER.
                 CMDWDP:   EQU 0013H   ;RETURN TO COMMAND MODE WITHOUT 
                                       ;DISTURBING DISPLAY.  
                 OUTMSG:   EQU 03D8H   ;OUT MASSAGE TO DISPLAY.
                 READ:     EQU 2075H   ;READ A ASCII NUMBER OF KEY;
                 WRITE:    EQU 2078H   ;DISPLAY THE CHAR. OF ASCII CODE.
  
                   ORG 63C0H

                   CALL CRLF           ;CLEAR DISPLAY.
                   LXI H,ENTER         ;ADDRESS OF ASCII STRING "ENTER"
                   CALL OUTMSG         ;DISPLAY "ENTER"

             START:CALL READ           ;READ ASCII CODE OF NUMBER.
                   SUI 30H             ;GET A ACTUAL NUMBER
                   MOV C,A             ;SAVE IN C REG.

                   LXI H,LOOKUP        ;STARTING ADDRESS OF THE LOOKUP
                   ADD L               ;ADD NUM. AND GET ADDRESS OF
                   MOV L,A             ;SQUARE OF NUMBER.
                   MOV A,M
                   CALL CRLF
                   MVI D,00H
                   MOV E,C
                   MVI B,02H
                   CALL NMOUT          ;DISPLAY THE NUM. IN ADDRESS FIELD
                   MVI A,20H           ;ASCII CODE OF SPACE CHAR.
                   CALL WRITE           ;DISPLAY 4 SPACE CHAR.
                   CALL WRITE
                   CALL WRITE
                   CALL WRITE
                   ;JMP START
                   MOV E,M
                   MVI D,00H
                   MVI B,02H
                   CALL NMOUT          ;DISPLAY THE SQUIRE IN DATA FIELD.
                   JMP CMDWDP         ;GOTO COMMAND MODE WITHOUT
                                       ;DISTURBING DISPLAY.
           
           ENTER:  DFB "ENTER ",03H     ;ASCII STRING ENTER.
           LOOKUP: DFB 00H,01H,04H,09H ;STARTING ADDRESS OF LOOKUP TABLE.                 
          LOOKUP1: DFB 16H,25H,36H,49H
          LOOKUP2: DFB 64H,81H   
;END OF PROGRAM   
               
