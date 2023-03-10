; PROGRAM TO CARRY OUT INSERTION SORT ALGORITHM ON AN ARRAY.
; SORTING IS IN ASCENDING ORDER. i.e. SMALLEST ELEMENT AT TOP AND
; LARGEST ELEMENT AT BOTTOM. TO CHANGE THIS CHANGE THE JBE INSTRUCTION ON
; LINE 55 TO JGE.

COMSEG SEGMENT
	ASSUME CS:COMSEG, DS:COMSEG, SS:COMSEG, ES:COMSEG
	
	ORG 0100H			;ORG FOR COM STRUCTURED PROGRAMS (ALL SEGMENTS IN ONE SEGMENT
						;AND PROGRAM MAXIMUM SIZE 64KBYTES.)
	
START:
	JMP SKIP_DATA		;SKIP OVER DATA DECLARATIONS

;--------------DEFINE DATA SIZES AND NAMES--------	

MTABLE DW 87H,98H,12H,43H
COUNT DW 4

;--------------END OF DATA DEFINITION-------------

SKIP_DATA:
	MOV AX,10FFH
	MOV SP,AX
	
	MOV AX,0000H
	MOV SS,AX
	MOV ES,AX
	
	PUSH CS
	POP DS
	
	NOP
	NOP
	NOP	
    
; AX IS DATA HOLDER (INDEX)
; BX IS FOR LOOP COUNTER (I)
; CX IS WHILE LOOP COUNTER (J)
; SI POINTS TO CURRENT DATA TO BE COMPARED (SI = SI+SI FOR EVERY FOR ITERATION)

	MOV CX,COUNT			;INIT OUTER FOR LOOP
	MOV SI,OFFSET MTABLE + 2
FOR_LOOP:
	MOV AX,DS:[SI]		;INDEX = NUMBERS[I]
	MOV DI,SI			;J = I

WHILE_LOOP:
    CMP DI,OFFSET MTABLE
    JLE WHILE_END
    
	CMP AX,DS:[DI-2]		;NUMBERS[J-1] > ITEM
	JGE WHILE_END
	
	MOV BX,DS:[DI-2]
	MOV DS:[DI],BX			;NUMBERS[J] = NUMBERS[J-1]
	
	DEC DI
	DEC DI
	JMP WHILE_LOOP
WHILE_END:	
	MOV DS:[DI],AX
	INC SI
	INC SI

	LOOP FOR_LOOP
EXIT:	            
	INT 0A5H
	
COMSEG ENDS
END START

;Implemented algorithm for insertion sort.
         
;  for (i=1; i < array_size; i++)
;  {
;    index = numbers[i];
;    j = i;
;    while ((j > 0) && (numbers[j-1] > index))
;    {
;      numbers[j] = numbers[j-1];
;      j = j - 1;
;    }
;    numbers[j] = index;
;  }