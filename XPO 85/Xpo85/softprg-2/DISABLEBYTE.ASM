		cpu     8085
		
;Disassemble a byte stored at location 2100h.
;Store result to location 2101:2102

		org 6524h
	start:
		lxi h,2100h		;Pointer to storage location.
		mov a,m			;Get byte to A
		mov b,a			;Keep a copy in Register B
		
		ani 0fh			;Mask the upper four bits
		inx h			;increment the HL pair.
		
		mov m,a			;Store the lower dis-assembled byte to 2101
		mov a,b			;Get the copy from B.
		rrc				;Rotate four times to get
		rrc				;Upper four bits to lower four bits.
		rrc
		rrc
		ani 0fh			;Again mask upper four bits
		inx h			;Increment HL pair (to 2102h)
		mov m,a			;Store upper dis-assembled nibble to 2102.
		rst 1				;Stop
		
;Last address used by the program is 198Eh == 6542