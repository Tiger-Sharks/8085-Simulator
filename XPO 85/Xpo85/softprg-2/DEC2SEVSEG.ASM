	cpu 8085

; Decimal to seven segment conversion.
; Lookup table for 7 segment equivalents is stored at location 6900 
; onwards. Only decimal numbers are converted. (0..9) are converted to
; seven segment equivalent. Any number > 9 produces a blank display.
; The lookup table assumes that MSbit is decimal point and rest of the
; bits are arranged as LSbit (a).....MSbit-1 (g), MSbit is Decimal Point
	
	org 6900h			;Four bytes blank after previous program
	db 3Fh,06h,5Bh,4Fh,66h,6Dh,7Dh,07h,7Fh,67h
	
	org 6910h
	start:
		mvi b,00h		;If number > 09 use b to produce blank
		lda 2100h		;Get number to perform lookup on.
		cpi 0ah			;Carry is set if Accumulator < 0a
		jnc done			
		
		lxi d,6900h		;DE = Base address of lookup table
		mvi h,00h
		mov l,a			;HL = Number (offset) to index into lookup table
		dad d
		mov b,m			;Get seven segment equivalent to B
	done:
		mov a,b
		sta 2101h
		rst 1

;Last address used by the program 1B14h == 6932