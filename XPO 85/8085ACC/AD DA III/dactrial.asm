\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\';*******************************************************************************
;Header: 		Sample program for B

;Monitor utilities used in this program
    cpu     8085

;Addresses of 8255 control register, ports etc.
PORTA			equ		08H	; This is address of 8255 PORTA
PORTB			equ		09H	; This is address of 8255 PORTB
PORTc			equ		0AH	; This is address of 8255 PORTC
CW8255        	equ		0BH	; This is address of 8255 control word
;~~~~~~~~~~~~~~~~~~~~~~Start of main program~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

						ORG 7000H
START:		lxi SP,2100H; init stack pointer.
			 mvi A,	80H ; 8255 SET IN I/O MODE	
			 out 0BH
			 mvi A, 80H
			 out 0AH
			 lxi H, L7Ac5H			 mvi A, 0BH
			 mvi B,03H
			 mvi c, 10H
			 mvi D, 0FH
			 mvi E, 0FFFH
			 call 048AH
			 call 0476H
			 mov A,D
			 ani 0FH
			 mov D,A
			 push D
			 lxi H, 7ACCH
			 mvi B, 02H
			 mvi E, 01H
			 call 048H
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
			orA B
			jnz loop2
	loop3:	inx B
			mov A,L
			out 08H
			mov A.H
			ani 7FH
			out 0AH
			ori 80H
			out 0AH
			call 0615H
			dcx H
			mov A,L
			ora H
			jnz loop3
			
			 
			 
			 
			 
			 out 0AH
			 mvi A, 0FH
			 out 0AH
	loop1:	 in 09H
			 ANI  80H
			 JZ loop1
			 mvi A,0EH
			 out 0AH
	loop2:	mvi A, 09H
			out 0AH
			in 09H
			ani 80H
			jnz loop2
			in 09H
			ani 0FH
			mov D,A
			mvi A, 08H
			out 0AH
			in 09H
			mov E,A
			mvi B, 03H
			call 036CH
			call 2072H
			mvi A, 0DH
			call 2078H
			jc loop3
			jmp 0013H
				

