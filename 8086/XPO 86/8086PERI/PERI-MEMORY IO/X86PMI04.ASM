;LIST 1:-I/O MAPPED MEMORY
 PAGE 80
 TITLE--USING MEMORY IO PERIWARE.
;Following listing is w.r.t.battery backed ram at 158D:0100H but
;this program can work in scratch pad ram location at 0000H pl.
;enter the same from 0125:0100H and execute.
;To understand the concept of the decoding clearly this experiment
;has been set.The memory has been mapped contains same address,
;hence in I/O mapped memory data can be written to some perticular
;memory location.
        X86PMIO4 SEGMENT
        ASSUME CS:X86PMIO4,DS:X86PMIO4,ES:X86PMIO4
        ORG 100H            ;Com format is recommanded.
 START: JMP SKIP_DATA       ;Skip lookup data bases if any.

;On kit you need to do init for SP [to separate stack of your
;programme from monitors], DS as shown below. SS, ES are
;set to 0000 at power on by monitor. You can ofcourse change
;it by adding a few more move's but while working on PC you
;can't touch segment registers since they are set by dos loader,
;so manage these instructions as shown in comment field.

SKIP_DATA:
          MOV AX,10FFH      ;Init of SP for Kit
          MOV SP,AX         ;on PC.
          PUSH CS           ;Init for DS.
          POP AX            ;Load kit INTS
          MOV DS,AX         ;(A0-BF)
          NOP               ;In PC using
          NOP               ;CALL in place.
          NOP               ;of 3 NOP'S
          MOV DX,0080H      ;Init for port address.
          MOV AL,55H        ;Data to be written on port.
          OUT DX,AL         ;
          MOV DX,0080H      ;Init for port address.
          IN AL,DX          ;Input data from port.
          CMP AL,55H        ;Is same data found?
          JZ DSPLY          ;Yes,go to DSPLY.
          MOV BX,OFFSET DBAS;No,
          INT 0AFH          ;Display message.
          INT 0A4H          ;Ret to CMD mode without
                            ;disturbing display.
   DSPLY:
          MOV BX,OFFSET MSGDONE
          INT 0AFH
          INT 0A4H
    DBAS: DB "FAILED",03H
 MSGDONE: DB "DONE",03H
      X86PMIO4 ENDS
      END START

