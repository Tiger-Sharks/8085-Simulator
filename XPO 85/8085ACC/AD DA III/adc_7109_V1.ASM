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
START:		lxi SP,2100H      ; init stack pointer.
			call 048AH
			 mvi A,	93H      ; 8255 SET IN I/O MODE	
			 out 0BH
	loop3:   mvi A, 0E0H     ; pc7=1-run mode, lben=4-pc4=0
			 out 0AH
	loop2:	 in 0AH
			 ani 01H
			 jz loop2    ; check till conversion really begun
	loop1:	 in 0AH
			 ani 01H
			 jnz loop1   ; end of conversion
			 in 0AH
			 ani 60H     ;pc7=0- hold mode 
			 out 0AH
			 in 09H			; read port b
			 mov E,A
			 in 0AH
			 ori 10H		;PC4=1
			 out 0AH
			 NOP
			 in 09H		; read port b upper byte
			 mov c,A
			 ani 0FH
			 mov D,A
			 call 0497H
			 mov A,C
			 RLC
			 jc skp1	; show -ve
			 RLC
			 jc skip4	; show OR
			 mvi A,"-"
			 call 2078H
			 jmp skp
			 RLC
			 jc skip4
	skp1: 	mvi A, "+"
			call 2078H
	skp:	mvi B, 03H
			call 036CH
	loop5:  call 2072H
			jc loop3
			jmp 0013H
	skip4:	call 0497H
			mvi A, 4FH
			call 2078H
			mvi A,52H
			call 2078H
			mvi A,20H
			call 2078H
			call 2078H
			jmp loop5
			
	
		
				

