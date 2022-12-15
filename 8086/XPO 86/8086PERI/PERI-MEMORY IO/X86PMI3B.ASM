;LIST  1 : - I/O MAPPED I/O (READ DATA).
PAGE 80
TITLE -- USING MEMORY IO PERIWARE.
;Following listing is w.r.t.battery backed ram at 157A:0100h but
;this program can work in scratch pad ram location at 0000h pl.
;enter the same from 0125:0100 and execute.
;This program allows you to read the data from port 002AH.

X86PMIO3B  SEGMENT
ASSUME CS:X86PMIO3B, DS:X86PMIO3B ,ES:X86PMIO3B

        ORG 100H        ;Com format is recommended.

        STRT:   JMP  SKIP_DATA  ;Skip lookup/bases if any.
                                
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

        XOR AL,AL       ; Clear ACC.
        MOV DX,002AH    ; Read port.
        IN  AL,DX       ; IN data to AL reg.
        MOV DL,AL       ; Data transfer to DL for display.

        MOV AL,02H      ; No. of digits to be displayed.
        INT 0ACH        ; CRLF,bringing cursor to new line.
        INT 0AEH        ; NMOUT,display the data read from
                        ; the port.
        INT 0A4H        ; Ret to CMD Mode without
                        ; disturbing display.
        X86PMIO3B ENDS
        END STRT
