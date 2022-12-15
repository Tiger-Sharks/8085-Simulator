               SCPD EQU 0000H   ;Scratch Pad Location.
               NUM1 EQU 1000H   ;Address for Dividend.
               NUM2 EQU 1002H   ;Address for Divisor.
;This programme gives BCD division.
;User can store divident at memory location 0000:1000H and
;divisor at memory location 0000:1002H.
;User can see result at memory location 0000:1010H by using
;substitute command.

       BCDD SEGMENT
       ASSUME CS:BCDD,DS:BCDD
       ASSUME ES:BCDD
               ORG 100H      ;com format is recommended

       START:JMP SKIP_DATA   ;skip lookup/data bases
                             ;if any
                             
;On kit you need to do initialise for SP(to seperate of
;your programme form monitor),DS as shown below.SS,ES are
;set to 0000H at power on by monitor.you can of course change
;it by adding a few more MOVEs .but while working on PC can't
;touch segment resister since they are set by DOS loader
;so manage these instructions as shown comment field. 	 	       
  SKIP_DATA:
            MOV AX,10FFH
            MOV SP,AX       ;Init SP register.
            PUSH CS         ;Init DS register.
            POP DS
            MOV AX,SCPD     ;To specify SCPD on kit.
            MOV ES,AX
            MOV AX,ES:NUM1  ;Move 16-B bit number to  AX.
            MOV CH,ES:NUM2  ;store divisor in CH register.
            AAD             ;Adjust unpacked number in AX to binary.
            DIV CH          ;Perform division,remainder in AH and
            MOV ES:[1010H],AX   ;Qutient in AL.
            INT 0A5H        ;Return to command mode.
  BCDD ENDS                 ;If you are running your software
  END START                 ;on PC insert ----->include.
