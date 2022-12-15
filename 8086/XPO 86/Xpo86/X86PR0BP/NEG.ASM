          SCPD EQU 0000H      ;Scratch Pad Segment.

;This program gives the number of Negative
;elements in a given series.
;The series from memory location 1000:0103H to 1000:010CH
;Result will be stored at memory location 0000:1000H

    NEG SEGMENT
    ASSUME CS:NEG, DS:NEG
    ASSUME ES:NEG
        ORG 100H              ;Com Format is recommonded

START:JMP SKIP_DATA           ;skip look for
                              ;up/data base if any.
;On kit you need to do initialise for SP(to seperate stack of
;your programme from monitor),DS as shown below.SS,ES are set
;to 0000H at power on by monitor .You can of course change it
;by adding a few more MOVEs,But while working on PC you can't
;tuoch segment register since they are set by DOS Loader,so
;manage these instructions as shown in comment field.

           LIST DB 80H,81H,0FFH,65H,43H,23H,15H,12H,10H,11H
 SKIP_DATA:
           MOV AX,10FFh       ;Init of SP for kit
           MOV SP,AX          ;
           PUSH CS            ;Init for DS
           POP DS             ;
           MOV AX,SCPD
           MOV ES,AX
           MOV SI,OFFSET LIST ;Initialise SI resister
           MOV BL,07FH        ;Largest +ve number for comparision
           MOV CX,0AH         ;No. of element
           MOV BH,00H         ;No. of neg. element
      BACK:
          CMP BL,[SI]         ;Is MSB=1
          JNC AHEAD
          INC BH              ;Yes,increment count
    AHEAD:                    ;No
          INC SI
          LOOP BACK
          MOV ES:[1000H],BH
          INT 0A5H            ;Return to command mode kit

                              ;If you are running your
     NEG ENDS                 ;software on PC insert
                              ;----->include

     END START


























