
       PAGE,90
       TITLE-COUNTING LOWER CASE Z IN STRING.

;***FOLLOWING LISTING IS W.R.T. BATTERY BACKED RAM AT 10000H BUT THIS
;   PROGRAMME CAN WORK IN SCRATCH PAD RAM LOCATED AT 00000H .PL. ENTER
;   THE SAME FROM 0135:0100[0000:01450] AND EXECUTE. 

;****TITLE -COUNTING 0F LOWER CASE z [7AH] IN GIVEN STRING

;   CONSIDER THE FOLLOWING REASONABLY REALISTIC PROBLEM. SUPPOSE WE 
;   HAVE A STRING 'S'LOCATED AT 0100:012E [0000:112E] OF LENGTH SAY 20.
;   WE WANT TO FIND OUT HOW MANY LOWER CASE 'Z'S THERE ARE IN THIS
;   STRING. THE PASCAL VERSION MIGHT LOOK SOMETHING LIKE THIS:;
;VAR
;  s	    : string[20];
;  i,count   : integer;
;begin
;	count  := 0;
;    for i := 1 TO 20 do
;        if (s[i] = 'z') then
;            count := count +1;
;END.
;
;			THE 8086 ASEMBLY TRANSLATION CAN BE:
	
;S	DB	20 DUP (?)	LOCATED AT 0100:012E FILL 7A BY HAND.
;COUNT	DW	?		LOCATED AT 0100:0142

X86CNTZ		SEGMENT
         ASSUME CS:X86CNTZ, DS:X86CNTZ ,ES:X86CNTZ
         ORG 100H                        ;COM FORMAT IS RECOMMENDED.

STRT:    JMP SKIP_DATA                   ;SKIP LOOK UP/ DATA BASES IF ANY

;ON KIT YOU NEED TO DO INIT FOR SP [TO SEPARATE STACK OF YOUR PROGRAME FROM
;MONITORS],DS AS SHOWN BELOW.SS,ES ARE SET TO 0000 AT POWER ON BY MONITOR.
;YOU CAN OFCOURSE CHANGE IT BY ADDING A FEW MORE MOVE`S.
;BUT WHILE WORKING ON PC YOU CAN`T TOUCH SEGMENT REGISTERS SINCE THEY ARE
;SET BY DOS LOADER,SO MANAGE THESE INSTRUCTIONS AS SHOWN IN COMMENT FIELD.  

SKIP_DATA:
	 MOV     AX,10FFH  ;INIT OF SP FOR KIT
         MOV     AX,AX     ;MOV AX,AX   ON PC
         PUSH    CS        ;INIT FOR DS
         POP     DS  
                           ;LOAD KIT INTS (A0-BF) IN PC USING
         NOP               ;
         NOP               ;PLACE CALL IN PLACE OF 3 NOP`S
         NOP               ;

         MOV	AX,0100H                                     
         MOV	ES,AX                                       
         MOV	ES:WORD PTR [0142H],0000 ;                       
         MOV	SI,0000H		      ;COUNT := 0                                       
NEXT:    CMP	ES:BYTE PTR [SI+012EH],7AH ;i SET IN SI
         JNZ	NOTZ                  ;S[I] = 'Z'?         
        	                      ;NO                      
         INC	ES:WORD PTR [0142H]   ;YES,COUNT:=COUNT+ 
NOTZ:    INC	SI                    ;BUMP POINTER      
         CMP	SI,+13H           ;I < 19?                 
         JBE	NEXT                  ;YES, REPEAT             
         INT	0A5H                   ;RETURN TO COMAND=

X86CNTZ  ENDS
    END  STRT

