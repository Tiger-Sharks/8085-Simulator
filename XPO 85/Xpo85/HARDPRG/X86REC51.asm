
;This programme demonstrates 8251 in Asynchronous 
;Receiver Mode of operation using polling.

X86P511A  SEGMENT
	ASSUME CS:X86P511A, DS:X86P511A ,ES:X86P511A
	ORG 100H 	;Com format is recommended.
STRT:MOV AX,10FFH		;Initof SP for Kit
	 MOV SP,AX			;On PC
     PUSH CS			;Init for DS
	 POP DS
	
	 NOP
	 NOP
	 NOP
LEA SI,DATA1  ;Byte to be receive
                    ;stored at address point by SI register
     MOV  AL,00H	; Dummy code.
     MOV  DX,9002H ;point at ctrl word address
OUT  DX,AL
MOV CX,02H
D01:LOOP D01
OUT DX,AL
MOV CX,02H
D02:LOOP D02
OUT DX,AL
MOV CX,02H
D03:LOOP D03
MOV  AL,40H
OUT  DX,AL	; Reset code
MOV CX,02H
D04:LOOP D04
MOV  AL,4EH ;
OUT  DX,AL	; Mode word, Stop Bits=1, 
		    ; Character Length=8 Bits
MOV CX,02H
D05:LOOP D05
			
MOV  AL,24H
OUT  DX,AL	 ; Command Word
		      ;rxE enable=1 
		      ; RTS=1
			  
MOV CX,05H   ;No. of bytes to be transfer
LOOP2:
MOV  DX,9002H;point at ctrl word address
IN   AL,DX	; Check for receiver ready.
AND  AL,02H	; If no then remain in loop and 
		; wait.		
CMP  AL,02H	
JNZ  LOOP2
MOV  DX,9000H	;point to data address	
IN   AL,DX	; Receive the data from
           	; receiver output.
MOV [SI],AL
INC SI
LOOP LOOP2
INT 0A5H
DATA1:DB 5 DUP(?)   ;Pointer for look up table
X86P511A  ENDS
     END  STRT

