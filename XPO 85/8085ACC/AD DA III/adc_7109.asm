;*******************************************************************************
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
			call 048AH
			 mvi A,	93H ; 8255 SET IN I/O MODE	
			 out 0BH
	loop3:   mvi A, 0E0H
			 out 0AH
	loop2:	 in 0AH
			 ani 01H
			 jz loop2
	loop1:	 in 0AH
			 ani 01H
			 jnz loop1
			 in 0AH
			 ani 60H
			 out 0AH
			 in 09H
			 mov E,A
			 in 0AH
			 ori 10H
			 out 0AH
			 NOP
			 in 09H
			 ani 3FH
			 mov D,A
			 ani 10H
			 jnz loop4
			 call 0497H
			 mov A,D
			 ani 20H
			 jz skp1
			 mvi A,"+"
			 call 2078H
			 jmp skp
	skp1: 	mvi A, "-"
			call 2078H
	skp:	mvi B, 03H
			call 036CH
	loop5:  call 2072H
			jc loop3
			jmp 0013H
	loop4:	call 0497H
			mvi A, 4FH
			call 2078H
			mvi A,52H
			call 2078H
			mvi A,20H
			call 2078H
			call 2078H
			jmp loop5
			
	
		
				

