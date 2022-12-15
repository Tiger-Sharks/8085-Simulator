               SCPD EQU 0000H ;Scratch Pad memory segment.
               NUM  EQU 1000H ;Given number
;This program gives square of a given number.
;Number is stored at memory location 0000:1000H
;Result will be stored at memory location 0000:1010H
                SQR SEGMENT
             ASSUME CS:SQR,DS:SQR
             ASSUME ES:SQR
              ORG 100H      ;Com format is recommended
     START:JMP SKIP_DATA     ;skip look up/data bases if any
 ;On kit you need to do initialise for SP(to separete stack
 ;of your programme from monitor),DS as shown below.SS,ES are
 ;set to 0000H at power on by monitor. You can of course change
 ;it by adding a few more MOVEs.But while working on PC you can't
 ;touch segment register since they are by DOS loader,so manage
 ;these instruction as shown in comment field.
 
     SKIP_DATA:
               MOV AX,10FFH    ;Init sp register for kit
               MOV SP,AX
               PUSH CS         ;Init for DS register.
               POP DS
               MOV AX,SCPD     ;Data from SCPD location.
               MOV ES,AX
               MOV DX,01H      ;Number to add
               MOV CX,ES:NUM   ;Count in register CX
               MOV BX,00H      ;Initial sum=0
	AGAIN:
               ADD BX,DX       ;Add integer
               ADD DX,02H      ;Get next odd number
               LOOP AGAIN
               MOV ES:[1010H],BX
               INT 0A5H         ;Return to command mode
      
            SQR ENDS
            END START
