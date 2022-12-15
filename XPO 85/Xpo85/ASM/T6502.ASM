;******************************************************
;
; THIS IS AN EXAMPLE PROGRAM FOR THE 6502 PROCESSOR.
; IT IS TAKEN FROM AN ARTICLE BY STEVE CIARCIA ON
; PAGE 34 & 35  OF THE MARCH 1984 ISSUE OF BYTE,,
; AND AFTER ONLY FORMAT MODIFICATIONS FOR CROSS-16,
; IT IS PASSED ON AS AN EXAMPLE, FREE OF CHARGE, BY
; UNIVERSAL CROSS-ASSEMBLERS.

; THERE ARE NO SPECIAL NOTES CONCERNING THE USE OF
; CROSS-16 WITH THE 6502 FAMILY OF MICROPROCESSORS.
; CROSS-16, WILL AUTOMATICALLY CHOOSE THE SHORTEST FORM
; USABLE, FROM ZERO PAGE AND ABSOLUTE ADDRESSING.

          CPU  "6502.TBL"     ; PROCESSOR TABLE
          HOF  "INT8"         ; HEX FORMAT

;******************************************************
;
;  SSI-263 COMPOSITE DATA DRIVER
;
          ORG  8000H
;
;
OUTPTR:   EQU   0FBH          ;POINTER TO START OF DATA
ENDPTR:   EQU   0FDH          ;POINTER TO END OF DATA
BUSY:     EQU   0FFH          ;BUSY FLAG
IRQL:     EQU   03FEH         ;IRQ VECTOR, LOW BYTE
IRQH:     EQU   03FFH         ;IRQ VECTOR, HIGH BYTE
BASE:     EQU   0C440H        ;REGISTER 0 OF SSI-263
DURPHON:  EQU   BASE
INFLECT:  EQU   BASE+01H      ;REGISTER 1 OF SSI-263
RATEINF:  EQU   BASE+02H      ;REGISTER 2 OF SSI-263
CTTRAMP:  EQU   BASE+03H      ;REGISTER 3 OF SSI-263
FILFREQ:  EQU   BASE+04H      ;REGISTER 4 OF SSI-263
;
;
;  SET-UP ROUTINE
;
;
          SEI                 ;DISABLE INTERRUPTS
          LDA   #LOW{INTERR}  ;INTERRUPT SERVICE ROUT.
          STA   IRQL          ;LOW ADDRESS
          LDA   #HIGH{INTERR} ;INTERRUPT SERVICE ROUT.
          STA   IRQH          ;HIGH ADDRESS
;
          LDA   #HIGH{TABLE}  ;DATA TABLE, HIGH ADDRESS
          STA   OUTPTR+1
          STA   ENDPTR+1
          LDA   #LOW{TABLE}   ;DATA TABLE, LOW ADDRESS
          STA   OUTPTR
          LDA   #LOW{TABLE}+32H
          STA   ENDPTR
;
;
          LDA   # 255         ;SET BUSY FLAG
          STA   BUSY
          LDA   # 80H         ;SET SSI-263 TO TRANSI-
          STA   CTTRAMP       ;TIONED INFLECTION MODE
          LDA   # 0C0H
          STA   DURPHON
          LDA   # 70H
          STA   CTTRAMP
          CLI                 ;CLEAR INTERRUPT MASK
          RTS                 ;RETURN TO CALLER
;
;
;  INTERRUPT SERVICE ROUTINE
;
;
INTERR:   TXA                 ;SAVE X REGISTER
          PHA
          TYA                 ;SAVE Y REGISTER
          PHA
          LDY   # 0           ;INIT Y REGISTER
          LDX   # 4           ;INIT X REGISTER
          LDA   OUTPTR        ;CHECK FOR END OF DATA
          CMP   ENDPTR
          BNE   CONT          ;NO, SO CONNTINUE
          LDA   OUTPTR + 1
          CMP   ENDPTR + 1
          BNE   CONT          ;NO, SO CONTINUE
          LDA   # 0           ;END, SO TURN OFF SSI-263
          STA   DURPHON
          LDA   # 70H
          STA   CTTRAMP
          LDA   # 00H         ;RESTORE BUSY FLAG
          STA   BUSY
RET:      PLA                 ;RESTORE Y REGISTER
          TAY
          PLA                 ;RESTORE X REGISTER
          TAX
          LDA   45H           ;RESTORE ACCUMULATOR
          RTI                 ;RETURN FROM INTERRUPT
;
;
CONT:     LDA   (OUTPTR),Y    ;GET DATA
          STA   BASE,X        ;AND PASS IT TO SSI-263
          INC   OUTPTR        ;INCREMENT POINTER
          BNE   CONT1
          INC   OUTPTR + 1
;
CONT1:    DEX                 ;NEXT REGISTER
          CPX   # 0FFH        ;LAST REGISTER?
          BNE   CONT          ;NO, SO CONTINUE
          BEQ   RET           ;EXIT INTERRUPT
;
;
;
;
TABLE:    DFB 0E7H, 03BH, 0A8H, 07AH, 0ACH
          DFB 0E8H, 04DH, 0A8H, 07BH, 0CAH
          DFB 0E8H, 05DH, 0A8H, 074H, 0CAH
          DFB 0E7H, 06CH, 0A8H, 064H, 0E0H
          DFB 0E7H, 07BH, 0A8H, 053H, 0A0H
          DFB 0E7H, 07AH, 0A8H, 05AH, 011H
          DFB 0E7H, 079H, 0A8H, 061H, 063H
          DFB 0E7H, 070H, 0A8H, 060H, 000H
          DFB 0E7H, 070H, 0A8H, 058H, 000H
          DFB 0E7H, 070H, 0A8H, 050H, 000H
;
;
          END
