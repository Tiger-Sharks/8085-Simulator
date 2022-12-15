       PAGE,80
       TITLE-- 10. Using NMI For RTC.


	
X86NMIRTC       SEGMENT
						
                ASSUME CS:X86NMIRTC, DS:X86NMIRTC ,ES:X86NMIRTC
                ORG 100H              ;COM FORMAT IS RECOMMENDED.

STRT: 		JMP SKIP_DATA         ;SKIP LOOK UP/ DATA BASES IF ANY

;ON KIT YOU NEED TO DO INIT FOR SP [TO SEPARATE STACK OF YOUR PROGRAME FROM
;MONITORS],DS AS SHOWN BELOW.SS,ES ARE SET TO 0000 AT POWER ON BY MONITOR.
;YOU CAN OFCOURSE CHANGE IT BY ADDING A FEW MORE MOVE`S.
;BUT WHILE WORKING ON PC YOU CAN`T TOUCH SEGMENT REGISTERS SINCE THEY ARE
;SET BY DOS LOADER,SO MANAGE THESE INSTRUCTIONS AS SHOWN IN COMMENT FIELD.  
				
SKIP_DATA:
	MOV     AX,10FFH  	;INIT OF SP FOR KIT
	MOV     AX,AX     	;MOV AX,AX   ON PC
       	PUSH    CS        	;INIT FOR DS
        POP     DS  
				;LOAD KIT INTS (A0-BF) IN PC USING
        NOP             	;
        NOP               	;PLACE CALL IN PLACE OF 3 NOP`S
        NOP               	;
        MOV 	AX,0000H      	;ES IS USED AS SCPD TO 
        NOP               	;STORE DATA.
       	MOV 	ES,AX

        INT 	0ACH            ; Clear display
       	MOV 	AL,00H          ; Store 00H on Start.
        MOV 	ES:[1000H],AL 	; Hour cntr = 0
	MOV 	ES:[1001H],AL 	; Min  cntr  =0
	MOV 	ES:[1002H],AL	; Sec  cntr = 0 
	MOV 	ES:[1003H],AL	; Set  Flag  
        MOV 	ES:[1004H],AL  	; Set Intr, Check Counter
                             	; be stored at vector addr.
        	                ; location of NMI where 
        	               	; control goes when NMI
        PUSH 	CS
       	POP  	CX              ; Segment addr for ISR 
       	MOV 	SI,OFFSET ISR 	; Load ISR addr.
       	MOV 	AL,02H 		; init of 0000:0008H to 000BH
              			; NMI is type 02H interrupt.
       	INT 	0BEH       	;
      	MOV 	AL,7EH 	  	; CW for 8253
        MOV 	DX,8C07H	;
        OUT 	DX,AL  		;
        			
        MOV 	AL,24H 		; LSB for cntr1 
        MOV 	DX,8C03H 	;
        OUT 	DX,AL  	 	; of 8253

     	MOV 	AL,0F4H  	; MSB for cntr1
	MOV 	DX,8C03H	;
  	OUT 	DX,AL    	; of 8253

   	JMP 	DSPLY   	; jmp to display

LOOP1: 	MOV 	AL,ES:[1003H]   ; Load flag
        CMP 	AL,00H    	; Is 1 Sec over?
        JZ 	LOOP1       	; if not go back
   	                        ; Load sec after 
 	MOV 	AL,ES:[1002H]   ; 1 sec
   	ADD 	AL,01H    	; Add 1 to sec.
     	DAA    	        	; 
     	CMP 	AL,60H   	; Is 1min over?
    	JZ 	NXT1   	        ; If yes goto NXT1
          	                ; If no store sec.
	MOV 	ES:[1002H],AL	;
        MOV 	AL,00H          ; Reset  flag to 0 
	MOV 	ES:[1003H],AL	;
  	JMP 	DSPLY   	; JMP to display

NXT1:  	MOV 	AL,00H          ; As 1 Min over
	MOV 	ES:[1002H],AL   ; Sec cntr  00 
 	MOV 	AL,ES:[1001H]   ; Increment Min
   	ADD 	AL,01H    	; cntr by 1
  	DAA     	        ;
  	CMP 	AL,60H     	; Is 1 hour over?
   	JZ 	NXT2    	; If  yes goto
                                ; NXT2
   	MOV 	ES:[1001H],AL   ; If no store min
    	MOV 	AL,00H          ; Reset flag to 0
   	MOV 	ES:[1003H],AL	;
        JMP 	DSPLY     	; JMP to display

NXT2:   MOV 	AL,00H          ; Min cntr  00
        MOV 	ES:[1001H],AL 	;
        MOV 	AL,ES:[1000H]	; 
        ADD 	AL,01H          ; Increment min  
               			; cntr by 1
        DAA                  	;  
      	CMP 	AL,13H          ; If 12 Hrs over?
      	JZ 	END             ; If yes JMP to
                                ; END
        MOV 	ES:[1000H],AL   ; If no store Hrs.  
        MOV 	AL,00H          ; Reset flag to 0
        MOV 	ES:[1003H],AL 

DSPLY:  MOV 	DL,20H  	; Set cursor  
        MOV 	AH,02H    	; using write.  
	INT 	0A2H    	; leftmost postn.

      	MOV 	AL,02H   	; Display 2 digit
        MOV 	DL,ES:[1000H]   ; Load Hrs cntr
        INT 	0AEH            ; Display Hrs on 
           			; Display.
       	MOV 	DL,20H     	; Set cursor to 
        MOV 	AH,02H     	; 4th char. Postn.
        INT 	0A2H		;

        MOV 	AL,02H          ; Display 2 digit
        MOV 	DL,ES:[1001H]   ; Load min cntr
      	INT 	0AEH           	; Display min on 
       			        ; Display.
        MOV 	DL,20H   	; Set cursor to
        MOV 	AH,02H   	; 7th char. Postn.
        INT 	0A2H		; 
 				         
        MOV 	AL,02H          ; Display 2 digit
        MOV 	DL,ES:[1002H]   ; Load sec cntr
      	INT 	0AEH           	; Display sec on 
       			        ; Display.
        INT 	0ABH      	; Bring cursor to
                        	; 1st position.                                    	
        MOV 	AH,0BH		;          
        INT 	0A1H  		; Check for key 
        CMP 	AL,00H    	; press, if no key   
        JNZ 	END      	; start counting,
        MOV 	BX,OFFSET LOOP1	; Jump to loop
        JMP 	BX  		;
          
END:    MOV 	AL,76H 		; If key stop 
        MOV 	DX,8C07H	;
        OUT 	DX,AL  		; counter & jmp
        INT 	0A4H		; to CMD mode. 
        NOP          		;

ISR     PROC 	NEAR
        PUSH 	AX           	; Save AX
        MOV 	AL,ES:[1004H]	;
        INC 	AL            	;
        CMP 	AL,28H   	; 25ms * 28H =1sec
        JNZ 	SKIP1 	       	; jmp to SKIP1
        MOV 	AL,00H     	;
        MOV 	ES:[1004H],AL	; reset INTR chk 
        MOV 	AL,01H    	; counter to 0
        MOV 	ES:[1003H],AL   ; set flag cntr =1
        JMP 	SKIP3          	; jmp to SKIP3
SKIP1:  MOV 	ES:[1004H],AL  	; store INTR chk counter 
SKIP3:	POP AX     	        ;
        IRET                   	; return.

ISR     ENDP 
         
X86NMIRTC 	ENDS
      END   	STRT

	


    