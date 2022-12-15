          SCPD EQU 0000H ;Scratch Pad Location.
;This program gives addition of number from 0 to 10
;Data is stored at register AX
;and result will store at memory location 0000:1000H

SUM SEGMENT
    ASSUME CS:SUM, DS:SUM
    ASSUME ES:SUM
        ORG 100H        ;Com format is recommended

START:JMP SKIP_DATA      ;Skip look up/data
                         ;bases if any.
;On kit you need to do initialise for SP(to seprate stack of
;your programme from monitor),DS as shown below.SS,ES are set
;to 0000H at Power on by monitor.You can of course change it
;by adding a few more MOVEs.But while working on PC you can't
;touch segment register since they are set by DOS Loader,so
;mange these instruction as shown in comment field
   
SKIP_DATA:
        MOV AX,10FFH    ;Init of SP for kit
        MOV SP,AX
        PUSH CS          ;Init for DS
        POP DS           ;
        MOV AX,SCPD      ;To specify SCPD on kit.
        MOV ES,AX
        XOR AX,AX
        MOV CL,0AH       ;Loop count=10
Back:   ADD AL,CL       ;Add two numbers
        LOOP BACK        ;Repeat until CL=0
        MOV ES:[1000H],AL
        INT 0A5H         ;Retrns to comman mode of kit
                         ;monitor
                         ;if you are running your
   SUM ENDS              ;software on PC insert
                         ;here ------------ >include
   END START


























; Assembly Language Programming ;By
; Bhupendra Singh Chhabra
Dosseg
.Model Small
.Stack 100h
.Code
Main Proc
Mov Ax,@Data    ;Initialise Ds Register
Mov Ds,Ax
Mov Si,Offset List      ;Initialize Si Register
Mov Al,07fh     ;Largest +Ve Number For Comparison
Mov Cx, 0ah     ;Number Of           Elements
