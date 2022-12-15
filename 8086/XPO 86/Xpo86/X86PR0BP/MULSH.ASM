                SCPD EQU 0000H ;Scratch Pad Location.
                NUM1 EQU 1000H ;Address for Multiplicand.
                NUM2 EQU 1001H ;Address for multiplier.
;This programme gives multiplication by shift and method
;User can store multiplicand at memory location 0000:1000H
;and store multiplier at memory location 0000:1001H
;see result at memory location 0000:1010H by
;using substitute command.

       MULS SEGMENT
       ASSUME CS:MULS,DS:MULS,ES:MULS
       ORG 100H                 ;Com format is recommanded.
       START:JMP SKIP_DATA      ;Skip lookup data bases if any.
;On kit you need to do initialise for SP(to seperate of
;your programme form monitor),DS as shown below.SS,ES are
;set to 0000H at power on by monitor.you can of course change
;it by adding a few more MOVEs .But while working on PC can't
;touch segment resister since they are set by DOS loader
;so manage these instructions as shown comment field. 	 	  

     SKIP_DATA:
                MOV AX,10FFH
                MOV SP,AX       ;Init SP register.
                PUSH CS         ;Init DS register.
                POP DS
                MOV AX,SCPD
                MOV DL,ES:NUM1     ;Get multiplicand.
                MOV DH,00H       ;Extend it to 16-bit
                MOV BL,ES:NUM2     ;Get multiplier.
		MOV CX,08	;Number of times shift operation is
                                ;to done.
	BACK:	ADD AX,AX	;Product=2*Product
		SAL BL,1	;shift multiplier  to the left by 1-bit
		JNC AHEAD	;Is carry from multiplier.
		ADD AX,DX	;Yes,Product=Product+multiplicand.
	AHEAD:	
		LOOP BACK
                MOV ES:[1010H],AX
                
                INT 0A5H        ;Return to command mode


                                ;If you are running your
  MULS ENDS                     ;software on PC insert
  END START                     ;------->include

