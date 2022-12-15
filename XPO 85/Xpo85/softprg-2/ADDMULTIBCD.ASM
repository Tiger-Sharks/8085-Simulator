	cpu 8085
	
; Program to add multibyte BCD numbers.	
; Two BCD number tables are provided:
; How many numbers are to added is specified at 2100h
; Table1 starts at 2101h
; Table2 starts at 2121h
; Rowise addition is carried out and the result is stored in table3
; Table3 starts at 2141h
; [2140] = [2100] + [2120]
; [2141] = [2101] + [2121] and so on so forth.
; So a maximum of 32 numbers can be added.

; The program uses stack. Start of stack is taken at 2160h

	org 6940h			;Seven bytes blank after previous program
	start:
		lxi sp,2160h
		lxi h,2100h
		mov c,m			;Get number of numbers to add.
		
		lxi h,2141h		
		push h			;Store destination pointer to stack
		
		lxi h,2101h		;HL=Pointer to start of table1
		lxi d,2121h		;DE=Pointer to start of table2
		
		stc				;Set carrt
		cmc				;Comlement carry (Effectively carry is now cleared)
		
	add_next:	
		ldax d			;Get first byte to accumulator
		adc m			;Acc = Acc + [HL] + CY
		DAA				;Decimal adjust accumulator
		XTHL			;Get Destination table pointer to HL
						;And store current HL to stack
		mov m,a			;Populate destination table with result (Table3)
		inx h			;Increment destination pointer
		xthl			;Store back to stack
		
		inx h			;Pointer to Table1 incremented
		inx d			;Pointer to Table2 incremented
		dcr c			;Number of numbers counter decremented
		jnz add_next
		
		pop h			;Not really required.
		rst 1				;Since I am halting anyway.

;Last address used by the program	1B3Dh == 6973