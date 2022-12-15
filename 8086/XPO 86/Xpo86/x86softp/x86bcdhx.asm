
;***FOLLOWING LISTING IS W.R.T. BATTERY BACKED RAM AT 10000H BUT THIS
;   PROGRAMME CAN WORK IN SCRATCH PAD RAM LOCATED AT 00000H .PL. ENTER
;   THE SAME FROM 0140:0100[0000:1500] AND EXECUTE. 
;*********CONVERTING BCD TO HEX
;----------------------------------------------------------------------
;BCDHEX TRANSLATES THE BCD NUMBER IN  AX TO ITS HEX EQUIVALENT IN AX.
;ON ENTRY AX MUST CONTAIN OR VALID BCD DIGITS, OTHERWISE THE
;RESULTS ARE UNPREDICTABLE.
;	ALL REGISTERS OTHER THAN AX    PRESERVED.
;-----------------------------------------------------------------------
;PASCAL CONSTRUCT-
;var
;	n : integeer;
;	d : array[0..3] of [0..9];
;	i : integer;
;begin
;	n:= 0;
;	for i := 3 down to 0  do
;	    n := 10*n + d[i];
;end.

X86BCDHX	SEGMENT
 	 	 	 	 	 	
ASSUME   CS:X86BCDHX, DS:X86BCDHX, ES:X86BCDHX

ORG 100H      ;Com format is recommended.
	
STRT:   JMP  SKIP_DATA   ;Skip lookup/
                         ;data bases if any

;On kit you need to do init for SP [to separate
;stack of your programme from monitors], DS as 
;shown below. SS, ES are ;set to 0000 at power 
;on by monitor. You can of course change it by 
;adding a few more move's. but while working on 
;PC you can't touch segment registers since they 
;are set by dos loader, ;so manage these 
;instructions as shown in comment field.  
 	 	 	 	
SKIP_DATA:
MOV	AX,10FFH 
MOV	SP,AX   
PUSH	CS      
POP	DS      
NOP	        
NOP	        
NOP	        
MOV	AX,4096H ;BCD NO LOADED HERE
 PUSH	BX                                          
 PUSH	CX                                          
 PUSH	DX                                          
 PUSH	SI                                          
 PUSH	DI                                          
 MOV	SI,000AH ;SOURCE OF CONSTANT 10               
 MOV	CX,0001H ;COUNT                              
 MOV	BX,AX   ;BCD NUMBER IN BX                   
 XOR	DI,DI   ;FORM ANSWER IN DI. FIRST INIT
 PUSH	BX      ; SUM TO 0.                         
 AND	BX,000FH                                     
 ADD	DI,BX   ;RETAIN LOW NIBBLE ONLY             
 POP	BX      ;UNIT PLACE                         
STORE:ROR	BX,01H    ;RESTORE ROTATED BCD NUMBER         
 ROR	BX,01H                                        
 ROR	BX,01H                                        
 ROR	BX,01H    ;GET NEXT DIGT TO RT NIBLE OF B
 PUSH	BX      ;SAVE ROTATED VALUE                 
 PUSH	CX                                          
 AND	BX,000FH ;RETAIN LOW NIBBLE ONLY             
 MOV	AX,BX                                       
 LUP: MUL	SI      ;IN := N*10. PRODUCT  IN DX,AX
 LOOP	LUP    ;DX SHOULD GET NO CARRY.            
 POP	CX                                          
 INC	CX                                          
 ADD	DI,AX                                       
 POP	BX      ;N := N*10 + d[i]                   
 CMP	CX,+04H                                      
 JB	STORE                                        
 MOV	AX,DI   ;REPEAT FOR FOUR BCD DIGITS         
 POP	DI                                          
 POP	SI                                          
 POP	DX                                          
 POP	CX                                          
 POP	BX                                          
 INT	0A5H      ;AX= RESULT / REPLACE HERE 'RET'
					  ;TO MAKE IT CALLABLE		    
X86BCDHX	ENDS
	END	STRT

