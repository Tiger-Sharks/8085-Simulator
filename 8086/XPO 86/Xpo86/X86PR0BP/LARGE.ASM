
               SCPD EQU 0000H ;Scratch Pad location.

;This programme gives largest of given signed number.
;User can store signed numbers from memory location
;1000:0103 to 1000:0116H and see result at memory location 0000:1000H
;using substitute command.
               LRG SEGMENT
               ASSUME CS:LRG,DS:LRG,ES:LRG
               ORG 100H          ;Com format is recommanded.
 START:JMP SKIP_DATA             ;Skip lookup data bases if any.
;On kit you need to do initialise for SP(to seperate of
;your programme form monitor),DS as shown below.SS,ES are
;set to 0000H at power on by monitor.you can of course change
;it by adding a few more MOVEs .but while working on PC can't
;touch segment resister since they are set by DOS loader
;so manage these instructions as shown comment field. 	 	 

                ARRAY1 DW 8700H,0080H,1234H,3233H,8676H,5000H,6000H,8000H,5785H,1000H  ;Address for TA4BL.

   SKIP_DATA:
                MOV AX,10FFH
                MOV SP,AX               ;Init SP register
                PUSH CS                 ;Init DS register
                POP DS
                MOV AX,SCPD             ;To specify SCPD on kit.
                MOV ES,AX
                MOV SI,OFFSET ARRAY1    ;Address of ARRAY1 in SI.
                MOV BX,8000H            ;Maximum number for comparision.
                MOV CX,08               ;Counter=8
        BACK:   MOV AX,[SI]          ;Load number form sequence.
		CMP BX,AX		;Compair with current maximum number.
                JNC AHEAD               ;If grater ,
                MOV BX,AX               ;Save new maximum number.
	AHEAD:
                INC SI                  ;Then check with next number.
		INC SI
		LOOP BACK 
                MOV ES:[1000H],BX
                INT 0A5H                ;Return to command mode.
                                        ;If you are running your software
    LRG ENDS                            ;on PC insert ----->include.
    END START
