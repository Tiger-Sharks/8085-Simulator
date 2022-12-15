;*******************************************************************************
;Header: 		Sample program for B

;Monitor utilities used in this program
    cpu     8085
   
DELAY	EQU			0615H

;Addresses of 8255 control register, ports etc.
PORTA			equ		08H	; This is address of 8255 PORTA
PORTB			equ		09H	; This is address of 8255 PORTB
PORTc			equ		0AH	; This is address of 8255 PORTC
CW8255        	equ		0BH	; This is address of 8255 control word
;~~~~~~~~~~~~~~~~~~~~~~Start of main program~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

						ORG 7000H
START:		lxi SP,2100H; init stack pointer.
			 mvi A,	82H ; 8255 SET IN I/O MODE	
			 out 0BH
			 mvi A, 80H
			 out 0AH
			 lxi H, MSG1			
			 mvi B,03H
			 mvi c, 10H
			 mvi D, 0FH
			 mvi E, 0FFH
			 call 048AH
			 call 0476H
			 mov A,D
			 ani 0FH
			 mov D,A
			 push D
			 lxi H, MSG2
			 mvi B, 02H
			 mvi E, 01H
			 call 048AH
			 call 0476H
			 mvi D, 00H
			 pop B
	loop1:  lxi H, 0000H
	loop2:	mov A,L
			out 08H
			mov A, H
			ani 7FH
			out 0AH
			ori 80H
			out 0AH
			call 0615H
			inx H
			dcx B
			mov A,C
			ora B
			jnz loop2
	loop3:	inx B
			mov A,L
			out 08H
			mov A,H
			ani 7FH
			out 0AH
			ori 80H
			out 0AH
			call 0615H
			dcx H
			mov A,L
			ora H
			jnz loop3
			call 2072H
			jc loop1
			jmp 0013H	
		
		MSG1:
		DB 48H
		DB 45H
		DB 49H
		DB 47H
		DB 48H
		DB 54H
		DB 03H
		
		MSG2:
		DB 50H
		DB 45H
		DB 52H
		DB 49H
		DB 4FH
		DB 44H
		DB 03H