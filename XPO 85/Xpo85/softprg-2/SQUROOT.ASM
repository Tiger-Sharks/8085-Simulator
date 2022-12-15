	cpu 8085
	
	;Program to find square root of a given number by subtraction of
	;successive odd integers method.
	;The number is stored at location 2100h
	;The result is stored at location 2101h
	;This method is useful only to find integer square roots or 
	;to find approximate values of fractional square roots.
	;So square root of 9 would be found accurately with this method
	;but not so in case of (say) square root of 8.
	
	org 6660h			;Three bytes blank after previous program.
	start:
		lda 2100h		;Get the number
		ora a			;Check if number = 0
		jz done
		
		mvi b,01h		;B is the odd number generator
		mvi c,00h		;Initial square root = 0
	
	sub_next:
		sub b			;Number = Number - Next Odd integer
		jz done
		inr b
		inr b			;Get next odd integer to B
		inr c			;Increment the Square Root
		jnc sub_next
	done:
		mov a,c
		sta 2101h
		rst 1

;Last address used by the program 1A1Dh == 6685