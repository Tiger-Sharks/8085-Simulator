;This program display ASCII codes  between 32 to 127
;In this program only those ASCII codes are displayed
;which are shown in mannual.Other than these,ASCII codes
;will not displayed,due to the limitation of seven segment
;display.After execution of progrm press ENTER key for displaying
;each ASCII code.

              DASCII SEGMENT
              ASSUME CS:DASCII,DS:DASCII,ES:DASCII
                 ORG 100H
       START:JMP SKIP_DATA

       SKIP_DATA:
                 MOV AX,10FFH
                 MOV SP,AX      ;Init for SP register.
                 PUSH CS
                 POP DS         ;Init DS register.
                 
                 MOV CX,95      ;Loop count=95.
                 MOV DL,32      ;Starting ASCII code.
         BACK:    MOV AH,02H     ;Display char function.
                 INT 0A2H
                 INC DL         ;Next ASCII Code.
                 MOV AH,08H
                 INT 0A1H
                 LOOP BACK      ;Display another charector.
                 INT 0A5H       ;Return to command mode.

    DASCII ENDS                 ;If you are running your
    END START                   ;software on PC insert
                                ;here ---->include.
