            SCPD EQU 0000H     ;Scrath Pad Segment.
            NUM  EQU 1000H     ;Address for Number.
;This programme gives hexadecimal to ascii convertion.
;User can load hexadecimal number at memory location
;0000:1000H and ascii code will store at memory location
;0000:1010H.

        HEX SEGMENT
        ASSUME CS:HEX,DS:HEX
        ASSUME ES:HEX
        ORG 100H                  ;Com format is recommanded.
 START:JMP SKIP_DATA              ;Skip lookup data bases if any.
;On kit you need to do initialise for SP(to seperate of
;your programme form monitor),DS as shown below.SS,ES are
;set to 0000H at power on by monitor.you can of course change
;it by adding a few more MOVEs .but while working on PC can't
;touch segment resister since they are set by DOS loader
;so manage these instructions as shown comment field. 	 	 

 SKIP_DATA:
            MOV AX,10FFH
            MOV SP,AX          ;Init SP register.
            PUSH CS            ;Init DS register .
            POP DS
            MOV AX,SCPD        ;To specify SCPD location on kit.
            MOV ES,AX
            MOV AL,ES:NUM      ;Get hexadecimal number.
            CMP AL,0AH         ;Is data 10 or more ?
            JC ASCZ            ;
            ADD AL,0           ;Yes add offset to LETTERS.
     ASCZ:
            ADD AL,30H         ;Add offset for ASCII.
            MOV ES:[1010H],AX
            INT 0A5H           ;Return to command mode.
             
                               ;If you are running your
                               ;software on PC insert
                               ;------->include.
    HEX ENDS
    END START
