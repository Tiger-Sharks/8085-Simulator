	cpu 8085

; To find the occurrences of zero,negative and positive elements
; in a given set of data.
; Number of data points is specified at location 2100h
; The data series starts from 2104h
; Results are: 2101h contains number of zero elements
; 			   2102h contains number of positive elements
;              2103h contains number of negative elements	
; Program considers the uppermost bit as the sign bit.
; So numbers range from -1 to -127,0,+1 to +127
; i.e. (0-7F positive, 81 to ff negative)	
	
	org 6755h		;Three bytes blank after previous program
	start:
		lxi h,2100h
		mov c,m		;Get number of data points to check.
		
		xra a		;clear accumulator for comparisons
		mov b,a
		mov d,a
		mov e,a		;Clear b d and e registers as well.
		inx h		;These three registers are used as counters.
		inx h		;e=number of zeroes,b=number of negatives		
		inx h		;HL points to first number - 1 location
	check_next:
		inx h
		cmp m		;Compare memory
		jnz check_neg	;If number not zero check if negative
		inr e		;Increment number of zeroes counter
		jmp next_num
		
	check_neg:
		mvi a,7fh	;Largest positive number
		cmp m		
		jnc num_pos	;If no carry then the number is positive
		inr b
		jmp next_num
		
	num_pos:
		inr d
	next_num:
		xra a		;Clear Accumulator
		dcr c
		jnz check_next	;Continue till end of data set.
		
	store_res:
		lxi h,2101h		;Store results
		mov m,e			;Number of zeroes stored
		inx h
		mov m,d			;number of positive data points
		inx h
		mov m,b			;Number of negative data points
		rst 1

;Last address used by program 1A8Fh == 6799