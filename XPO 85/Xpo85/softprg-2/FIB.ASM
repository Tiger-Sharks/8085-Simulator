	cpu 8085

; Program generates Fibonacci series. The series is stored
; at location from 2101h. The number of data points to generate is
; stored at location 2100h
;  for e.g.fibonacci series for 8 data points is given below
;  Fibb. ser.(8)=0,1,1,2,3,5,8,d  
	org 6805h		;Five bytes blank after previous program
	start:
		lxi h,2100h
		mov c,m		;C is the number of data points to generate.
		
		inx h		;Point to starting address of storage
		mvi a,00h	;First data point of fibonacci series
		mov m,a		;Store the first element
		inx h
		mvi a,01h
		mov m,a		;Store the second element
		
		
		dcr c
		dcr c
		
	store_next:
	dcx h
		mov a,m
		inx h
		add m	
         inx h	;Add num to accumulator to get next number
		mov m,a		;Next number stored
		dcr c
		jnz store_next
		rst 1
		
;Last address used by the program 1AADh == 6829