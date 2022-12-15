		cpu 8085
		
; Program to clear memory locations from 2101.
; How many locations are to be cleared is indicated by
; one byte stored at location 2100

		org 6565h		;1 bytes space after end of last program
	start:
		lxi h,2100h		;Load pointer to one byte before first location.
		mov c,m			;Load C with counter
		xra a			;Zero out A register by Xoring with itself.
	loop:
		inx h			;Point to first memory location to be cleared.
		mov m,a
		dcr c			;Decrement counter
		jnz loop		;If counter not Zero goto loop 
		rst 1				;Stop
		
;Last address used by the program 19B0h == 6576