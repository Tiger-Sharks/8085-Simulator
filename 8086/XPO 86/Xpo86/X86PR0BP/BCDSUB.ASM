               SCPD EQU 0000H ;Scratch Pad location.
               NUM1 EQU 1000H ;First number.
               NUM2 EQU 1001H ;Second number.
;This program gives BCD subtraction.
;Numbers are at memory location 0000:1000H AND 0000:1001H
;Result will be stored at memory location 0000:1010H.

        BCDSUB SEGMENT
        ASSUME CS:BCDSUB,DS:BCDSUB
        ASSUME ES:BCDSUB
           ORG 100H           ;com format is recommended
 START:JMP SKIP_DATA          ;skip look up/data
                              ;base if any.
 ;On kit you need to do initialise for SP(to seperate of
 ;your programme form monitor),DS as shown below.SS,ES are
 ;set to 0000H at power on by monitor.you can of course change
 ;it by adding a few more MOVEs .but while working on PC can't
 ;touch segment resister since they are set by DOS loader
 ;so manage these instructions as shown comment field.

     SKIP_DATA:
                MOV AX,10FFH  ;
                MOV SP,AX      ;Init SP register
                PUSH CS       ;Init DS register
                POP DS
                MOV AX,SCPD  ;To specify SCPD location on kit.
                MOV ES,AX
                MOV BL,ES:NUM1     ;Move 8-bit to BL
                MOV AL,ES:NUM2     ;and second to AL
                SUB AL,BL       ;Perform substraction
                AAS             ;Adjust result after substraction
                MOV ES:[1010H],AL
                INT 0A5H        ;Return to command mode

                                ;if you are running your software
                                ;on PC insert ---->include

 BCDSUB ENDS
 END START
