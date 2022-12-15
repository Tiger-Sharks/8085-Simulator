X86IR2RT       SEGMENT
						
                ASSUME CS:X86IR2RT, DS:X86IR2RT ,ES:X86IR2RT
                ORG 100H              ;COM FORMAT IS RECOMMENDED.

STRT: 		JMP SKIP_DATA         ;SKIP LOOK UP/ DATA BASES IF ANY

;ON KIT YOU NEED TO DO INIT FOR SP [TO SEPARATE STACK OF YOUR PROGRAME FROM
;MONITORS],DS AS SHOWN BELOW.SS,ES ARE SET TO 0000 AT POWER ON BY MONITOR.
;YOU CAN OFCOURSE CHANGE IT BY ADDING A FEW MORE MOVE`S.
;BUT WHILE WORKING ON PC YOU CAN`T TOUCH SEGMENT REGISTERS SINCE THEY ARE
;SET BY DOS LOADER,SO MANAGE THESE INSTRUCTIONS AS SHOWN IN COMMENT FIELD.  
				
SKIP_DATA:
MOV  AX,10FFH  	;INIT OF SP FOR KIT
MOV  AX,AX     	;MOV AX,AX   ON PC
PUSH CS        	;INIT FOR DS
POP  DS  
        	;LOAD KIT INTS (A0-BF) IN PC USING
NOP            	;
NOP             ;PLACE CALL IN PLACE OF 3 NOP`S
NOP             ;
MOV  AX,0000H   ;ES IS USED AS SCPD TO 
NOP             ;STORE DATA.
MOV  ES,AX
INT  0ACH       ;Clear display	
MOV DX,0A00BH	;read day of 
IN  AL,DX	;week & store in
MOV DX,0A01BH  	;day of week
OUT DX,AL	;RAM.
MOV DX,0A00DH 	;read day of 
IN  AL,DX	;month & store 
MOV DX,0A01DH  	;in day of month 
OUT DX,AL	;RAM
MOV DX,0A00FH	;read month & 
IN  AL,DX	
MOV DX,0A01FH	;store in month 
OUT DX,AL	;RAM
MOV AL,16H 	;store 16H 
		;(4 pm) in hours
MOV DX,0A019H  	; RAM
OUT DX,AL
MOV AL,00H	;store 00H in
MOV DX,0A017H	;minutes ram &
OUT DX,AL
MOV DX,0A015H	;seconds ram
OUT DX,AL
MOV AL,21H 	;
MOV DX,0A023H 	;int cont reg.
OUT DX,AL
PUSH CS
POP  CX         ;Seg addr of ISR for IR0
MOV  SI,OFFSET ISR ;Offeset addr  
MOV  AL,92H	;Init of 0000:0248 Bytes so 
		;On Interrupt IR2 "INT 92
		;are exeuted.
INT  0BEH                                 
MOV  AL,1BH    	;level,Single	
		;ICW1 A1=0   
MOV  DX,9400H                            
OUT  DX,AL                              
MOV  AL,90H	;ISR of IR0 =INT 90H etc.
MOV  DX,9402H  	;A1=1	
OUT  DX,AL     	;ICW2	
MOV  AL,01H    	;8086,Normal EOI,Non Buffered,
	      	;Non Special,Nest
OUT  DX,AL	;ICW4,A1=1
MOV  AL,0FBH	;Enable IR2.
OUT  DX,AL 	;OCW1                             
		;                                       
LOOP1: 
STI		;enable INT
INT  0ABH	;cursor at 1st pos
MOV  DX,0A009H	;Read hours 
IN   AL,DX
MOV  DL,AL	;hour & display
MOV  AL,02H	;two digits.
INT  0AEH	;NMOUT Display number.
MOV  DL,20H	;display blank
MOV  AH,02H	;02 for write.
INT  0A2H	;display blank	
MOV  DX,0A007H	;read minutes
IN   AL,DX
MOV  DL,AL	;minutes & display
MOV  AL,02H	;two digits.
INT  0AEH	;NMOUT Display number.
MOV  DL,20H	;display blank
MOV  AH,02H	;02 for write.
INT  0A2H	;display blank	
MOV  DX,0A005H	;read seconds
IN   AL,DX
MOV  DL,AL	;seconds & display
MOV  AL,02H	;two digits.
INT  0AEH	;NMOUT Display number.
MOV  AH,0BH	;Check 'key' if 
INT  0A1H	;pressed goto
CMP  AL,0FFH	;command mode.
JZ   NEXT 
JMP  LOOP1 	
NEXT:
MOV AL,0B0H 	;& stop sound
MOV  DX,8C07H	;& stop sound
OUT  DX,AL	;else jump to
INT  0A3H	;command mode.

ISR:   
MOV DX,0A021H	;clear the RTC
IN  AL,DX	;interrupt by 
		;reading ISR. 
INT 0ACH 
MOV AL,0B6H	;CW for 8253
MOV DX,8C07H
OUT DX,AL       ;cntr 2, mode 3
MOV AL,00H	;LSB of count 
MOV DX,8C05H
OUT DX,AL				
MOV AL,0FH 	;MSB of count
OUT DX,AL
MOV AL,20H 	;non specific  
MOV DX,9400H
OUT DX,AL 	;end of interrupt
STI
IRET  		;return 

X86IR2RT 	ENDS
     END   	STRT
