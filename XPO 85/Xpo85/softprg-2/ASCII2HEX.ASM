	cpu 8085

; Convert ascii representation of a decimal number stored at 2100h to
; its hex equivalent (Subtract 30h).Store the hexadecimal
; equivalent to location 2101h

	org 6855h		;Four bytes blank after previous program
	start:
		mvi b,0ffh	;Error indicator
		lda 2100h	;Get number to accumulator
		sui 30h
		jc done 	;Number was not in ascii converted form
		
		cpi 0ah		;Carry is produced if accumulator < 0ah
		jnc done
		mov b,a
	done:
		mov a,b
		sta 2101h
		rst 1

;Last address used by the program 1ADBh == 6875