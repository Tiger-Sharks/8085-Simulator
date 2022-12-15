;***********************************************************
;
; THIS IS AN EXAMPLE PROGRAM FOR THE 8085 PROCESSOR.
; IT IS TAKEN FROM PAGE 84 OF THE JANUARY 1980 ISSUE
; OF BYTE, AND AFTER ONLY FORMAT MODIFICATIONS FOR CROSS-16,
; IT IS PASSED ON AS AN EXAMPLE, FREE OF CHARGE, BY
; UNIVERSAL CROSS-ASSEMBLERS.

; THERE ARE NO SPECIAL NOTES CONCERNING THE USE OF
; CROSS-16 WITH THE 8085 FAMILY OF MICROPROCESSORS.

         CPU     "8085.TBL"    ;CPU TABLE
         HOF     "INT8"        ;HEX FORMAT

;***********************************************************
;
; FURNACE WATCHDOG
; WRITTEN BY T. WIERENGA, FEB. 1978
;
; READ HOURS,MINUTES,SECONDS
;
TTOP:    EQU     189DH
         ORG     2F00H
S1:      CALL    TTOP          ; READ CLOCK
         LDA     2254H         ; STORE IN MEMORY
         JMP     MASK          ; GET TENS HOURS
S2:      LDA     2255H         ; GET UNITS HOURS
         JMP     MASK
S3:      LDA     2256H         ; GET TENS MINUTES
         JMP     MASK
S4:      LDA     2257H         ; GET UNITS MINUTES
         JMP     MASK
S5:      LDA     2258H         ; GET TENS SECONDS
         JMP     MASK
S6:      LDA     2259H         ; GET UNITS SECONDS
MASK:    ANI     00FH
         MOV     L,A           ; RETURN VALUE IN H,L
         MVI     H,0
         RET
; READ INPUT PORT 13 (0DH)
; 0=FURNACE OFF, 1=OsN
;
         IN      13
         ANI     1            ; LSB ONLY USED
         MOV     L,A          ; RETURN VALUE IN H,L
         MVI     H,0
         RET

         END
