;LIST  1 : - MEMORY MAPPED I/O (WRITE DATA).
PAGE 80
TITLE -- USING MEMORY IO PERIWARE.
;Following listing is w.r.t.battery backed ram at 1543:0100h but
;this program can work in scratch pad ram location at 0000h pl.
;enter the same from 0125:0100 and execute.
;This programme shows how to map an I/O port as memory.
;In this program AAH data will be store at memory location
;C000:0000H.Data will be read and displayed on corresponding LED
;from these memory location.
X86PMIO2A  SEGMENT
                                
ASSUME CS:X86PMIO2A, DS:X86PMIO2A ,ES:X86PMIO2A

        ORG 100H                  ;Com format is recommended.

        STRT:   JMP  SKIP_DATA    ;Skip lookup/bases if any.
                                
;On kit you need to do init for SP [to separate stack of your
;programme from monitors], DS as shown below. SS, ES are
;set to 0000 at power on by monitor. You can ofcourse change
;it by adding a few more move's but while working on PC you
;can't touch segment registers since they are set by dos loader,
;so manage these instructions as shown in comment field.
                                
SKIP_DATA:
MOV  AX,10FFH   ;Initof SP for Kit
MOV  SP,AX      ;On PC.
PUSH CS         ;Init for DS.
POP  AX         ;Load kit INTS
MOV  DS,AX      ;(A0-BF).
NOP             ;In PC using
NOP             ;CALL in place
NOP             ;of 3 NOP`S.
MOV  AX,0C000H
MOV  ES,AX	;Seg. Addr.
MOV  AL,0AAH    ; Data to be written on port.
MOV  ES:[0000],AL ; I/O port seen as mem loctn
                ; data written to port.
INT  0A4H       ; Ret to CMD Mode without
                ; disturbing display.
X86PMIO2A ENDS
END STRT
