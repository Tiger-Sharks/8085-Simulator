            SCPD EQU 0000H           ;Scratch Pad Location.

; This program gives maximum of given series
; Series is stored from memory location 1000:0103H to 1000:010CH
; Result will be stored at memory location 0000H:1000H
        MAX SEGMENT
        ASSUME CS:MAX,DS:MAX
        ASSUME ES:MAX
        ORG 100H                        ;com format is recommended.
  START:JMP SKIP_DATA                   ;skip look up data.
                                        ;bases if any.
 ;On kit you need to do initialise for SP(to seperate stack of
 ;your programme from monitor),DS as shown below.SS,ES are set
 ;to 0000H at power on by monitor.You can of course change it
 ;by adding a few more MOVEs.But while working on PC you can't
 ;touch segment register since they are set by DOS loader,so
 ;manage these instructios as shown in comment field.

                LIST DB 80,81,78,65,48,23,13,10,11,17
  SKIP_DATA:
                MOV AX,10FFH
                MOV SP,AX               ;Init SP pointer
                PUSH CS
                POP DS                  ;Init DS register.
                MOV AX,SCPD             ;To specify SCPD on kit.
                MOV ES,AX
                MOV SI,OFFSET LIST      ;Init SI register
                MOV BL,00H              ;Largest +ve no. for ref.
                MOV CX,0AH              ;Number of element
	BACK:
                CMP BL,[SI]             ;Is next element >maximum
		JNC AHEAD		;
                MOV BL,[SI]             ;Yes replace maximum

	AHEAD:
                INC SI                  ;Update data
                LOOP BACK
                MOV ES:[1000H],BL
                INT 0A5H                ;Return to commond mode
                                                                              ;display
                                        ;If you are running
MAX ENDS                                ;your software on PC
END START                               ;insert include
