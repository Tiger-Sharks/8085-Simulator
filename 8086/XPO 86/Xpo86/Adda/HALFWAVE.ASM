  X86DAC   SEGMENT
        ASSUME CS:X86DAC, DS:X86DAC, ES:X86DAC

                ORG 100H               ;REPRESNTS ".COM" FORMAT
           STRT: JMP SKIP_DAT          ;
       SKIP_DAT: MOV AX,0000H
                 MOV ES,AX
                 MOV SS,AX
                 MOV AX,11F0H       ;INIT OF SP
                 MOV SP,AX
                 PUSH CS
                 POP DS            ;SET DS=CS
                 NOP                                        
                 NOP                                        
                 NOP                                        
                 INT 0ACH
                 MOV AL,80H         ;INIT 8255 WITH PORT A,B
                 MOV DX,8807H       ;& C(UPPER) O/P MODE
                 OUT DX,AL
                 
                 MOV CX,0000H
                 MOV DX,000FH       ;LOAD DEFAULT VALUE OF HEIGHT
                 
                 PUSH DX
                 
                 MOV CX,0000H
                 MOV DX,0001H
                
                 MOV DH,00H
                 PUSH DX
                 POP CX
                 POP BX
                 MOV DX,8801H       ;INIT DIGITAL INPUT
            ABC:MOV BX, OFFSET TRING
		  BACK2: MOV AL,CS:[BX]         ;TO DAC AT 00H
          BACK3: OUT DX,AL          ;FEED DIGITAL I/P TO DAC
                 PUSH CX
                 INT 0AAH
                 POP CX
                 CMP AL,0FFH         ;IS REQUIRED HEIGHT ATTAINED?
                 JZ BACK1         ;IF NO JUMP BACK
				 INC BX
				 JMP BACK2
          BACK1: MOV AL,CS:[BX]
		         OUT DX,AL         ;ELSE FEED I/P TO DAC
                 PUSH CX
                 INT 0AAH
                 POP CX            ;CONSTRUCT FALLING RAMP
                 CMP AL,80H
				 
				 JZ ABC         ;IF NO JUMP BACK
                 DEC BX
				 JMP BACK1
				
				 INT 0A3H
        
		TRING:  DB 80H,80H,80H,80H,80H,80H,80H,80H,80H,80H
		        DB 80H,80H,80H,80H,80H,80H,80H,87H,90H,9AH
				DB 0A4H,0AEH,0B6H,0C7H,0CEH,0D8H,0E1H,0E9H
				DB 0F0H,0F6H,0FBH,0FEH,0FFH,03H
				
				
							
X86DAC   ENDS
        END STRT

