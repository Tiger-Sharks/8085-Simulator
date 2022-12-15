

;LIST 5

;We are going to study different display modes now. 
;This program consists of four parts. Each one illustrates  
;one display mode. 8-8 bit character, 16-8 bit character,  
;left entry as well as right entry mode all are studied.

	ORG  44H  B5H
44B5  21  C1  44  DISPLAY:LXI  H,C1H  44H	; Set memory ptr. to look 
		; up table starting address.
44B8  7E	MOV  A,M	; Move first data byte to 
		; ACC.
44B9  D3  F0	OUT  F0H	; Out first data byte to display.
44BB  2C	INTR  L	; increment the look up 
		; table ptr.
44BC  05	DCR  B	; Decrement the counter.
44BD  F2  B8  44	JP  88H  44H
44C0  C9	RET	; Return to main program
44C1  C0         DATA:	DB  C0H
44C2  F9	DB  F9H
44C3  A4	DB  A4H
44C4  B0	DB  B0H
44C5  99	DB  99H
44C6  92	DB  92H
44C7  82	DB  82H
44C8  F8	DB  F8H
44C9  80	DB  80H
44CA  90	DB  90H
44CB  88	DB  88H
44CC  83	DB  83H
44CD  C6	DB  C6H
44CE  A1	DB  A1H
44CF  86	DB  86H
44D0  8E	DB  8EH


