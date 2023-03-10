 PAGE 70

 TITLE -- BINARY (HEX) TO GRAY CODE CONVERSION.

;THIS PROG. CONVERTS A BIN NO. AT 0000H:1000H
;(FROM 0 TO F) TO ITS GRAY CODE USING TRANSLATE
;INSTRUCTION.
;
; REG.USED/DESTROYED :- AX,CX,BX
; 
; INPUT TO THE PROG. :-
;  SEG 0000H
;   ADDR       DATA
; [1000 H] -- DATA IN HEX (00 TO 0F H)
;
; OUTPUT OF THE PROG. :-
; SEG 0000H
;  ADDR        DATA
; [1000 H] -- GRAY CODE OF DATA I/P


        BINGRY SEGMENT
        ASSUME CS:BINGRY, DS:BINGRY
        ASSUME ES:BINGRY

; 'ASSUME' IS AN ASSEMBLER DIRECTIVE. IT HAS
; NOTHING TO DO WITH 8086. IT IS ONLY USED
; TO TELL THE ASSEMBLER (MASM) WHERE THE
; CODE, DATA, STACK ETC. IS LOCATED.
; IT IS ONLY A FORMALITY FOR MASM.

SCPD     EQU 0000H ; SCRATCH PAD SEGMENT.
IP_NO    EQU 1000H ; ADDR OF HEX NO. TO BE
                   ; CONVERTED INTO GRAY CODE

ORG 100H        ;COM FORMAT IS RECOMMENDED.

STRT:
JMP SKIP_DATA   ;SKIP LOOK UP/DATA BASES IF ANY
;ON KIT YOU NEED TO DO INIT FOR SP [TO SEPARATE
;STACK OF YOUR PROGRAME FROM MONITORS],DS AS
;SHOWN BELOW.SS,ES ARE SET TO 0000 AT POWER ON
;BY MONITOR. YOU CAN OFCOURSE CHANGE IT BY
;ADDING A FEW MORE MOVES. BUT WHILE WORKING ON
;PC YOU CAN`T TOUCH SEGMENT REGISTERS SINCE
;THEY ARE SET BY DOS LOADER,SO MANAGE THESE
;INSTRUCTIONS AS SHOWN IN COMMENT FIELD.

TBL:
     DB 00H,01H,03H,02H,06H,07H,05H,04H ; GRAY
      ; 00H,01H,02H,03H,04H,05H,06H,07H =BIN NO
     DB 0CH,0DH,0FH,0EH,0AH,0BH,09H,08H ; GRAY
      ; 08H,09H,0AH,0BH,0CH,0DH,0EH,0FH =BIN NO

SKIP_DATA:
MOV AX,10FFH     ; INIT OF SP FOR KIT
MOV SP, AX       ; MOV AX,AX  ON PC
PUSH CS          ; INIT FOR DS
POP DS           ;
NOP              ; TO LOAD KIT INTERRUPTS
NOP              ; (A0-BF) ON PC,
NOP              ; REPLACE 3 NOPS
; CALL LDINPC    ; WITH THIS CALL.
MOV AX,SCPD      ; TO SPECIFY SCPD LOCn ON KIT.
NOP              ; <-- MOV AX,CS  ON PC
MOV ES,AX        ;
MOV BX,OFFSET TBL; POINTER TO TABLE
MOV SI,IP_NO     ;
MOV AL,ES:[SI]   ; LOAD THE NO.
AND AL,0FH       ; MASK UPPER NIB.
XLAT             ;
MOV ES:[SI],AL   ; STORE THE RESULT
INT  0A3H        ; RETURN TO COMMAND= ON KIT
                 ; RETURN TO DOS ON PC.
                 ; IF YOU ARE RUNNING YOUR
                 ; SOFTWARE ON PC INSERT HERE
                 ; INCLUDE KIT_INTS.ASM
                 ; *******************
                                
BINGRY  ENDS     ; READ FOR MORE INFO TITLE
        END STRT ; OF KIT_INTS.ASM
