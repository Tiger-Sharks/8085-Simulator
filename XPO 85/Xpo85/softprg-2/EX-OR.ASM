	cpu 8085

; Program to perform ex-oring without using exor instruction.
; This is done using the exor equivalence that 
; A ^ B = !AB + A!B
; The two bytes to be exored are stored at locations 2100h and 2101h	
; The result is returned in location 2103h
	
	org 6835h		;Five bytes blank after previous program.
	start:
		lxi h,2100h
		
		mov a,m
		mov b,a
		inx h		;HL points to second data byte.
		cma			;Compelement first data byte
		ana m		;!AB operation complete.
		mov c,a		;Store result to C (c= !AB)
		mov a,m		;Get secondn number
		cma			;complement the number
		ana b		;accumulator = A!B
		ora c		;accumulator = !AB + A!B
		inx h
		mov m,a		;Store result to 2102h
		rst 1

;Last address used by the program 1AC2h == 6850