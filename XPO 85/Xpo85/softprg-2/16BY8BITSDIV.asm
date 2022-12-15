	cpu 8085
	
; The program demonstrates unsigned 16 bit by 8 bit division.
; A 16 bit number (Stored at locations 2101:2100)h is divided
; by an eight bit number (Stored at location 2102)h.
; The result is stored at locations (2104:2103)h
; The remainder is available at (2106:2105)h
; Note:-The processor when loading 16-bits operand does the higer
        ;memory location frist and then lower memory.So frist 
		;instruction of the program 'LHLD 2100H',end up loading
		;H with FF and L with 0FH when value at memory location
		;2100h=0FH and 2101=FFH
	
; R7 == C
; R6:R5 = HL
; R4 = B

; R3 = 2106H	
; R2 = 2105H	;REMAINDER IN 2106:2105

; R1 = 2104H
; R0 = 2103H	;ANSWER IN 2104:2103
	
	ORG 68C7H			;FIVE BYTE GAP
	START:
		LHLD 2100H		;GET 16 BIT DIVIDEND TO HL
		LDA 2102H		;GET 8 BIT DIVISOR
		MOV B,A			;DIVISOR IN B
		
		MVI C,10H		;BIT COUNTER (16 BITS IN DIVIDEND)
		
		MVI A,00H
		STA 2103H
		STA 2104H
		STA 2105H
		STA 2106H		;ANSWER AND REMAINDER INITIALISED TO ZERO
		
	DIVLOOP_16BY8:
		STC
		CMC				;CLEAR CARRY
		MOV A,L
		RAL
		MOV L,A
		
		MOV A,H
		RAL
		MOV H,A			;MSb OF DIVIDEND TO CARRY
		
		LDA 2105H
		RAL
		STA 2105H
		
		LDA 2106H
		RAL
		STA 2106H		;PARTIAL REMAINDER LOCATIONS
		
	TRIAL_SUB:
		STC
		CMC
		
		LDA 2105H
		SBB B
		MOV D,A			;TEMPORARY STORE
		LDA 2106H
		MVI E,0			;8085 DOES NOT HAVE IMMEDIATE SUBTRACT OPERATION.
		SBB E			;16BIT - 8BIT SUBTRACTION
		
;IF 2106:2105 < B SHIFT ZERO TO ANSWER AND DO NOT UPDATE REMAINDER
;IF 2106:2105 >= B THEN 2106:2105 = (2106:2105)-B AND SHIFT ONE IN ANSWER
;IF (2106:2105) - B PRODUCES BORROW SHIFT IN ZERO
;ELSE UPDATE REMAINDER AND SHIFT IN ONE

		JNC DIVIDE16
	NO_DIVIDE16:
		STC
		CMC
		
		LDA 2103H
		RAL
		STA 2103H
		LDA 2104H
		RAL
		STA 2104H
		DCR C
		JNZ DIVLOOP_16BY8
		JMP DIVIDE_DONE
		
	DIVIDE16:
		STA 2106H
		MOV A,D
		STA 2105H
		
		STC
		LDA 2103H
		RAL
		STA 2103H
		LDA 2104H
		RAL
		STA 2104H
		DCR C
		JNZ DIVLOOP_16BY8
		
	DIVIDE_DONE:
		RST 1

; Last address used by program = ????H


