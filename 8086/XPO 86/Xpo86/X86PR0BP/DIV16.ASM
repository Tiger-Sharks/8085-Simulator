          SCPD EQU 0000H  ;Scratch Pad Location.
          NUM1 EQU 1000H  ;Address of Dividend.
          NUM2 EQU 1002H  ;Address of Divisor.
;This programme gives signed division of given number.
;User can store divident at memory location 0000:1000H and
;divisor at memory location 0000:1002H
;User can see result at memory location 0000:1010H

    DIV SEGMENT
    ASSUME CS:DIV,DS:DIV
    ASSUME DS:DIV
    ORG 100H                ;com format is recommanded.
 START:JMP SKIP_DATA        ;skip lookup/data bases if any.
;On kit you need to do initialise for SP(to seperate of
;your programme form monitor),DS as shown below.SS,ES are
;set to 0000H at power on by monitor.you can of course change
;it by adding a few more MOVEs .but while working on PC can't
;touch segment resister since they are set by DOS loader
;so manage these instructions as shown comment field. 	 	 

SKIP_DATA:
          MOV AX,10FFH
          MOV SP,AX        ;Init SP register.
          PUSH CS          ;Init DS register.
          POP DS
          MOV AX,SCPD
          MOV ES,AX
          MOV AX,ES:NUM1    ;Move dividend to AX.
          MOV CL,ES:NUM2     ;Move divisor to CL.
          IDIV CL            ;Perform division.
          MOV ES:[1010H],AX
          INT 0A5H         ;Return to command mode.
                           ;If you are running your software
  DIV ENDS                 ;on PC insert ---->include.
  END START
