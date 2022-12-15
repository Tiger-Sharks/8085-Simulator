;8 bit ADC 0809 (SUCCESIVE APPROX. METHOD), 100 microsec.
;convertion time is used to convert voltage signal 
;simulated by on board pot. It provided varying voltage 
;0 to 5v,connected to channel no.1. Processor interface 
;is provided via 26 pin FRC.
        CPU "8085.TBL"
        HOF "INT8"
        CR55:EQU 0BH
        PORTB:EQU 09H
        PORTC:EQU 0AH
	PORTA:EQU 08H
        OUTMSG:EQU 03D8H
        CRONLY: EQU 0497H
        RCVNO:EQU 0476H
        CRLF:EQU 048AH
        DELAY:EQU 0615H
        TEST:EQU 01F1H
	CMDMOD:EQU 000CH

ORG 7F10H
        LXI H,RST75  ;HL<=ISR addr
        SHLD 205EH   ;Store ISR addr
        MVI A,1BH    ;of RST 7.5 at
        SIM          ;vector address
        MVI A,0B6H   ;Initialise 8253
        OUT 1BH      ;as interrupt generator
        MVI A,0B0H   ;at every 200msec
        OUT 1AH
        MVI A,02H
        OUT 1AH
  ADC:LXI H,DBAS1    ;message pointer
        CALL CRLF    ;clear display
        CALL OUTMSG  ;display message
        MVI A,81H    ;Init 8255 port A,B
        OUT CR55     ;C(upper) as OP
        MVI A,00H    ;Select channel 0
        OUT PORTB
        MVI A,09H    ;Set PC4(ALE) high
        OUT CR55
        MVI A,08H   ;Reset PC4(latched)
        OUT CR55    ;pulse for ALE pin
        MVI A,83H   ;Set port B as IP
        OUT CR55    ;keeping rest same
        LXI H,2100H ;Init memory pointer
 START: MVI C,00H   ;C is used as a flag
        EI          ;enable interrupt
        MVI A,0DH   ;Set PC6(start convertion)
        OUT CR55
        MVI A,0CH   ;Reset PC6.
        OUT CR55
   BACK:IN PORTC    ;Read portC status
        ANI 02H     ;Check PC3(end of convertion)
        JNZ BACK
   BACK1:IN PORTC
        ANI 02H     ;To ckeckPC1 high
        JZ BACK1    ;If yes ,Read data
        MVI A,0BH   ;Set OP enable
        OUT CR55
        IN 09H      ;Read digital OP data
        MOV M,A
        MVI A,0AH   ;OP disable.PC5=0
        OUT CR55
        INX H       ;Increment memory pointer
        MOV A,L
        CPI 00H     ;check whether the
        JNZ CHECK   ;last memory location
        MOV A,H     ;where digital data
        CPI 7FH     ;is stored is reached
        JNZ CHECK   ;if not zero jump to check
        JMP TOP     ;if zero start DAC
CHECK:  MOV A,C     ;wait till interrupt
        CPI 0FFH    ;occurs
        JNZ CHECK   ;if unterrupt occurs
        JMP START   ;jump to start of ADC

;DAC starts

TOP:    CALL CRLF   ;clear display
        LXI H,DBAS2 ;message pointer
        CALL OUTMSG ;display message
        LXI H,2100H ;initialise memory pointer
        MVI A,80H   ;init 8255 port A,B,C in
                    ;output mode
        OUT CR55
        MVI A,00H   ;select digital gain
        OUT PORTC   ;for LS Amplifier
AGAIN:  MVI C,00H   ;flag for interrupt
        EI          ;enable interrupt
        MOV A,M     ;transfer contents of
        OUT PORTA   ;memory location to DAC
        INX H       ;Increment memory pointer
        MOV A,L     ;check whether last memory
        CPI 00H     ;location is reached
        JNZ SELF    ;jump if not reached
        MOV A,H     ; to self
        CPI 7FH
        JNZ SELF
        CALL TEST   ;check for key press
        JC TOP      ;no key,start DAC
        MOV D,A     ;check whether"A" is
        CPI 41H     ;pressed
        JZ ADC      ;if A is pressed start ADC
        MOV A,D     ;if key "Esc" is
        CPI 1BH     ;pressed jump to
        JZ END      ;command mode.
SELF:MOV A,C        ;check whether
        CPI 0FFH    ;interrupt has
        JNZ SELF    ;has occured
        JMP AGAIN
   RST75:DI         ;ISR routine for
         MVI C,0FFH ;RST 7.5 to set C
         RET
END:RST 1           ;command mode
DBAS1:DFB 41H       ;DBASE to display "ACQUIRE"
      DFB 43H
      DFB 51H
      DFB 55H
      DFB 49H
      DFB 52H
      DFB 45H
      DFB 03H
DBAS2:DFB 52H       ;DBASE to display "REPLAY"
      DFB 45H
      DFB 50H
      DFB 4CH
      DFB 41H
      DFB 59H
      DFB 03H
