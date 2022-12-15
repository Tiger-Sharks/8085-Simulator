	cpu 8085
	
; Program to demonstrate multiplication of two 8 bit numbers using
; repeatative addition method.
; Input numbers are stored at locations 2100h and 2101h
; Result is stored at locations 2102h (HiByte) and 2103h (LowByte)	

	org 6980h		;Six bytes blank after previous program
	start:
		lda 2100h
		mov b,a		;First number to B
		lda 2101h	;Second number to Acc
		cmp b		; Use lower of the numbers as a counter.
					; This will cause lesser loop executions.
					; Which means that the program will execute faster.
		jnc use_b
		mvi d,00
		mov e,b		;DE will be used as the source for addition
		jmp check
		
	use_b:
		mvi d,00
		mov e,a
		mov a,b		;if b < a then b is used as counter
		
	check:		
		lxi h,00h	;HL is used as destination of the addition
		
		ora a		;Check if its multiply by zero
		jz mul_done
		
	cont_mul:
		dad d
		dcr a
		jnz cont_mul
		
	mul_done:
		shld 2102h	;Store result (HL pair to locations 2102:2103)
		rst 1
		
;Last address used by this program 1B68h == 7016