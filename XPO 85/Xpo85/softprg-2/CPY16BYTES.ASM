	cpu 8085
	
;Copy 16 bytes of data from location 2100h to location 2110h

	org 6735h			;Four bytes blank after previous program
	start:
		lxi h,2100h		;Load source start address
		mvi c,10h		;Load byte counter
		lxi d,2110h		;Load destination start address
	copy_next:
		mov a,m			;Get from source
		stax d			;Copy to destination
		inx d
		inx h
		dcr c
		jnz copy_next
		rst 1
		
;Last address used by the program 1A5Fh == 6751