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
			 mvi A, 00H
			 out 0AH
			lxi H, 0000H
	loop1:	push H
			mov A,H
			ani 0FH
			mov H,A
			dad H
			dad H
			dad H
			dad H
			mov A,L
			RRc
			RRC
			RRC
			RRC
			ani 09FH
			mov L, A
			mov A, L
			out 0AH
			mov A, H
			out 08H
			pop H
			inx H
			jmp loop1		
		
	