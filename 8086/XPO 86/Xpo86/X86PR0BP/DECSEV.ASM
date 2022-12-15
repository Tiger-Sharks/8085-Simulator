             SCPD EQU 0000H    ;Scratch Pad Segment.
             NUM EQU  1000H    ;
;This program shows  DECIMAL to SEVEN SEGMENT convertion.
;User can store number at memory location 0000:1000H
;Result will be stored at memory location 0000:1010H
;User can check using substitute command.

     DECSEV SEGMENT
     ASSUME CS:DECSEV,DS:DECSEV,ES:DECSEV
          ORG 100H      ;com format is recommanded.
   START: JMP SKIP_DATA ;skip lookup/data bases if any. 
;On kit you need to do initialise for SP(to seperate of
;your programme form monitor),DS as shown below.SS,ES are
;set to 0000H at power on by monitor.you can of course change
;it by adding a few more MOVEs .but while working on PC can't
;touch segment resister since they are set by DOS loader
;so manage these instructions as shown comment field.

             TABL DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH
   SKIP_DATA:
             MOV AX,10FFH
             MOV SP,AX               ;Init for SP register.
             PUSH CS                 ;Init for DS register.
             POP DS
             MOV AX,SCPD             ;To specify SCPD location on kit
                                     ;for Seven segment values.
             MOV ES,AX
             MOV AL,ES:NUM           ;Index value.
             MOV BX,OFFSET TABL      ;Offset of the table.
             XLAT                    
             MOV BL,AL
             MOV ES:[1010H],BL       ;Store the segment code.
             INT 0A5H                ;Return to command mode.

  DECSEV ENDS                        ;If you are running your software
   END START                         ;on PC insert ---->include.

