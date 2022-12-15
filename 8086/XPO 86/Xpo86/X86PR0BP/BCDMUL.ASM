                SCPD EQU 0000H  ;Scratch Pad Location.
                NUM1 EQU 1000H  ;Address for Multiplicand.
                NUM2 EQU 1001H  ;Address for Multiplier.
;This programme gives BCD multiplication.
;User can store multiplicant at memory location 0000:1000H
;and multiplier at memory location 0000:1001H.
;User can see result at memory location 0000:1010H
;by using substitute command.
     BCDM SEGMENT
     ASSUME CS:BCDM,DS:BCDM
     ASSUME ES:BCDM
     ORG 100H                 ;com format is recommanded.
        START:JMP SKIP_DATA   ;skip lookup data bases if any.
;On kit you need to do initialise for SP(to seperate of
;your programme form monitor),DS as shown below.SS,ES are
;set to 0000H at power on by monitor.you can of course change
;it by adding a few more MOVEs .but while working on PC can't
;touch segment resister since they are set by DOS loader
;so manage these instructions as shown comment field. 	 	        

     SKIP_DATA:
                MOV AX,10FFH
                MOV SP,AX     ;Init SP register.
                PUSH CS       ;Init DS register.
                POP DS
                MOV AX,SCPD
                MOV ES,AX
                MOV AL,ES:NUM1   ;Put NUM1 in AL.
                MOV BH,ES:NUM2   ;Put NUM2 in BH.
		MUL BH	      ;Perform multiplication.
		AAM	      ;Convert number in AX to unpacked form.
                MOV ES:[1010H],AX ;Store the result.
                INT 0A5H      ;Return to command mode.
    BCDM ENDS                 ;If you are running your software
    END START                 ;on PC insert ---->include.

