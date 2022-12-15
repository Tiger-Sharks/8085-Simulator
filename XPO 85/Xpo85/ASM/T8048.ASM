;******************************************************
;
; THIS IS AN EXAMPLE PROGRAM FOR THE 8048 PROCESSOR.
; IT IS TAKEN FROM PAGE 335 OF THE NOVEMBER 15, 1984
; ISSUE OF EDN, AND AFTER ONLY FORMAT MODIFICATIONS
; FOR CROSS-16, IT IS PASSED ON AS AN EXAMPLE, FREE
; OF CHARGE, BY UNIVERSAL CROSS-ASSEMBLERS.

; THERE ARE NO SPECIAL NOTES CONCERNING THE USE OF
; CROSS-16 WITH THE 8048 FAMILY OF MICROCONTROLLERS.

         CPU     "8048.TBL"     ; CPU TABLE
         HOF     "INT8"         ; HEX FORMAT

;******************************************************
;
; DATA LOGGER SOFTWARE
; BY: WUNNAVA V. SUBBARAO
;     FLORIDA INTERNATIONAL UNIVERSITY, MIAMI, FLORIDA
;
INITIAL:  MOV R0,#10   ;R0 & R1 LOADED WITH #10, WHICH
          MOV R1,#10   ;HAS BLANK CODE LOCATION IN PAGE
START:    CLR A        ;THREE. 
          OUTL P1,A    ;INPUT SHIFT REG IS IN LOAD MODE
          OUTL BUS,A   ;P17 & P16 AT 0.
          CPL C        ;CARRY COMPLEMENTED
          JC DIGIT1
DIGIT0:   MOV A,#00    ;MAKE P20=0 ACTIVATING DIGIT 0
          OUTL P2,A    ;IF CARRY=0 & LOAD R0 INTO A FOR
          MOV A,R0     ;DISPLAY ON DIGIT 0.
          JMP DISPLAY
DIGIT1:   MOV A,#01    ;MAKE P20=1 ACTIVATING DIGIT 1
          OUTL P2,A    ;IF CARRY=1 & LOAD R1 INTO A FOR
          MOV A,R1     ;DISPLAY ON DIGIT 1.
DISPLAY:  MOV P3 A,@A  ;CONTENTS OF CODE TABLE ON PG 3
          OUTL BUS,A   ;PUT ONTO DATA BUS.
          MOV R6,#0FH
DLY1:     DJNZ R6,DLY1 ;DELAY LOOP 1, SMALL DELAY.
          JT1 OTOREG   ;IF T1=1, JUMP TO NEXT LOAD.
          MOV R6,#0FFH ;IF T1=0 PROGRAM CHECKS DEBOUNCE
DLY2:     DJNZ R6,DLY2 ;IF SO, KEEP CHECKING DEBOUNCE.
          JT1 OTOREG   ;OTHERWISE JUMP TO NEXT LOAD.
SERDAT:   MOV A,#80H   ;P17 MADE 1 FOR SHIFT MODE.
          OUTL P1,A
          MOV R3,#04   ;SHIFT CTR R3 INITIALIZED TO 4.
          MOV R4,#00   ;INITIALIZE DATA REGISTER TO 0.
NXTB:     CLR C        ;T0 EXAMINED & T0 CORRESPONDING
RDXIN:    JNT0 SHIFTD  ;DATA BIT IS SHIFTED INTO R4, IF
          CPL C        ;T0=0 (CARRY CLEARED);IF T0=1,
SHIFTD:   MOV A,R4     ;SET CARRY=1, THEN SHIFT INTO R4
          RLC A
          MOV R4,A
CLOCK:    MOV A,#0C0H  ;CLOCK SIGNAL GENERATED ON P16,
          OUTL P1,A    ;KEEPING P17=1 IN SHIFT MODE.
          MOV A,#80H   ;FOR SHIFTING P16 DATA.
          OUTL P1,A
          DJNZ R3,NXTB ;DECREMENT R3 AND CHECK FOR 0 TO
          MOV A,R4     ;SEE IF ALL 4 SHIFTS ARE OVER.
          XRL A,R5     ;IF R4=R5 SIGNIFYING OLD DATA,
          JZ START     ;PROGRAM JUMPS TO START AT 0004
DIGITSH:  MOV A,R4     ;FOR NEW DATA, LOAD R5 WITH
          MOV R5,A     ;CONTENTS OF R4.
          MOV A,R0     ;R0 SHIFTED TO R1.
          MOV R1,A
          MOV A,R4     ;NEW DATA IN R4 SHIFTED TO R0.
          MOV R0,A
          JMP START    ;JUMP TO START FOR NEXT WORD.
OTOREG:   MOV R5,#0FFH ;ONE TIME ONLY REG (R5)=#FF.
          JMP START    ;JUMP TO START FOR NEXT WORD.
;
          ORG    0300H ; TABLE ADDRESS

          DFB    3FH   ;0   D7 D6 D5 D4 D3 D2 D1 D0
          DFB    06H   ;1   dp  g  f  e  d  c  b  a
          DFB    5BH   ;2               a
          DFB    4FH   ;3           ---------
          DFB    66H   ;4           |       |
          DFB    6DH   ;5         f |       | b
          DFB    7DH   ;6           |       |
          DFB    07H   ;7           ---------
          DFB    7FH   ;8           |   g   |
          DFB    6FH   ;9         e |       | c
          DFB    77H   ;A           |       |
          DFB    7CH   ;B           ---------
          DFB    58H   ;C               d
          DFB    5EH   ;D
          DFB    79H   ;E
          DFB    71H   ;F
          DFB    00H   ;BLANK

          END

