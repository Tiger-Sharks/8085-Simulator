;LIST  1 : - MEMORY MAPPED MEMORY.
PAGE 80
TITLE -- USING MEMORY IO PERIWARE.
;Following listing is w.r.t.battery backed ram at 1530:0100h but
;this program can work in scratch pad ram location at 0000h pl.
;enter the same from 0125:0100 and execute.
;This program shows how memory is mapped in interfacing of micro-
;processor.In this program first data 55H will be stored at memory
;location C000:0000H and second data AAH will be stored at memory
;location C000:0002H.Data will be read and displayed on corresponding
;LED.User can check by using substitute command.
 
 
X86PMIO1  SEGMENT
                                
ASSUME CS:X86PMIO1, DS:X86PMIO1 ,ES:X86PMIO1

        ORG 100H        ;Com format is recommended.

        STRT:   JMP  SKIP_DATA  ;Skip lookup/bases if any
                                
;On kit you need to do init for SP [to separate stack of your
;programme from monitors], DS as shown below. S S, ES are
;set to 0000 at power on by monitor. You can ofcourse change
;it by adding a few more move's but while working on PC you
;can't touch segment registers since they are set by dos loader,
;so manage these instructions as shown in comment field.
                                
 SKIP_DATA:
        MOV  AX,10FFH    ;Initof SP for Kit
        MOV  SP,AX       ;On PC
        PUSH CS          ;Init for DS
        POP  AX          ;Load kit INTS
        MOV  DS,AX       ;(A0-BF)
        NOP              ;In PC using
        NOP              ;CALL in place
        NOP              ;of 3 NOP`S

        MOV AX,0C000H    ;Bus address in ES
        MOV ES,AX
        MOV AL,55H       ;Data to be stored.
        MOV ES:[0000],AL ;Data read.
        MOV AL,0AAH      ;Second data.
        MOV ES:[0002],AL ;Data read
        MOV AL,ES:[0000]
        MOV DL,AL
        MOV AL,02H       ;No. of digit to be displyed.
        INT 0ACH         ;CRLF,bringing cursor to new line.
        INT 0AEH         ;Disply the data read.
        INT 0A4H         ;Return to CMD mode without
                         ;disturbing display.

        X86PMIO1 ENDS
        END STRT
