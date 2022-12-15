                SCPD EQU 0000H ;Scratch Pad location.
                NUM1 EQU 1000H ;Address of Multiplicand.
                NUM2 EQU 1002H ;AddreSS of Multiplier.
;This programme gives multiplication using MUL instruction.
;User can store multiplicand at memory location 0000:1000H
;and multiplier at memory location 0000:1002H
;can see result at memory location 0000:1010H
;using substitute command.

            MULM SEGMENT
            ASSUME CS:MULM,DS:MULM
            ASSUME ES:MULM
            ORG 100H                    ;Com format is recommanded.
    START:JMP SKIP_DATA                 ;Skip lookup data bases if any.
;On kit you need to do initialise for SP(to seperate of
;your programme form monitor),DS as shown below.SS,ES are
;set to 0000H at power on by monitor.you can of course change
;it by adding a few more MOVEs .but while working on PC can't
;touch segment resister since they are set by DOS loader
;so manage these instructions as shown comment field. 	 	
    SKIP_DATA:
                MOV AX,10FFH
                MOV SP,AX               ;Init SP register
                PUSH CS                 ;Init DS register
                POP DS
                MOV AX,SCPD
                MOV ES,AX
                SUB DX,DX               ;Zero out overflow register.
                MOV AX,ES:NUM1             ;Put value to AX
                MUL ES:NUM2             ;Multiply NUM1 and NUM2
                MOV ES:[1010H],AX             ;Move LSB in ANS1
                MOV ES:[1012H],DX             ;Move MSB in ANS2
                INT 0A5H                ;Return to command mode
                                       ;If you are running your
                                       ;software on PC insert
                                        ;------->include
  MULM ENDS
  END START
