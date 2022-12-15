;Stepper motor interface has been provided through 8255 via 26 pin
;FRC cable.Motor can be rotated clockwise or anticlock wise direction 
;depending on the content of the location of sequense. Acceleration-
;Deacceleration process is also implemented.'STEPR' is a subroutine 
;which actually outputs the phase seq. code to the stepper using lookup table.
;Enter the speed from 1000h to ffffh, do not enter speed below 1000h

             CPU 8085
	   PORTA: EQU 08H
        CR55: EQU 0BH
        READ: EQU 2075H
	   DELAY: EQU 0615H
	    CRLF: EQU 048AH
	  OUTMSG: EQU 03D8H
	  CMDMOD: EQU 000CH
	    NMIN: EQU 0405H 
         ESC: EQU 1BH
              ORG 71D2H
       START: LXI SP,2100H ;Init. stack pointer
              MVI A,80H    ;Init. 8255 ports
              OUT CR55     ;A,B,C as OP ports
              MVI A,00H	  ;OP disable code to 
              OUT PORTA    ;stop motor
	          LXI H,SPEED
			  CALL CRLF
			  CALL OUTMSG
			  MVI B,04H
			  MVI C,10H
			  CALL NMIN
	  DISPLY: CALL CRLF ;CLEAR DISPLAY
		      LXI H,DIR
			  CALL OUTMSG ;display message for dir
	 RDAGAIN: CALL READ
	          MOV B,A
			  CPI 46H ;check for forward dir
			  JNZ RVD ; if not go to reverse dir
			  MVI A,01H ; forward dir
			  STA 20A0H
			  LXI H,MSG1
			  CALL OUTMSG ;display F for forward dir
			  JMP MSG
		 RVD: MOV B,A
		      CPI 52H ;check for reverse dir 
			  JZ SKIP1
			  CPI ESC  ; is ESC key is pressed
              JNZ RDAGAIN ;if not read again
			  JMP CMDMOD
	   SKIP1: MVI A,00H
		      STA 20A0H
			  LXI H,MSG2   ;display R for reverse dir
			  CALL OUTMSG
		 MSG: CALL CRLF
			  LXI H,DRIVE
			  CALL OUTMSG  ;display message for drive selection
		  HF: CALL READ
			  MOV B,A
			  CPI 46H       ;check for full step drive
			  JNZ HALF     ;if not go to half step drive
			  LXI H,MSG1
			  CALL OUTMSG  ;display F for full step drive
			  LXI H,TABLE1
			  JMP SKIP2
		HALF: MOV B,A
		      CPI 48H       ;is half step drive
			  JNZ SKIP     ;if not go to wave drive
			  LXI H,MSG3    ;display H for half step drive
			  CALL OUTMSG
			  LXI H,TABLE ;PTR for phase seq.
			  JMP SKIP2
		SKIP: MOV B,A
			  CPI 57H     ;check for wave drive
			  JZ SKIP3
			  CPI ESC
			  JNZ HF
			  JMP CMDMOD
	   SKIP3: LXI H,MSG4
			  CALL OUTMSG
	          LXI H,TABLE2
       SKIP2: MVI C,10H    ;To set 0.25 sec. step
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
       TABLE: DB 00H,02H,06H,04H,0CH,08H,09H,01H,03H,00H
              
;Phase code table for FULL step drive.
	  TABLE1: DB 00H,06H,06H,0CH,0CH,09H,09H,03H,03H,00H
		      
;Phase code table for Wave drive.
	  TABLE2: DB 00H,02H,02H,04H,04H,08H,08H,01H,01H,00H
					
       SPEED: DB 53H,50H,45H,45H,44H,20H,03H ; 'SPEED'
           	
		 DIR: DB 44H,49H,52H,20H,20H,46H,2FH,52H,03H ;'DIR  F/R'
; code to display message'HALF/FULL/WAVE'	      
	   DRIVE: DB 48H,41H,4CH,46H,2FH,46H,55H,4CH,4CH,2FH,57H,41H,56H,45H,03H 
		      			
		MSG1: DB 20H,46H,03H ; F
		      
		MSG2: DB 20H,52H,03H ; R
		      
		MSG3: DB 20H,48H,03H ; H
		      
		MSG4: DB 20H,57H,03H ; W
		      
