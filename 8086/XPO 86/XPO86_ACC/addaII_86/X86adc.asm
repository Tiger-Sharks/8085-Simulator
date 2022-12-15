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
                 ORG 100H
         STRT: MOV AX,0000H
               MOV ES,AX                              
               MOV SS,AX                              
               MOV AX,11F0H  ;Init .SP
               MOV SP,AX                              
               PUSH CS       ;Set CS=DS                          
               POP DS                                 
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
               INT 0ACH
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
               MOV AL,0AH
               OUT DX,AL                              
               INT 0ABH
               MOV AL,02H
               MOV DX,CX                              
               NOP	                                   
               MOV DH,00H
               INT 0AEH
               MOV AH,0BH
               INT 0A1H
               AND AL,0FFH
               JZ COVN   ;Start next sample                            
               INT 0A3H     ;Return to monitor
	       ADC ENDS
               END STRT

