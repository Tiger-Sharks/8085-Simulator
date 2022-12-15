;REMOVE SHORT LINK 1,2
;OF L15
;AND ALSO REMOVE 6 PIN CONNECTOR WHEN NOT IN USE
;to give a pulse hold an obstacle
;or your little finger between
;IR diode and photo transistor.
CPU "8085.TBL"
HOF"INT8"
CRLF:EQU 048AH
OUTMSG: EQU 03D8H
TEST: EQU 01F1H
NMOUT: EQU 036CH
DELAY: EQU 0615H
CRONLY:EQU 0497H
ORG 6000H	
MVI C,00H
MVI D,00H
MVI A,0B0H	;Initialise counter 2 
OUT 1BH		;in mode 0
MVI A,1FH	;give maximum count LSB
OUT 1AH		; to be counted
MVI A,00H	;give count MSB
OUT 1AH
CALL CRLF	;clear display
SSS:IN 1AH	;read counter LSB
MOV C,A		;and store in C
MVI A,1FH	;Substract the count
SUB C		;in counter register
MOV C,A		;and store in C
IN 1AH		;read counter MSB
MOV D,A		;and store in D
NOP
INR C		;increment the count
MOV E,C		;move contents of C 
MVI B,02H	;to B to display the count
CALL NMOUT	;display the count
CALL CRONLY	;move th cursor to LHS
MOV A,C		;CHECK whether the count
XRI 1FH		;has reached last count
JZ LOOP		;if yes goto command mode		
CALL TEST	;check for key press
JC SSS		;if no key start counting
LOOP:RST 1

