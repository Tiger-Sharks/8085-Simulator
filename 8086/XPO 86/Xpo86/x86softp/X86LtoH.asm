
;****FOLLOWING LISTING IS W.R.T. BATTERY BACKED RAM AT 10000H BUT THIS
;    PROGRAMME CAN WORK IN SCRATCH PAD RAM LOCATED AT 00000H .PL. ENTER
;    THE SAME FROM 0138:0100[0000:1480] AND EXECUTE. 

;*******CONVERTING A LOWER CASE STRING TO UPPER CASE
;	--------------------------------------------
;PASCAL CONSTRUCT--
;VAR
;  s		: string[20];
;  i		: integer;
;BEGIN
;  FOR i := 1 TO 20 do
;	if (ord(s[i] >= ord ('a')) and (ord(s[i] <= ord('z)) then
;		s[i] := chr(ord(s[i] + ord 'A') - ORD ('a'));
;END.

;S	DB      20 DUP (?)   LOCATED AT 0100:012A [=0000:112A] IN SCPD
;			     ENTER HEX NOS BETWEEN 41-7A U/LOWER CASE.

X86LTOH 	SEGMENT
ASSUME CS:X86LTOH, DS:X86LTOH ,ES:X86LTOH 
ORG 100H	        ;Com format 
                        ;is recommended.
STRT:	JMP SKIP_DATA   ;skip look up/ 
			;data bases if any
;On kit you need to do init for SP[to 
;separate stack of your program from
;monitors], DS as shown below. SS,ES are 
;set to 0000 at power on by monitor. You 
;can of course change it by adding a few 
;more moves. But while working on pc you 
;can't touch segment registers since 
;they are set by dos loader, so manage 
;these instructions as shown in comment 
;field.  

SKIP_DATA:
MOV	AX,10FFH ;INIT OF SP FOR KIT               
MOV	SP,AX                                          
PUSH	CS       ;INIT FOR DS                        
POP	DS       ;                                   
NOP	                                               
NOP	                                               
NOP	                                               
MOV	AX,0100H                                        
MOV	ES,AX    ;INIT OF ES                         
MOV	CX,0014H ;LOOP COUNTER                       
MOV	SI,012AH ;POINTS TO START OF STRING
LUP:MOV	AL,ES:[SI] ;GET NEXT CHARACTER S[I]     
CMP	AL,61H 	;S[I] >= 'A'?         
JB	NOTL    ;NO, NOT LOWER CASSE               
CMP	AL,7AH  ;YES, S[I] <= 'Z'?       
JA	NOTL    ;NO NOT LOWER CASE                  
ADD	AL,0E0H ;IT IS LOWER CASE.CONVRT TO 
		;UPPER BY ADDING OFFSET
MOV	ES:[SI],AL ;STORE CHARACTER BACK               
NOTL:INC SI     ;BUMP STRING POINTER                
LOOP	LUP     ;REPEAT FOR ALL STRING CHRS   
INT	0A5H          

X86LTOH		ENDS 
    END 	STRT
                         

