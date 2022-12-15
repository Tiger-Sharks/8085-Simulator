                SCPD EQU 0000H    ;Scratch Pad Location.
                NUM1 EQU 1000H    ;Address for Dividend.
                NUM2 EQU 1002H    ;Address for Divisor.
; This programme gives 16 bit by 8-bit binary division
; User can store dividend at memory location 0000:1000H
; and divisor at memory location 0000:1002H
; User can see result at memory location 0000:1010H
       DIV SEGMENT
       ASSUME CS:DIV,DS:DIV
       ASSUME ES:DIV
       ORG 100H                        ;Com format is recommanded.
       START: JMP SKIP_DATA            ;skip data bases if any.
;On kit you need to do initialise for SP(to seperate of
;your programme form monitor),DS as shown below.SS,ES are
;set to 0000H at power on by monitor.you can of course change
;it by adding a few more MOVEs .but while working on PC can't
;touch segment resister since they are set by DOS loader
;so manage these instructions as shown comment field. 	 	      
     SKIP_DATA:
                MOV AX,10FFH
                MOV SP,AX               ;Init SP for kit.
                PUSH CS
                POP DS                  ;Init DS register.
                MOV AX,SCPD
                MOV ES,AX
                MOV AX,ES:NUM1          ;Dividend in AX register.
                MOV BL,ES:NUM2          ;Divisor in BL register.
	          MOV BH,00
                MOV CX,08               ;Loop is to be repeated 8 times
                MOV DL,00               ;Quotient=00.
	BACK:	
                ADD AX,AX               ;Dvidend=2*Dvidend.
                ADD DL,DL               ;Quotient=2*Quotient.
                MOV DH,AH               ;Keep copy of AH in DH also.
                SUB AH,BL               ;Is MSB>=Divisor.
                JC AHEAD                ;No,go to next step.
                MOV DH,AH               ;Substract diviser.
                INC DL                  ;Add 1 to quotient.
	AHEAD:
		    MOV AH,DH
                LOOP BACK               ;If CX<>0 then repate the loop.
                MOV AL,DL               ;Store quotient in quo memory location.
                MOV ES:[1010H],AX           ;Move rmainder in rem memory location.
                INT 0A5H                ;Return to command mode.
                                        ;If you are runnig your software
  DIV ENDS                              ;on PC insert ---->include.
  END START


