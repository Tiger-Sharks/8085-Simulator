		cpu 8085
	
; Re-assembly of a dis-assembled byte.
; The dis-assembled nibbles are stores at locations
; 2100 and 2101. (Lower:Upper)
; The combined result is stored at location 2102.
; e.g.
; If location 2100:2101 contain 02h and 04h respectively
; then when the program completes running location 2102
; will have 42h stored.

		org 6545h		;Two bytes blank after end of previous program
	start:
		lxi h,2100h		;Pointer to lower nibble
		mov a,m
		ani 0fh		;mask upper four bits.
		mov b,a			;Store this nibble to b
		
		inx h			;Point hl pair to higher nibble.
		mov a,m
		ani 0fh			;mask upper four bits
		rlc
		rlc				;mov lower four bits to upper four bit
		rlc				;locations
		rlc
		ora b			;OR lower and upper nibbles to form complete byte
		inx h			;Point hl pair to storage destination location.
		mov m,a			;Store assembled nibble
		rst 1				;Stop
		
;Last address used by the program is 19A3h = 6563		