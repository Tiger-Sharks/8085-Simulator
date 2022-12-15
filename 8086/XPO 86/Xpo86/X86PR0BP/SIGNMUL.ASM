               SCPD EQU 0000H ;Scratch Pad location.
               NUM1 EQU 1000H ;Address of Multiplicand.
               NUM2 EQU 1001H ;Address of Multiplier.
;This programme gives sigened multiplication.
;User can store the multiplicant at memory location
;0000:1000H and multiplier at memory location 0000:1001H.
;User can also see result at memory location 0000:1010H
;by using substitute command.
        SIGN SEGMENT
         ASSUME CS:SIGN,DS:SIGN
         ASSUME ES:SIGN
             ORG 100H            ;Com format is recommanded.
        START:JMP SKIP_DATA      ;Skip lookup data bases if any.
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
              
                MOV AX,SCPD    ;To specify SCPD for kit.
                MOV ES,AX
                MOV AL,ES:NUM1    ;Put NUM1 to AL.
                MOV CL,ES:NUM2   ;Put NUM2 to CL.
		IMUL CL		;Perform signed multiplication.
                MOV ES:[1010H],AX   ;Store the result.
                INT 0A5H        ;Return to command mode
                                ;If you are running your
   SIGN ENDS                    ;software on PC insert
   END START                    ;------->include

