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
                 MOV AX,1002H       ;
                 MOV BX,0161H       ;LOAD BX WITH MSG PTR
                                       ;
                 MOV CX,0000H
                 MOV DX,00FFH       ;LOAD DEFAULT VALUE OF HEIGHT
                 INT 0B9H            ;GET HEIGHT FROM USER
                 PUSH DX
                 MOV AX,1002H
                 MOV BX,0168H      ;LOAD BX WITH MSG PTR
                 MOV CX,0000H
                 MOV DX,0001H
                 INT 0B9H
                 MOV DH,00H
                 PUSH DX
                 POP CX
                 POP BX
                 MOV DX,8801H       ;INIT DIGITAL INPUT
          BACK2: MOV AL,00H         ;TO DAC AT 00H
          BACK3: OUT DX,AL          ;FEED DIGITAL I/P TO DAC
                 PUSH CX
                 INT 0AAH
                 POP CX
                 INC AL
                 CMP AL,BL         ;IS REQUIRED HEIGHT ATTAINED?
                 JNZ BACK3         ;IF NO JUMP BACK
          BACK1: OUT DX,AL         ;ELSE FEED I/P TO DAC
                 PUSH CX
                 INT 0AAH
                 POP CX            ;CONSTRUCT FALLING RAMP
                 DEC AL            ;IS BOTTOM REACHED
                 JNZ BACK1         ;IF NO JUMP BACK
                 MOV AH,0BH        ;ELSE CHECK FOR
                 INT 0A1H            ;KEY PRESS
                 AND AL,0FFH       ;IF KEY PRESSED JMP TO
                 JZ BACK2          ;COMMAND MODE ELSE CONTINUE.
                 INT 0A3H
        HEIGHT: DB 48H,45H,49H,47H,48H,54H,03H
        PERIOD: DB 50H,45H,52H,49H,4FH,44H,03H
X86DAC   ENDS
        END STRT

