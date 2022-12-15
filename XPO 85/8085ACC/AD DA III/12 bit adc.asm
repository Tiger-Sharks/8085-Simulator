;*******************************************************************************
;Header: 		Sample program for B

;Monitor utilities used in this program
cpu     8085

;Addresses of 8255 control register, ports etc.
DELAY	EQU			0615H
PORTA			equ		08H	; This is address of 8255 PORTA
PORTB			equ		09H	; This is address of 8255 PORTB
PORTc			equ		0AH	; This is address of 8255 PORTC
CW8255        	equ		0BH	; This is address of 8255 control word
;~~~~~~~~~~~~~~~~~~~~~~Start of main program~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

						ORG 7000H

	START:	lxi SP,2100; init stack pointer.
			call 048AH
			 mvi A,	80H ; 8255 SET IN I/O MODE	
			 out 0BH
			 mvi A, 82H
			 out 0BH
	loop3:	 NOP
			 NOP
			 mvi A, 0BH
			 out 0AH
			 mvi A, 0EH
			 out 0AH
			 mvi A, 0FH
			 out 0AH
	loop1:	 in 09H
			 ANI  80H
			 JZ loop1
			 mvi A,0EH
			 out oAH
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
				

