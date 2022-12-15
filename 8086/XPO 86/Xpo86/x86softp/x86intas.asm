		PAGE,80
		TITLE--INT TO ASCII
				
;	CONVERTING AN INTEGER TO ASCII  FORM
;	------------------------------------

X86ITOA	SEGMENT
	ASSUME CS:X86ITOA, DS:X86ITOA ,ES:X86ITOA 
	ORG 100H		;COM FORMAT IS RECOMMENDED.
STRT: JMP SKIP_DATA		;SKIP LOOK UP/
				;DATA BASES IF ANY

;ON KIT YOU NEED TO DO INIT FOR SP [TO SEPARATE STACK OF YOUR PROGRAME FROM
;MONITORS],DS AS SHOWN BELOW.SS,ES ARE SET TO 0000 AT POWER ON BY MONITOR.
;YOU CAN OFCOURSE CHANGE IT BY ADDING A FEW MORE MOVE`S.
;BUT WHILE WORKING ON PC YOU CAN`T TOUCH SEGMENT REGISTERS SINCE THEY ARE
;SET BY DOS LOADER,SO MANAGE THESE INSTRUCTIONS AS SHOWN IN COMMENT FIELD.  

	
SKIP_DATA:
MOV	AX,10FFH  ;INIT OF SP FOR KIT          
MOV	SP,AX     ;MOV AX,AX 		
PUSH	CS        ;INIT FOR DS                 
POP	DS        ;                            
NOP	          ;                            
NOP	          ;                            
NOP	          ;                            
MOV	AX,0100H  ;                            
MOV	ES,AX     ;IN KIT LOAD EXTRA SEGMENT         
	          ;GET INTEGEER TO AX               
MOV	AX,ES:[0103H];DI POINTS TO START  OF ASCII
MOV	DI,0105H   

;---------------------------------------------------------------------
;INTASC CONVERTS THE FOUR DIGIT HEX NUMBER IN AX TO FOUR ASCII DIGITS
;IN THE MEMORY AREA POINTED TO BY DI. THE MOST SIGNIFICANT DIGIT IS
;STORED IN THE LOWEST ADDRESSED MEMORY LOCATION (@DI).
;
;	ENTRY :
;		AX  = HEX NUMBER
;		DI = POINTER TO ASCII STRING AREA
;	EXIT :
;		@DI TO @DI+3 CONTAINS FOUR ASCII DIGITS.
;
;	ALL REGISTERS PRESERVED. FLAGS CLOBBERED.
;--------------------------------------------------------------------

PUSH	CX        
PUSH	DI        ;SAVE DI WE WILL CHANGE IT 
MOV	CX,0004H  ;KEEP TRACK OF DIGIT COUNT      
LUP: PUSH CX       ;SAVE HEX DIGIT COUNT                
MOV	CL,04H    ;NUMBER OF BITS PER DIG.
		  ;ROTATE COUNT
ROL	AX,CL     ;ROTATE AX LEFT BY 4 BITS SO
		  ;NEXT DIG
		  ;COMES TO RIGHT NIBBLE OF AL         
POP	CX        ;RESTORE HEX DIGIT COUNT             
PUSH	AX        ;SAVE ROTATED HEX NUMBER             
AND	AL,0FH    ;RETAIN OLY LOWER NIBBLE             
CALL	HXAS      ;CONVERT TO ASCII IN AL              
  	          ;STORE NEXT ASCII CODE               
MOV	ES:[DI],AL;RESTORE ROTGATED HEX NUMBER         
POP	AX        ;BUMP POINTER                        
INC	DI        ;REPEAT FOR ALL 4 HEX DIGITS      
LOOP	LUP       ;RESTORE SAVED REGISTERS             
POP	DI        ;@DI TO @DI+3 CONTAIN 4 ASCI
POP	CX        ;ALL REGISTERS PRESERVED.            
INT	0A5H        


;---------------------------------------------------------------------
;HEXASC  CONVERTS THE HEX DIGIT IN THE LOWER NIBBLE O FL TO ITS ASCII
;REPRESENTATION IN  AL . ON ENTRY THE UPPER NIBBLE MUST BE 0. RESULTS
;ARE UNPREDICTABLE IF IT IS NOT !
;---------------------------------------------------------------------
HXAS PROC NEAR

CMP 	AL,09H    ;IS THE HEX NUMBER 10 TO 15?  
JA	UP9       ;YES                          
ADD	AL,30H    ;NO, + ASCI BIAS FOR 0 TO 9
RET	          ;AND EXIT                     
UP9: ADD AL,37H   ;ADD HEX BIAS                 
RET	          ;AND EXIT		      

HXAS ENDP

X86ITOA	ENDS
END     STRT

