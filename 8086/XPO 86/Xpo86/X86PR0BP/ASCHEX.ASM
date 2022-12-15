               SCPD EQU 0000H ;Scratch Pad location.
               ASCII EQU 1000H  ;ASCII number.
;This programme shows ascii to hexadecimal number convertion.
;User can store ascii number at memory location 0000:1000H
;and hexadecimal will be stored at memory location 0000:1010H.
  
             ASC SEGMENT
             ASSUME CS:ASC,DS:ASC,ES:ASC
    ORG 100H                  ;com format is recommended
  START:JMP SKIP_DATA         ;skip data bases if any 
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
                MOV AX,SCPD     ;To specify SCPD on kit
                MOV ES,AX
                MOV AL,ES:ASCII    ;ASCII number to convert in  AL.
                SUB AL,30H      ;See if number is between 0-9.
		CMP AL,9	;IF>9,it's a letter.
                JC AHEAD
                JMP ENDL
         AHEAD:
		SUB AL,07H	;Sub 7 to furnish letter 
	                        ;conversion.
          ENDL:
                MOV ES:[1010H],AX
                INT 0A5H        ;Return to command mode.
                                ;If you are running your
   ASC ENDS                     ;software on PC insert 
   END START                    ;----->include
  
