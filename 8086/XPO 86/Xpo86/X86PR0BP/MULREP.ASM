                 SCPD EQU 0000H  ;Scratch Pad Location.
                 NUM1 EQU 1000H  ;Address of Multiplicand.
                 NUM2 EQU 1001H  ;Address of Multiplier.
;This programme gives multiplication by repeated addition
;User can store multiplicand at memory location 0000:1000H
;and multiplier at memory location 0000:1001H.
;Result will be stored at memory location 0000:1010H.
;User can check using substitute comnmand.

      MULR SEGMENT
      ASSUME CS:MULR,DS:MULR
      ASSUME ES:MULR
               ORG 100H       ;com format is recommanded.
         START:JMP SKIP_DATA  ;skip lookup/data bases if any.
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
                 MOV AX,SCPD   ;To specify SCPD on kit.
                 MOV ES,AX
                 SUB CX,CX       ;CX=0
                 MOV CL,ES:NUM2     ;Put multiplier in cl.
                 SUB CL,01       ;correct index
                 MOV AL,ES:NUM1     ;Put multiplicand in al
        AGAIN:
                 ADD AL,ES:NUM1     ;add multiplicand to sum
                 ADC AH,00H     ;Extend it  to 16-bit index
                 LOOP AGAIN      ;loop if cx>0
                 MOV ES:[1010H],AX
                 INT 0A5H        ;Return to command mode.

MULR ENDS                       ;If you are running your software
END START                       ;on PC insert ---->include.

