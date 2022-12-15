		cpu 8085

; Program adds a series of bcd numbers.
; The number of numbers to add is stored at location 2100h
; The result is stored at location 2101.
; The series starts from location 2102.

		org 6600h		;Four bytes blank after previous program
	start:
		lxi h,2100h		;Point to number of numbers to add.
		mov c,m			;Store number to C. Will be used as counter.
		xra a			;clear accumulator
		inx h
	add_next:
		inx h			;point to first number to add
		add m			;Add number to accumulator
		daa				;Decimal adjust accumulator
		;inx h			;This instruction exists in the book Wrong?
		dcr c			;Decrement the counter
		jnz add_next	;Keep adding till all numbers are over

		sta 2101h		;Store result to location 2101h
		rst 1
		
;Last address used by the program 19D8h == 6616