

;    ON ENTRY THE VARIABLES V1 AND V2 CONTAIN UNSIGNED INTEGERS. THIS 
;    ROUTINE  RETURNS THE LARGER OF THE TWO IN THE VARIABLE V3.THESE 
;    VARIABLES ARE STORED AT SCPD LOCATIONS 0100:012A,012C,012E [0000:
;    112A,112C,112E].PL.ENTER THEM BY HAND.
;	 		 
X86CUSIN 	SEGMENT
ASSUME CS:X86CUSIN, DS:X86CUSIN ,ES:X86CUSIN 
ORG 100H	      	;Com format 
                      	;is recommended.
STRT:	JMP SKIP_DATA 	;skip look up/ 
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
PUSH	CS      ;INIT FOR DS                          
POP	DS      ;                                      
NOP	                                               
NOP	                                               
NOP	                                              
MOV	AX,0100H                                      
MOV	ES,AX                                         
MOV	AX,ES:[012AH]
CMP	AX,ES:[012CH] ;GET V1 IN AX   
JB	V2L   	      ;GENERATE V1-V2,BUT AX UNCHANGED
   		      ;IF V1 IS BELOW V2 THEN GOTO L10
MOV	ES:[012EH],AX ;V1 IS > V2. MAKE V3= V1 
JMP	END           ;SKIP THE "ELSE" PART                  
        	      ;V2 IS > THAN V1. FETCH IT.      
V2L:MOV	AX,ES:[012CH] ;MAKE V3 := V2                     
        	      ;RETURN TO COMMAND= AFTER            
MOV	ES:[012EH],AX ;SAVING REGISTERS. 
END:INT	0A5H       

X86CUSIN	ENDS 
    END 	STRT
                              
