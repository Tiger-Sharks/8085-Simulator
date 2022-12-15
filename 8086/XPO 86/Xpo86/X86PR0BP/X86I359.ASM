       PAGE,80
       TITLE--USING 8259


X868259  	SEGMENT

         	ASSUME CS:X868259, DS:X868259 ,ES:X868259
         	ORG 100H	;COM FORMAT IS RECOMMENDED.

STRT:    JMP 	SKIP_DATA	;SKIP LOOK UP/ DATA BASES IF ANY

;ON KIT YOU NEED TO DO INIT FOR SP [TO SEPARATE STACK OF YOUR PROGRAME FROM
;MONITORS],DS AS SHOWN BELOW.SS,ES ARE SET TO 0000 AT POWER ON BY MONITOR.
;YOU CAN OFCOURSE CHANGE IT BY ADDING A FEW MORE MOVE`S.
;BUT WHILE WORKING ON PC YOU CAN`T TOUCH SEGMENT REGISTERS SINCE THEY ARE
;SET BY DOS LOADER,SO MANAGE THESE INSTRUCTIONS AS SHOWN IN COMMENT FIELD.  
				
MSG1: 	DB "ANSHUMAN",03H  	;Message ANSHUMAN.
MSG2: 	DB "ANSH LC3",03H 	;Message ANSH LC6.
				                                            
SKIP_DATA:
	 MOV	AX,11F0H    
         MOV	SP,AX  		;Init of SP,DS(=CS).ES,SS=0000 
 	 PUSH	CS    		;Fetch Present CS in AX
         POP	AX    		;And Load Into DS Since DS=CS 	
         MOV	DS,AX   
			        
         NOP    	;
         NOP            ;Place CALL in place of 3 NOP`S
         NOP            ;

         MOV	CX,AX         	;Seg addr of ISR for IR3
         MOV	SI,OFFSET ISR 	;Offeset addr  
         MOV	AL,93H	      	;Init of 0000:024BH-50H Bytes so 
			      	;On Interrupt IR3 "INT 93,94..
			      	;are exeuted.
         INT	0BEH                                 
         MOV	AL,13H 	      	;Edge,Single	
			      	;ICW1 A1=0                         
         MOV	DX,9400H                            
         OUT	DX,AL                              
         MOV	AL,90H	      	;ISR of IR0 =INT 90H etc.
         MOV	DX,9402H      	;A1=1	
         OUT	DX,AL 	      	;ICW2	
         MOV	AL,01H	      	;8086,Normal EOI,Non Buffered,
			      	;Non Special,Nest
         OUT	DX,AL	      	;ICW4,A1=1
         MOV	AL,0F7H	      	;Enable IR3.Apply L to H Pulse 
			      	;to IR3 you may use Step switch.
         OUT	DX,AL 	      	;OCW1                             
         STI			;                                   
LOOP1:   MOV	AX,0001H        ;                    
LOOP2:   MOV	CX,0FFFFH       ;                     
         INT	0AAH   	      	;Delay
         DEC	AX              ;                  
         JNZ	LOOP2           ;                    
         INT	0ACH          	;Clear display
         MOV	BX,OFFSET MSG1	;Pointer to "ANSHUMAN"
         INT	0AFH          	;Display message                      
         STI	                                   
         JMP	LOOP1                               
         NOP	                                   
         NOP	                                   
         NOP	                                   

;Now Apply L to H Pulse to IR3 using short link. 8259 will feed INT 93H

;ISR for 8259--IR3.Presently mapped to INT 93H by ICW2.
			         
ISR:    INT	0ACH     	;Clear to new line
        MOV	BX,OFFSET MSG2	;Pointer to message table Ending
				;in ETX
        INT	0AFH 		;Display massage.	
        MOV	AL,20H                              
        MOV	DX,9400H                            
        OUT	DX,AL           ;OCW2--Non Specific
        IRET	                                   


X868259  	ENDS
    	END  	STRT

