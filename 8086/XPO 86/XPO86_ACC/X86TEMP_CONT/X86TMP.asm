;8 bit ADC 0809 (SUCCESIVE APPROX. METHOD), 100 microsec.
;convertion time is used to convert voltage signal 
;simulated by on board pot. It provided varying voltage 
;0 to 5v,connected to channel no.1. Processor interface 
;is provided via 26 pin FRC.
             ADC SEGMENT
             ASSUME CS:ADC
                CR55 EQU 8807H
                PORTB EQU 8803H
                PORTC EQU 8805H
                PORTA EQU 8801H
                 ORG 100H
         STRT:
         JMP SKIP_DAT
               MSG1: DB "HITEMP",03H
               MSG2: DB "LOTEMP",03H
               HITEMP DB 0
               LOTEMP DB 0
               TEMPREAD DB 0
               TEMPSET DB 0
               JUMP DB 0
               SETPT DB 0
                         
         SKIP_DAT:
               MOV AX,0000H
               MOV ES,AX                              
               MOV SS,AX                              
               MOV AX,11F0H  ;Init .SP
               MOV SP,AX                              
               PUSH CS       ;Set CS=DS                          
               POP DS

BCK:           INT 0ACH     ; CLEAR
               MOV BX,OFFSET MSG1
               INT 0AFH     ;DISPLAY HITEMP
               MOV CX,0000H
               MOV DX,0066H
               MOV AL,02H
               MOV AH,10H   ;HEX NO.
               INT 0ADH     ;READ K/B
               MOV AL,30H   ;RECEIVE NO.
               CMP AL,DL
               JC DO
               JMP BCK
           DO: XCHG BL,DL
               PUSH BX
               INT 0ACH     ;CLR
               MOV BX,OFFSET MSG2
               INT 0AFH     ;DISPLAY LOTEMP
               MOV CX,0000H
               MOV DX,0062H
               MOV AL,02H
               MOV AH,10H   ;DECIMAL NO.
               INT 0ADH     ;READ K/B
               INT 0ACH     ;CLR
               POP BX
               MOV AL,BL
               MOV HITEMP,AL      ;HIGH SETPT
               MOV AL,DL
               MOV LOTEMP,AL      ;LOW SETPT
        DSPLY: JMP DISPLAY
        EXPT3: MOV AL,TEMPREAD    ;LDOSB TEMPREAD
               MOV CL,AL
               MOV AL,HITEMP      ;LODBS HITEMP
               CMP AL,CL
               JNC LOWER
        SET30: MOV AL,0FFH
               MOV TEMPSET,AL     ;TEMPSET FF
               JMP DSPLY
        LOWER: MOV AL,LOTEMP
               CMP AL,CL
               JC DSPLY
               MOV AL,00H
               MOV TEMPSET,AL     ;FOR DAC
               JMP DSPLY
;ADC CONVERSION

      DISPLAY: MOV DX,CR55  ;Init port A,B
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
               MOV DX,PORTA
               MOV AL,TEMPSET ;OUT TO DAC
               OUT DX,AL
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
               MOV CL,AL                              
               MOV DX,CR55      
               MOV AL,0AH   ;O/P DISABLE
               OUT DX,AL
               INT 0ABH      ;CRONLY
               MOV DL,CL
               MOV TEMPREAD,DL   
               NOP
               MOV AL,02H
               MOV DH,00H
               INT 0AEH      ;NMOUT
               MOV AH,0BH
               INT 0A1H      ;READ K/B
               CMP AL,00H
               JNZ EXIT
               MOV CX,01FFH
               INT 0AAH     ;CALL DELAY
               JMP EXPT3    
        EXIT:  INT 0A3H     ;COMMAND MODE
        ADC ENDS
               END STRT







