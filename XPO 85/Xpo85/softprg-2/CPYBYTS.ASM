	cpu 8085
	
; Location 2100 specifies the number of bytes to copy.
; Program to copy specified bytes of data from location 2101 onwards
; to location 2120 onwards.	Maximum 32 bytes can be specified (2120-2100)
; = 20h = 32
	
	org 6715h			;Four bytes blank after previous program
	start:
		lxi h,2100h		;specifies the number of bytes to copy.
		mov c,m	
        inx h		;Get first byte to copy
		lxi d,2121h		;Load destination address
	copy_next:
		mov a,m			;Get byte to copy
		stax d			;Store to destination
		inx h
		inx d
		dcr c
		jnz copy_next	;Copy all bytes
		rst 1

;Last address used by program 1A4Ah == 6730	