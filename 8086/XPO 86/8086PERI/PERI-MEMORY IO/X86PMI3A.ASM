;LIST  1 : - I/O MAPPED I/O (WRITE DATA).
PAGE 80
TITLE -- USING MEMORY IO PERIWARE.
;Following listing is w.r.t.battery backed ram at 1568:0100h but
;this program can work in scratch pad ram location at 0000h pl.
;enter the same from 0125:0100 and execute.
;In this programme it is demonstrated how 16-bit addresses are
;assigned to I/O ports while using the I/O mapped I/O method.
;The 16-bit addr 002AH is assigned to the port.

X86PMIO3A  SEGMENT
                                
ASSUME CS:X86PMIO3A, DS:X86PMIO3A, ES:X86PMIO3A

        ORG 100H           ;Com format is recommended.

      STRT:JMP  SKIP_DATA  ;Skip lookup/bases if any.
                                
;On kit you need to do init for SP [to separate stack of your
;programme from monitors], DS as shown below. SS, ES are
;set to 0000 at power on by monitor. You can ofcourse change
;it by adding a few more move's but while working on PC you
;can't touch segment registers since they are set by dos loader,
;so manage these instructions as shown in comment field.
                                
SKIP_DATA:
MOV  AX,10FFH   ;Init of SP for Kit
MOV  SP,AX      ;On PC.
PUSH CS         ;Init for DS
POP AX          ;Load kit INTS
MOV DS,AX       ;(A0-BF)
NOP             ;In PC using
NOP             ;CALL in place
NOP             ;of 3 NOP`S.

MOV AL,0C9H     ; Data to be written on port
MOV DX,002AH    ; I/O address, treate as I/O
OUT DX,AL       ; data written to port.
INT 0A4H        ; Ret to CMD Mode without
                ; disturbing display.
X86PMIO3A ENDS
END STRT
