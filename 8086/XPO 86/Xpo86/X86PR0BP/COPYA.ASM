              SCPD EQU 0000H   ;Scratch Pad Location.
              ARRAY2 EQU 1000H ;Address for ARRAY2

;This programme gives copy a block from memory location
;Array1 to Array2
; Array1 has been store  from memory location 1000:0103H to
;1000:010CH.
;Result will be stored from memory location 0000:1000H to 0000:100AH
;User can check using substitute command.
                                    
              COPY SEGMENT
              ASSUME  CS:COPY,DS:COPY,ES:COPY
              ORG 100H        ;com format is recommanded.
   START:JMP SKIP_DATA        ;skip lookup/data bases if any.
;On kit you need to do initialise for SP(to seperate of
;your programme form monitor),DS as shown below.SS,ES are
;set to 0000H at power on by monitor.you can of course change
;it by adding a few more MOVEs .but while working on PC can't
;touch segment resister since they are set by DOS loader
;so manage these instructions as shown comment field. 	 

             ARRAY1 DB 10H,20H,30H,40H,50H,60H,70H,80H,90H
   SKIP_DATA:
                MOV AX,10FFH            
                MOV SP,AX           ;Init SP register.
                PUSH CS
                POP DS              ;Init DS register.
                MOV AX,SCPD         ;To specify SCPD location on kit.
                MOV ES,AX
                MOV SI,OFFSET ARRAY1;Address of Array1 in SI.
                MOV DI,ARRAY2       ;Address of Array2 in DI.
                MOV CX,0AH          ;No of elements=10.
	BACK:	
                XOR AL,AL           ;Clear AX.
                MOV AL,[SI]         ;Get a byte from array1.
                MOV ES:[DI],AL      ;Copy to array2.
                INC SI              ;Incriment source.
                INC DI              ;and destination pointers.
                LOOP BACK           ;Repeat if  CX<>0
                INT 0A5H            ;Return to command mode.
 COPY ENDS                          ;If you are running your
 END START                          ;software on PC insert
                                    ;here----->include.
