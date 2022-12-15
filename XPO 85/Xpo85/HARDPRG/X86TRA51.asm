;This programme demonstrates 8251  in Asynchronous 
;Transmitter Mode of operation using polling.

X86P511A  SEGMENT

	ASSUME CS:X86P511A, DS:X86P511A ,ES:X86P511A
	ORG 100H 	;Com format is recommended.
STRT:
    MOV AX,10FFH		;Initof SP for Kit
	MOV SP,AX			;On PC
    PUSH CS			;Init for DS
	POP DS
	NOP
	NOP
	NOP
	LEA BX,DATA;Set SI as a pointer of 'DATA'.
     MOV  AL,00H	; Dummy code.
     MOV  DX,9002H ;point at ctrl word address
     OUT  DX,AL
	 MOV CX,02H
D01:LOOP D01
	 OUT  DX,AL
	 MOV CX,02H
D02:LOOP D02
	 OUT  DX,AL
     MOV CX,02H
D03:LOOP D03	 
     MOV  AL,40H
     OUT  DX,AL	; Reset code
	MOV CX,02H
D04:LOOP D04
     MOV  AL,4EH
     OUT  DX,AL	; Mode word, Stop Bits=1, 
		            ; Character Length=8 Bits
					
MOV CX,02H
D05:LOOP D05
	 
MOV AL,23H	; Command Word, Rx 
	OUT DX,AL	;Enable=1,  TxEnable=1  DSR=1
		
		
		
      MOV CX,05H
LOOP1:MOV DX,9002H ;point at ctrl word address
      IN   AL,DX	; Check for transmitter ready.
      AND  AL,01H	; If no then remain in loop and 
		              ; wait.
     CMP  AL,01H	
      JNZ  LOOP1
     MOV AL,[BX]
		MOV DX,9000H ;point at data address
	OUT  DX,AL	; Send data to Transmitter Buffer
	INC BX
	LOOP LOOP1
		INT 0A5H
DATA:DB 11,22,33,44,55;Pointer for look up table
X86P511A  ENDS
     END  STRT

