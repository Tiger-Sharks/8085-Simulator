
       PAGE,100
       TITLE-- VOICE SAMPLING AND REPLAY

X86VOICE  	SEGMENT

         	ASSUME CS:X86VOICE, DS:X86VOICE,ES:X86VOICE
         	CR55 EQU 8807H
                PORTA EQU 8801H
		PORTB EQU 8803H
                PORTC EQU 8805H
ORG 100H	;COM FORMAT IS RECOMMENDED.

STRT: 	JMP 	SKIP_DATA      	;SKIP LOOK UP/ DATA BASES IF ANY

MSG1:  DB "ACQUIRE ",03H
MSG2:  DB "REPLAY ",03H
MSG3:   DB "PRESS A OR ESC ",03H
;ON KIT YOU NEED TO DO INIT FOR SP [TO SEPARATE STACK OF YOUR PROGRAME FROM
;MONITORS],DS AS SHOWN BELOW.SS,ES ARE SET TO 0000 AT POWER ON BY MONITOR.
;YOU CAN OFCOURSE CHANGE IT BY ADDING A FEW MORE MOVE`S.
;BUT WHILE WORKING ON PC YOU CAN`T TOUCH SEGMENT REGISTERS SINCE THEY ARE
;SET BY DOS LOADER,SO MANAGE THESE INSTRUCTIONS AS SHOWN IN COMMENT FIELD.  

SKIP_DATA :	MOV	AX,11F0H    
         MOV	SP,AX  		;Init of SP,DS(=CS).ES,SS=0000 
 	 PUSH	CS    		;Fetch Present CS in AX
         POP	AX    		;And Load Into DS Since DS=CS 	
         MOV	DS,AX   
			        
         NOP    	;
         NOP            ;Place CALL in place of 3 NOP`S
         NOP            ;

         MOV	CX,AX         	;Seg addr of ISR for IR0
         MOV 	AL,0B6H 	;Init the 8253 in 
        MOV 	DX,8C07H	;counter 2 mode 3
        OUT 	DX,AL		;
        MOV     AL,0B0H          ;Load LSB count of
        MOV 	DX,8C05H	;timer for 1KHz freq.
        OUT     DX,AL
        MOV     AL,02H          ;Load MSB count of
        OUT 	DX,AL		;timer for 1KHZ freq. 
        MOV	SI,OFFSET ISR 	;Offeset addr  
         MOV	AL,93H	      	;Init of 0000:0258H-5BH Bytes so 
			      	;On Interrupt IR6 "INT 96,97..
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
         MOV	AL,0F7H	      	;Enable IR6.Apply L to H Pulse 
			      	;to IR3 you may use Step switch.
         OUT	DX,AL 	      	;OCW1                             
     
	 STADC:INT 0ACH     	;Clear to new line
	       MOV BX,OFFSET MSG1	;Pointer to message table Ending
				;in ETX
               INT 0AFH 		;Display massage.	
	       MOV DI,2000H
               MOV DX,CR55  ;Init port A,B
               MOV AL,81H    ;C(upper) as OP
               OUT DX,AL    ;C(lower) as IP                          
               MOV DX,PORTB
               MOV AL,00H
               OUT DX,AL                              
               MOV DX,CR55
               MOV AL,09H    ;Set PC4(ALE) bit
               OUT DX,AL    ;high                          
               MOV AL,08H    ;Set PC4 bit to
               OUT DX,AL    ;latch                          
               MOV AL,83H    ;Set portB as IP
               OUT DX,AL    ;rest same as before                          
         START: MOV BL,00H
         COVN: MOV DX,CR55  ;Set PC6(start of
               MOV AL,0DH    ;convertion)
               OUT DX,AL                              
               MOV AL,0CH
               OUT DX,AL                              
               MOV DX,PORTC
          BACK:IN AL,DX    ;Check PC1(EOC) low                          
               AND AL,02H    ;to insure convertion
               JNZ BACK                               
       COVNCHK:IN AL,DX    ;Convertion really                          
               AND AL,02H    ;Completed
               JZ COVNCHK  ;Yes, then set                          
               MOV AL,0BH    ;PC5(OE) to read
               MOV DX,CR55
               OUT DX,AL                              
               MOV DX,PORTB ;Read digital data
               IN AL,DX                              
               MOV ES:[DI],AL;Store at ES:[DI]
               MOV DX,CR55   ;
               MOV AL,0AH    
               OUT DX,AL                              
           	INC DI	     ;Chcek for last location
               CMP DI,0FFF0H
                STI	     ;if not wait for interrupt
                JNZ LOOP1
                JMP DACST    ;if yes start DAC

LOOP1:   CMP BL,0FFH
         JNZ LOOP1
         CLI
         JMP   START

;DAC starts here

DACST:  INT 0ACH        ;Clear to new line
        MOV BX,OFFSET MSG2  ;Pointer to message table Ending
				;in ETX
        INT 0AFH            ;Display massage.
	INT 0ACH            ;Clear to new line

	MOV BX,OFFSET MSG3	;Pointer to message table Ending
				;in ETX
	INT 0AFH                ;Display massage.
DACAG:  MOV DI,2000H
        MOV AL,80H         ;INIT 8255 WITH PORT A,B
        MOV DX,8807H       ;& C(UPPER) O/P MODE
        OUT DX,AL
        MOV AL,00H	;Give digital code for
        MOV DX,PORTC    ;gain selection of 
        OUT DX,AL	;LS amplifer
AGAIN:MOV BL,00H	;set a flag
	MOV AL,ES:[DI]	;read digital data
	MOV DX,PORTA	;from memory to 
	OUT DX,AL	;convert it to Analog data
	INC DI		;increment pointer and 
	MOV AX,DI	;check whether last location
	CMP AX,0FFF0H	;is reached.
	STI		;set interrupt
	JNZ SELF	;if not wait for interrupt 
        CLI
        MOV AH,0BH	;ckeck for key press
        INT 0A1H	;if no key is pressed
        CMP AL,0FFH	;start DAC again
        JNZ DACAG	;else check whether
        MOV AH,08H	;key A is pressed
        INT 0A1H	;if A is pressed start ADC
        CMP AL,41H	;if key Esc is pressed go
        JNZ  L2		;to command mode.
        JMP STADC
      L2:  CMP AL,1BH
        JNZ DACAG
        JMP ENDPGM
SELF: MOV AL,BL
	 CMP AL,0FFH                          
        JNZ SELF
         CLI
         JMP AGAIN
ENDPGM:INT 0A3H
;ISR for 8259--IR6.Presently mapped to INT 96H by ICW2.
			         
ISR:    CLI
        MOV BL,0FFH
        MOV     AL,20H
        MOV	DX,9400H                            
        OUT	DX,AL           ;OCW2--Non Specific
        IRET	                                   

X86VOICE   ENDS
    	END  	STRT

