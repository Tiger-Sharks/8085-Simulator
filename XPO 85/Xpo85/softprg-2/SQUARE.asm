		cpu 8085

; Program squares a number at location 2100h
; It is assumed that a look up table of single byte
; squares is located at 6620h onwards.
; The program fetches the square from this lookup table.
; The result is stored at location 2101h.

; This method (program logic) is usable only upto numbers
; whose square is < 255 (<= 256). So the largest number for
; which a square can be located with this program (without
; modifications is 15.

	org 6620h			;Three Bytes blank after previous program
	db 0,1,4,9,16,25,36,49,64,81,100,121,144,169,196,225

		org 6630h		
start:
		lxi d,6620h		;Base address of lookup table
		lda 2100h		;Get the number to square
		mvi h,00h
		mov l,a
		dad d			;Add offset to lookup table base address
		mov b,m
		mov a,b			;Get the square
		sta 2101h		;Store result
		rst 1
		
