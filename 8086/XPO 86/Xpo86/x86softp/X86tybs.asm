	PAGE 90
	Title-- Decimal counter
;A four digit decimal counter is simulated
;by this program. It is up counter 
;starting from 0000.it increments by one.
;The speed of counting can be changed
;by changing delay count. The display 
;can be frozen by pressing f key. Can be 
;restarted by pressing s key. Pressing 
;ESC  key returns to command mode.
;
X86TYBS 	SEGMENT
ASSUME CS:X86TYBS, DS:X86TYBS ,ES:X86TYBS 
ORG 100H	          ;Com format 
                      ;is recommended.
STRT:	JMP SKIP_DATA   ;skip look up/ 
			    ;data bases if any
;On kit you need to do init for SP[to 
;separate stack of your program from
;monitors], DS as shown below. SS,ES are 
;set to 0000 at power on by monitor. You 
;can of course change it by adding a few 
;more moves. But while working on pc you 
;can't touch segment registers since 
;they are set by dos loader, so manage 
;these instructions as shown in comment 
;field.  

SKIP_DATA:
      MOV AX,10FFH  ;init of sp for kit
  	MOV  AX,AX	  ;mov ax,ax   on pc
	PUSH CS	  ;init for ds 
	POP DS	  ;
			  ;Load kit int's 
			  ;(a0-bf) in pc 
	NOP		  ;by replacing nop's
	NOP 		  ;*******************
	NOP		  ;place call in 
			  ;place of 3 nop`s

	MOV DX,0000H  ;Init of counter
	INT 0ACH	  ;Call CRLF
LOOP1:INT 0ABH	  ;Bring cursor to 
			  ;Leftmost POS by 
			  ;feeding CR only
	MOV AL,04H	  ;Displays given no 
			  ;of(al) digits
			  ;from present 
			  ;cursor pos.
	INT 0AEH
	MOV AL,DL	  ;Fetch lower 
			  ;byte of counter
	ADD AL,01H	  ;Increment it
	DAA		  ;decimaly
	MOV DL,AL	  ;Save lower byte
	MOV AL,DH	  ;Fetch upper 
                    ;byte of counter
	ADC AL,00H	  ;Inc if carry
	DAA
	MOV DH,AL	  ;save upper byte
	MOV CX,4000H  ;delay count
	INT 0AAH
	MOV AH,0BH
	INT 0A1H	  ;Test kbd or 
			  ;consol in to check
	CMP AL,00H	  ;If any key pressed
	JZ LOOP1	  ;no continue counting
	MOV AH,08H	  ;Read key
	INT 0A1H
	CMP AL,"F"	  ;Check(f) key pressed
	JZ SKP01
	CMP AL,1BH	  ;ESC key pressed?
	JNZ LOOP1
	INT 0A3H	  ;Ret to command mode. 
			  ;On PC Ret to dos. 
SKP01:MOV AH,08H	  ;Poll kbd or consol 
			  ;continuously
	INT 0A1H	  ;till key pressed
	CMP AL,"S"	  ;'S' key pressed?
	JZ LOOP1
	JMP SKP01

;If you are running your software on PC
;Insert here -->include kit_ints.asm
						  
X86TYBS	ENDS 
    END 	STRT
                                                                              
