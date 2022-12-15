                ;programm for speed control of dc motor
                CPU "8085.TBL"
                HOF "INT8"
                CRLF:EQU 048AH
                ESC:EQU 1BH
                CMDMOD:EQU 000CH
                OUTMSG:EQU 03D8H
                 DIRFR:EQU 75B1H
                 DELAY:EQU 0615H
                  NMIN:EQU 0405H
                  READ:EQU 2075H

                ORG 74C0H
                LXI SP,2100H
                MVI A,80H         ;Set all ports of 8255 as OP ports
                OUT 0BH
         BACK2: CALL CRLF         ; Clear display
                LXI H,DIR         ;Initialise the mem. ptr to display i.e DIR F/D
                CALL OUTMSG       ;Display DIR F/R message
       RDAGAIN: CALL READ         ;Read selection Key  i.e F or R
                MOV B,A           ;Is forward direction selected?
                CPI 46H           ;If not jump to check reverse
                JNZ RVD           ;
                MVI A,01H         ;If Yes set PC0 to 1
                STA DIRFR         ;store at DIRFR
                JMP DISPLY        ;and jump to display SPEED
           RVD: MOV A,B           ;
                CPI 52H           ;Is reverse direction selected?
                JZ NEXT           ;If yes goto NEXT
                CPI ESC           ;Is ESC pressed
                JNZ RDAGAIN       ;If not ESC then goto read key again
          STOP: MVI A,80H         ;if yes initialise 8255 and goto
                OUT 0BH           ;command. This is necessary to stop
                JMP CMDMOD        ;motor if it is running.
          NEXT: MVI A,02H         ;Set PC1 for reverse direction
                STA DIRFR         ;and store at DIRFR
        DISPLY: LXI H,SPEED       ;Initialise mem.ptr to display pointer
                CALL CRLF         ;Clear display
                CALL OUTMSG       ;Display SPEED message
                MVI B,02H         ;Load B for read two digit
                MVI C,0AH         ;Load C for read decimal nos.
        GETDEC: CALL NMIN         ;Call routine to read two digits from
                                  ;user. (only last two digits are accepted)
                MOV A,E           ;get received byte in accumulator.
                JC GETDEC         ;if received key is not decimal
                                  ;number then goto read decimal number.
                CPI 50H           ;If speed is less than 50
                JC INVERT         ;Jump to invert routine
                LDA DIRFR         ;If more than 50 then set PC3
                ORI 08H           ;i.e. direction bit and out
                OUT 0AH           ;PORT C of lower 8255.
                JMP WAVE          ;
        INVERT: LDA DIRFR         ;Get DIRFR byte in acc
                OUT 0AH           ;
          WAVE: MVI A,36H         ;Initialise counter0 in mode 3
                OUT 1BH           ;and counter2 in mode 2 of 8253
                MVI A,94H         ;
                OUT 1BH           ;
                LXI H,TABLE       ;Initialise mem.ptr. to lookup table
          BACK: MOV A,M           ;Compair for speed
                CMP E             ;If no.is greater than table value
                JZ L5             ;or equal to table value then
                JC L5             ;Jump to load counts
                INX H             ;If not increament mem.ptr to
                INX H             ;for next comparision.
                INX H             ;
                INX H             ;
                JMP BACK          ;
            L5: INX H             ;increament mem.ptr to next location
                MOV A,M           ;Load lower counts to counter0
                OUT 18H           ;
                INX H             ;increament mem.ptr. to next location
                MOV A,M           ;Load higher counts to counter0
                OUT 18H           ;
                INX H             ;increament mem.ptr to next location
                MOV A,M           ;Load lower counts to counter2
                OUT 1AH           ;
                JMP BACK2         ;
           DIR: DFB 44H           ;ASCII CODE FOR D
                DFB 49H           ;"I"
                DFB 52H           ;"R"
                DFB 20H           ;"SPACE"
                DFB 20H           ;"SPACE"
                DFB 46H           ;"F"
                DFB 2FH           ;"/"
                DFB 52H           ;"R"
                DFB 03H           ;ETX
         SPEED: DFB 53H           ;"S"
                DFB 50H           ;"P"
                DFB 45H           ;"E"
                DFB 45H           ;"E"
                DFB 44H           ;"D"
                DFB 20H           ;"SPACE"
                DFB 03H           ;ETX

         TABLE: DFB 98H           ;Lookup table to select the speed of motor
                DFB 9BH           ;depending upon the percentage PWM value
                DFB 00H           ;entered by user.
                DFB 30H
                 DFB 96H
                DFB 0FAH
                DFB 00H
                DFB 1CH
                 DFB 94H
                DFB 77H
                DFB 01H
                DFB 13H
                 DFB 92H
                DFB 0F4H
                DFB 01H
                DFB 0EH
                 DFB 89H
                DFB 80H
                DFB 02H
                DFB 0BH
                 DFB 86H
                DFB 0E8H
                DFB 03H
                DFB 07H
                 DFB 83H
                DFB 65H
                DFB 04H
                DFB 06H
                 DFB 80H
                DFB 0E2H
                DFB 04H
                DFB 05H
                 DFB 75H
                DFB 0D0H
                DFB 06H
                DFB 04H
                 DFB 66H
                DFB 0D0H
                DFB 08H
                DFB 03H
                 DFB 50H
                DFB 0B8H
                DFB 0BH
                DFB 02H
                 DFB 34H
                DFB 0D0H
                DFB 08H
                DFB 03H
                 DFB 25H
                DFB 0D0H
                DFB 06H
                DFB 04H
                 DFB 20H
                DFB 0E2H
                DFB 04H
                DFB 05H
                 DFB 17H
                DFB 65H
                DFB 04H
                DFB 06H
                 DFB 14H
                DFB 0E8H
                DFB 03H
                DFB 07H
                 DFB 11H
                DFB 80H
                DFB 02H
                DFB 0BH
                 DFB 08H
                DFB 0F4H
                DFB 01H
                DFB 0EH
                 DFB 06H
                 DFB 77H
                DFB 01H
                DFB 13H
                 DFB 04H
                DFB 0FAH
                DFB 00H
                DFB 1CH
                 DFB 02H
                DFB 9BH
                DFB 00H
                DFB 30H
                 DFB 00H
                DFB 9BH
                DFB 00H
                DFB 50H

