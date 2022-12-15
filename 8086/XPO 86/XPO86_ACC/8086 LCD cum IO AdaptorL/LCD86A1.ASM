;*******************************************************************************
;Header: 		Sample program for character LCD interfacing with 8086 via 8255
;File Name: 	LCD86A1.asm
;Author: 		Technobits, Pune (www.technobits.in)
;Date created:	Feb 21, 2009
;Assembler:		MASM.EFXE

;Description:
;This program is written to display character 'A' continuously
;on character LCD in the first row, first column.

;*******************************************************************************

;-------------------------------------------------------------------------------
;								MAIN PROGRAM
;Input:					Nothing
;Output:				Nothing
;Calls to Subroutines:	SendLCDCMD, SendLCDDAT, Monitor utilities

;Connections:
;8255 (Lower i.e. U23) is used to connect with LCD in the following manner

;8255 PORT B (PB0-PB7)	<->		LCD data bus D0-D7
;8255 PORT C (PC3)		-->		LCD ENABLE
;8255 PORT C (PC4)		<->		LCD R/W (READ=1, WRITE=0)
;8255 PORT C (PC3)		-->		LCD RS (0=Command register, 1=Data register)

;8255 is connected as memory mapped device.
;A0, A1, RD, WR are controlled automatically when specified memory location is addressed.
;LCD used is 16x1. Internally it is treated as 8x2 line display.
;-------------------------------------------------------------------------------

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


;Addresses of 8255 control register, ports etc.
LCD_DATABUS			equ		8002H	; This is address of 8255 PORTB
PORTC_8255			equ		8004H	; This is address of 8255 PORTC
cONTROL_ADDR_8255	equ		8006H	; This is address of 8255 control word

;Other misclleneous
DISP_CHAR			equ		'A'		; character to display on LCD

;~~~~~~~~~~~~~~~~~~~~~~Start of main program~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CHLCD86	 SEGMENT
ASSUME CS:COMSEG, DS:COMSEG, ES:COMSEG

						ORG 0100H



	mov		DX,		cONTROL_ADDR_8255	;8255 Control word address loaded in DX
	mov		AL,		80H					;8255 control word to set all ports as O/P in mode 0
	out		DX,		AL					;Send control word to 8255

	mov		AL,			38H				;LCD function set (8bit interface, 2line, 5x7 font)
	call	SendLCDCMD					;Send the command (code in A) to LCD

	mov		AL,			0CH				;LCD on, CUrsor off, blink off
	call	SendLCDCMD					;Send the command (code in A) to LCD

	mov		AL,			01H				;Clear display and return cursor to home position
	call	SendLCDCMD					;Send the command (code in A) to LCD

	mov		AL,			80H				;LCD DDRAM address set to 1st line 1st char
	call	SendLCDCMD					;Send the command (code in A) to LCD

	mov		AL,			DISP_CHAR		;Get the data to be displayed
	call	SendLCDDAT					;Send the data (in A) to LCD

	INT		0A3H						;Monitor Return to command position

;~~~~~~~~~~~~~~~~~~~~~~End of main program~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;								Subroutine SendLCDCMD
;--------------------------------------------------------------------------------
;Description:
;This subroutine sends the data in accumulator to PORT B of 8255.
;LCD command register is enabled by making RS=0 and RW=0.
;LCD is enabled by making EN=1 and then EN=0.
;Called by:				MAIN program
;Calls subroutines:		Monitor Utility DELAY
;Input:					LCD command code in Accumulator
;Output:				Nothing
;--------------------------------------------------------------------------------

SendLCDCMD:						;Subroutine start label

	mov		DX,			LCD_DATABUS	;Load 8255 address (PORT B) in DX
	out		DX,			AL			;Send data to 8255 port B (LCD data bus).

	mov		DX,			PORTC_8255	;Load 8255 address (PORT C) in DX
	mov		AL,			08H			;RS=0 (Command reg), RW=0 (Write mode), EN=1
	out		DX,			AL			;Send data to 8255 port c.

	mov		AL,			00H			;RS=0 (Command reg), RW=0 (Write mode), EN=0
	out		DX,			AL			;Send data to 8255 port c.

	;Delay so LCD completes write operation

	mov		CX,			00FFH		;Value loaded for DELAY utility
	INT		0AAh					;Implement delay

	ret								;End of subroutine
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;								Subroutine SendLCDDAT
;--------------------------------------------------------------------------------
;Description:
;This subroutine sends the data in accumulator to PORT B of 8255.
;LCD data register is enabled by making RS=1 and RW=0.
;LCD is enabled by making EN=1 and then EN=0.

;Called by:				MAIN program
;Calls subroutines:		Monitor Utility DELAY
;Input:					LCD data to be displayed in Accumulator
;Output:				Nothing
;--------------------------------------------------------------------------------

SendLCDDAT:								;Subroutine start

	mov		DX,			LCD_DATABUS	;Load 8255 address (PORT B) in DX
	out		DX,			AL			;Send data to 8255 port B (LCD data bus).

	mov		DX,			PORTC_8255	;Load 8255 address (PORT C) in DX
	mov		AL,			28H			;RS=1 (Data reg), RW=0 (Write mode), EN=1
	out		DX,			AL			;Send data to 8255 port c.

	mov		AL,			20H			;RS=1 (Data reg), RW=0 (Write mode), EN=0
	out		DX,			AL			;Send data to 8255 port c.


;Delay so LCD completes write operation

	mov		CX,			00FFH		;Value loaded for DELAY utility
	INT		0AAh					;Implement delay

	ret								;End of subroutine
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	CHLCD86	ENDS
	end								;This is end of program
	
	