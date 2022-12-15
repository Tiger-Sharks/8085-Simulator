               SCPD EQU 0000H ;
               NUM EQU 1000H

;This program shows  BINARY to  GRAY Code convertion.
;GRAY code for binary 0 to 9 has been stored from memory location
;1000:0103H to 1000:010CH respectively.
;User can store BINARY number at memory locaion 0000:1000H
;Result will be store at memory location 0000:1010H
;User can check using substitute command.
          BING SEGMENT
          ASSUME CS:BING,DS:BING,ES:BING
                ORG 100H      ;com format is recommended.
        START: JMP SKIP_DATA   ;skip up databases if any.
;On kit you need to do initialise for SP(to seperate of
;your programme form monitor),DS as shown below.SS,ES are
;set to 0000H at power on by monitor.you can of course change
;it by adding a few more MOVEs .but while working on PC can't
;touch segment resister since they are set by DOS loader
;so manage these instructions as shown comment field.
           GRAY DB 0010B,0110B,0111B,0101B,0100B,1100B,1101B,1111B,1110B,1010B
      SKIP_DATA:
                MOV AX,10FFH
                MOV SP,AX     ;Init SP register.
                PUSH CS       ;Init DS registre.
                POP DS
                MOV AX,SCPD  ;To specify SCPD location on kit.
                MOV ES,AX
                MOV AL,ES:NUM    ;Number to look up.
		LEA BX,GRAY   ;Get start of table.
                XLAT          ;Look up value.
                MOV ES:[1010H],AL ;Move value from AL to result.
                INT 0A5H      ;Return to command mode.
  BING ENDS                    ;If you are runnig your software
  END START                   ;on PC insert ----->include.

