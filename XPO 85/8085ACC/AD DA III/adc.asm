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
			 mvi A,	80H ; 8255 SET IN I/O MODE	
			 out 0BH
			 mvi A, 82H
			 out 0BH
	loop3:	 NOP
			 NOP
			 mvi A, 20H
			 out 0AH
			 NOP
			 mvi A, 0A0H  
			 out 0AH
			 
	loop1:	 in 09H
			 ANI  80H
			 JZ loop1
			 mvi A,20H
			 out 0AH
	loop2:	mvi A, 30H
			out 0AH
			in 09H
			ani 80H
			jnz loop2
			in 09H
			ani 0FH
			mov D,A
			mvi A, 20H
			out 0AH
			in 09H
			mov E,A
			mvi B, 03H
			call 036CH
			call 2072H
			mvi A, 0DH
			call 2078H
			jc loop3
			jmp START
				

