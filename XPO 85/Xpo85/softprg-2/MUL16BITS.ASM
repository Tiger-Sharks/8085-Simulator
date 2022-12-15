;Program for 16-bit multiplication
	    CPU 8085
	    org 6000h
		lxi sp,27f0h
	    lhld 2100h
	    mov b,h
	    mov c,l
	    lhld 2102h
	    mov d,h
	    mov e,l
	    mov a,e         ;bc*de=de,hl
	    push d          ;Load lowest order byte of
                        ;m'plier/save highest
					    ;order m'plier
	    call BMULT     ;Byte 1 mult
	    xthl           ;Save lowest order byte product  
	                   ;,Get M'plier    
		push psw       ;Store h-order byte of product
	    mov a,h
	    call BMULT
	    mov d,a         ;Position h-order byte of product
	    pop psw
	    add h
	    mov e,a
	    jnc MUNC1      ;don't decr d if no CY
	    inr d
MUNC1:  mov h,l
	    mvi L,00h
	    pop b
	    dad b          ;Get final product l-order 2-byte
	    Jnc end
	    inx d
	    jmp end
BMULT:  lxi h,0000h    ;1 byte *2 byte MUL
        lxi d,0007h	   ;Bit counter 
        add a
BMULUP1:jnc BMU0
        dad b
		adc d
BMU0:   dad h          ;Shift product left
        adc a
		dcr e
		jnz BMULUP1
		rnc 
		dad b
		adc d
		ret
END:	shld 2104h    ;Lower 16-bit
		xchg          ;Upper 16-bit
		shld 2106h
		rst 1