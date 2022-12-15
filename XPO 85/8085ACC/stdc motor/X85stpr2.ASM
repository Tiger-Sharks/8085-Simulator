;Stepper motor interface has been provided through 8255 via 26 pin
;FRC cable.Motor can be rotated clockwise or anticlock wise direction 
;depending on the content of the location of sequense. Acceleration-
;Deacceleration process is also implemented.'STEPR' is a subroutine 
;which actually outputs the phase seq. code to the stepper using lookup table.


             CPU 8085
	   PORTA: EQU 08H
        CR55: EQU 0BH
        READ: EQU 2075H
	   DELAY: EQU 0615H
	    CRLF: EQU 048AH
	  OUTMSG: EQU 03D8H
	  CMDMOD: EQU 000CH
        ESC:  EQU 1BH
             ORG 71D2H
       START: LXI SP,2100H ;Init. stack pointer
             MVI A,80H    ;Init. 8255 ports
             OUT CR55     ;A,B,C as OP ports
             MVI A,00H	  ;OP disable code to 
             OUT PORTA    ;stop motor
	 DISPLY: CALL CRLF ;CLEAR DISPLAY
			 LXI H,DIR
			 CALL OUTMSG ;display message for dir
	 RDAGAIN: CALL READ
	         MOV B,A
			 CPI 46H
			 JNZ RVD
			 MVI A,01H
			 STA 20A0H 
			 JMP SKIP
		 RVD: MOV B,A
		     CPI 52H
			 JZ SKIP1
			 CPI ESC
             JNZ RDAGAIN
			 JMP CMDMOD
		SKIP1: MVI A,00H
		     STA 20A0H
        SKIP: LXI H,TABLE  ;PTR for phase seq.
             MVI E,10H    ;table top
             MVI D,20H    ;Init delay counter
             MVI C,10H    ;To set 0.25 sec. step
       BACK1: MVI B,08H    ;ACLR-DCLR loop count
       BACK: CALL STPR     ;Half step drive
            CALL DELAY    ;Output one seq. code
            DCR	B         ;Min speed, Max speed
            JNZ	BACK	 
            DCR	D	  ;Decrease delay to ACCN.
            DCR	C	  ;Count doun for ACCN. phase
            JNZ	BACK1	  ;At count 0 Max. speed
            MVI	B,11H	  ;Fix duration step count
      BACK2: CALL STPR	  ;HL apropriate points
            CALL DELAY	  ;in phase seq. table
            DCR	B         ;DeACCN. phase start
            JNZ	BACK2	 
            MVI	C,10H	  ;DeACCN. count
      BACK3: MVI	B,08H
         L1: CALL STPR
            CALL DELAY
            DCR	B
            JNZ	L1	  ;Increase delay to cause
            INR	D	  ;DeACCN.
            DCR	C
            JNZ BACK3      ;DeACCN. phase ends here.
            MVI A,00H     ;Output disable code to
            OUT PORTA     ;stop motor
            CALL READ     ;Any key pressed?
            CPI 1BH       ;Is ESC key pressed
            JNZ START     ;If yes begin rotation
            RST 1         ;Again return to command mode
 
;STPR Routine
;HL pointer is used for phase code table and direction location
;It outputs phase code and adjest HL appropriatly.
      STPR: PUSH D
           MOV A,M       ;Fetch phase code
           OUT PORTA
           LDA 20A0H
          CPI 01H       ;Jump to clockwise if zero
          JNZ NEXT      ;flag not set
          INX H         ;Other wise go for anti-
          MOV A,M       ;clock wise
          CPI 00H       ;Check for OFF code
          JNZ NEXT1     ;Jump if not end of table
          MVI D,0FFH    ;Subtract 08.
          MVI E,0F8H
   REPEAT: DAD D
    NEXT1: POP D
          RET
     NEXT: DCX H        ;For clockwise.
          MOV A,M
          CPI 00H      ;Check for end of table
          JNZ NEXT1    ;Jump to continue if not
          MVI D,00H    ;Else add 08 to begine.
          MVI E,08H
         JMP REPEAT
;Phase code table for Half step drive.
          TABLE: DB 00H
                DB 02H
	            DB 06H
                DB 04H
                DB 0CH
                DB 08H
                DB 09H
                DB 01H
                DB 03H
                DB 00H
		    DIR: DB 44H
			    DB 49H
				DB 52H
				DB 20H
				DB 20H
				DB 46H
				DB 2FH
				DB 52H
				DB 03H
