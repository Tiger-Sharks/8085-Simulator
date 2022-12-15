	cpu 8085
	
; Program to convert hex representation of a number to ascii.
; Number to convert is stored at 2100h. Converted ascii is
; stored at 2101h

	org 6880h			;Four bytes blank after previous program
	start:
		lda 2100h		;Get number
		cpi 0ah			;Carry is set if accumulator < 0ah
		jc add_30h		;If number > 09 add 07h before adding 30h
		adi 07h
		
	add_30h:
		adi 30h
		sta 2101h		;Store back conversion
		rst 1
		
;Last address used by the program 1AEFh == 6895