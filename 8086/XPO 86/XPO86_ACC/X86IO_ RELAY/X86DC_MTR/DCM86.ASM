
	PAGE,70
	TITLE-- DCMT

DCMT     SEGMENT
	ASSUME CS:DCMT, DS:DCMT,ES:DCMT,SS:DCMT
	ORG 100H   ;COM FORMAT
STRT:   JMP SKIP_DATA
;SKIP LOOK UP/ DATA BASES IF ANY  (MODIFIED ON 26/2/04)
;ON KIT YOU NEED TO DO INIT FOR SP
;[TO SEPARATE STACK OF YOUR PROGRAME FROM
;MONITORS],DS AS SHOWN BELOW.SS,ES ARE SET
;TO 0000 AT POWER ON BY MONITOR.
;YOU CAN OFCOURSE CHANGE IT BY ADDING A
;FEW MORE MOVE`S.
;BUT WHILE WORKING ON PC YOU CAN`T TOUCH
;SEGMENT REGISTERS SINCE THEY ARE
;SET BY DOS LOADER,SO MANAGE THESE
;INSTRUCTIONS AS SHOWN IN COMMENT FIELD.
SKIP_DATA:MOV AX,11FFH  ;INIT OF SP FOR KIT
STRT1: MOV SP,AX       ;MOV AX,AX   ON PC
       PUSH CS         ;THIS IS THE BEST WAY TO LOAD DS
       POP DS          ;WITH SEGMENT VALUE.
       NOP             ;LOAD KIT INT S (A0-BF) IN PC USING
       NOP             ;CALL LDINPC
       NOP             ;PLACE ABOVE CALL IN PLACE OF 3 NOP`S
       MOV AL,80H      ;SET ALL PORTS
       MOV DX,8006H    ;OF LOWER 8255 AS
       OUT DX,AL       ;OUTPUT PORTS
START: INT 0ACH
       MOV BX,OFFSET DIR;Initialise the mem. ptr to display
       INT 0AFH       ;DIR message
       MOV AH,08H     ;Read the key
       INT 0A1H
       MOV BL,AL
       MOV CL,46H     ;Is it for farward direction
       CMP AL,CL
       JNE RVD        ;If not jump to rev.
       MOV AL,01H     ;If yes set PC0.
       MOV DI,OFFSET DIRFR
       MOV [DI],AL    ;Stor it atDIRFR
       JMP DISPLAY
  RVD: MOV AL,BL      ;Is it for rev dir.
       MOV CL,52H
       CMP AL,CL
       JE L1         ;If yes jump for PC0 set.
       CMP AL,1BH    ;Is it ESC
       JNE START     ;If not display direction.
       MOV AL,80H    ;If ESC jump to command mode
       MOV DX,8006H  ;Reset 8255
       OUT DX,AL
       INT 0A3H
    L1:MOV AL,02H   ;Set the PC1 bit
       MOV DI,OFFSET DIRFR;save at DIRFR
       MOV [DI],AL
DISPLAY:INT 0ACH
       MOV BX,OFFSET SPEED ;Display SPEED
       INT 0AFH    ;Ask to enter the
       MOV AL,02H  ;2 Digit
       MOV AH,0AH  ;Decimal no.
       INT 0ADH
       AND AX,4000H;Do not accsept
       CMP AX,4000H;wrong entry.
       JNE DISPLAY
       PUSH DX     ;Save the no.
       MOV AL,DL
       MOV CL,50H  ;compair for 50%
       CMP AL,CL   ;If not then invert
       JC INVERT   ;the wave
       MOV DI,OFFSET DIRFR
       MOV BX,[DI] ;If equal then
       OR BL,08H   ;set the PC3 bit
       MOV AL,BL   ;Out data to
       MOV DX,8004H;port C
       OUT DX,AL
       JMP WAVE
 INVERT:MOV DI,OFFSET DIRFR
       MOV BX,[DI];Invert the wave
       MOV AL,BL
       MOV DX,8004H;out data to
       OUT DX,AL   ;port C
  WAVE:MOV AL,36H  ;Initialise the 8253
       MOV DX,8C07H;counter0 in mode 3
       OUT DX,AL   ;and counter2 in mode2
       POP DX
       MOV AL,00H
       CMP AL,DL
       JNE MOD2
       MOV AL,90H
       JMP MOD1
MOD2:  MOV AL,94H
MOD1:  PUSH DX
       MOV DX,8C07H
       OUT DX,AL
       MOV BX,OFFSET TABLE
       POP DX
  BACK:MOV AL,CS:[BX]
       CMP AL,DL  ;Compair the no for
       JC NEXT    ;speed with the data
       JZ NEXT    ;in lookup table and
       INC BX     ;load the counts to
       INC BX     ;counters of 8253
       INC BX
       INC BX
       JMP BACK
  NEXT:INC BX
       MOV AL,CS:[BX];Load higher
       MOV DX,8C01H;bytes to counter0
       OUT DX,AL
       INC BX
       MOV AL,CS:[BX];Load lower
       OUT DX,AL;bytes to counter0
       INC BX
       MOV AL,CS:[BX]
       MOV DX,8C05H;Load lower bytes
       OUT DX,AL;to counter2
       JMP START
DIR:DB 44H,49H,52H,20H,46H,2FH,52H,03H
SPEED:DB 53H,50H,45H,45H,44H,20H,03H
TABLE:DB 98H,9BH,00H,30H,96H,0FAH,00H,1CH,94H,77H,01H
DB 13H,92H,0F4H,01H,0EH,89H,80H,02H,0BH
DB 86H,0E8H,03H,07H,83H,65H,04H,06H,80H
DB 0E2H,04H,05H,75H,0D0H,06H,04H,66H,0D0H
DB 08H,03H,50H,0B8H,0BH,02H,34H,0D0H,08H,03H
DB 25H,0D0H,06H,04H,20H,0E2H,04H,05H,17H,65H,04H
DB 06H,14H,0E8H,03H,07H,11H,80H,02H,0BH,08H
DB 0F4H,01H,0EH,06H,77H,01H,13H,04H,0FAH,00H,1CH
DB 02H,9BH,00H,30H,00H,9BH,00H,50H
DIRFR DB 1 DUP(?)
;IF YOU ARE RUNNING YOUR SOFTWARE ON PC INSERT HERE -->INCLUDE KIT_INTS.ASM
DCMT     ENDS                    ;READ FOR MORE INFO TITLE OF KIT_INTS.ASM
	 END STRT
									      


























Š




%%%%                     
