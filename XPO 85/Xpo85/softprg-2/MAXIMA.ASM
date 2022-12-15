	cpu 8085
	
	;Program to find maxima in given series of data.
	;Number of data points is specified at location 2100h
	;Data points start from location 2102h
	;The result is stored in location 2101h
	
	org 6690h		;Four bytes blank after previous program
	start:
		lxi h,2100h
		mov c,m		;Number of data points to C.
		xra a		;Clear accumulator
		inx h
	cmp_next:
		inx h		;Point to first number to compare
		cmp m		;Compare with accumulator
		jnc next	;If current number is larget keep
		mov a,m		;else declare new number as largest
	next:
		dcr c
		jnz cmp_next
		sta 2101h	;Store largest number to location 2101h
		rst 1
	
;Last address used by the program 1A36h == 6710	