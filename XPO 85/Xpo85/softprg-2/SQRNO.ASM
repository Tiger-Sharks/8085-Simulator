	cpu 8085
	
	;Program finds square of a number by using addition of successive
	;odd numbers method. The number itself is used a loop counter, 
	;successive odd numbers are added till this loop counter zeroes.
	;The number to square is stored at location 2100h
	;The squared answer is stored at location 2101h
	
	;e.g. To find square of the number 3, we will add 1,3 and 5 (The first
	;three odd integers) to get an answer of 9.
	
	org 6635h			;Four bytes blank after previous program
	start:
		lda 2100h		;Get the number to accumulator
		ora a			;Check if number is zero
		jz done			;If number is zero no point in entering the loop.
		
		mov c,a			;Move number to C.This is our loop counter.
		xra a			;Initial value of square = 0.
		mvi b,01h		;B register is our odd number accumulator
		
	add_next:
		add b
		inr b
		inr b
		dcr c
		jnz add_next
	done:
		sta 2101h
		rst 1
		
;Last address used by the program 1A00h == 6656