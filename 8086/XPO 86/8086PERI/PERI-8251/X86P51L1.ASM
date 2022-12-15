LIST  :  1 (A)

This programme demonstrates 8251 Periware in Asynchronous Mode of operation using polling

0000	CPU  "8085.TBL"				< CUB >
0000	HOF  "INTB"
		MONITOR UTILITIES EQUATES
04EA  =	CRLF:	EQU  04EAH
04C8  =	RCVNO:	EQU  04C8H
06C7  =	DELAY:	EQU  06C7H
4560  =	DSPLY:	EQU  4560H

	         PORT NOS EQUATES
00F0  =		DP:	EQU  0F0H
00F1  =		CP:	EQU  0F1H

	         PROGRAMME START
4510		ORG  4510H
4510  3E  00		MVI  A,00H	                   ; Dummy Code.
4512  D3  F1		OUT CP
4514  CD  EA  04	CALL CRLF	                   ; Clear screen. Give delay.
4517  D3  F1		OUT CP	                   ; Dummy Code.
4519  CD  EA  04	CALL CRLF
451C  D3  F1		OUT CP	                   ; Dummy Code.
451E  CD  EA  04	CALL CRLF
4521  3E  40		MVI  A,40H
4523  D3  F1		OUT CP	                   ; Reset code
4525  CD  EA  04	CALL CRLF
4528  3E  4D		MVI  A,4DH
452A  D3  F1		OUT CP	                   ; Mode word, Stop Bits=1, 
                                                                                             ; Character length=8 Bits
452C  CD  EA  04	CALL CRLF	                   ; Baud Rate Factor = 1
452F  3E   27		MVI  A,27H
4531  D3  F1		OUT CP	                   ; Command Word, RxEnable=1, 
			                   ; TxEnable=1 DSR=1
4533  DB  F1	   LOOP1:	IN CP	                   ; Check for transmitter ready.
4535  E6  81		ANI  81H	                   ; If not then remain in loop and 
                                                                                             ; wait
4537  FE  81		CPI  81H	
4539  C2  33  45		JNZ  LOOP1
453C  C1		POP B	                  ; Remove programme counter
                                                                                           ; from stack.
453D  CD EA  04	CALL CRLF	                  ; Set cursor to left.
4540  21   8E  45	LXI  H, MSGBY   	          ; Pointer for look up table
4543  06   02		MVI  B, 02H
4545  0E  10		MVI  C,10H
4547  CD  C8  04	CALL RCVNO	                 ; Routine to receive number
454A  7B		MOV  A,E


454B  D3  F0		OUT  DP	                   ; Send data to Transmitter Buffer
454D DB  F1	LOOP2:	IN  CP		                       ; Check for receiver ready.
454F  E6  02		ANI  02H	                    ; If no then remain in loop and 
                                                                                             ; wait
4551  FE  02		CPI  02H	
4553  C2  4D  45	JNZ  LOOP2
4556  DB  F0		IN DP	                    ; Receive the data from
                                                                                            ;  receiver output
4558  CD  60  45	CALL DSPLY	                    ; Displays the byte on seven segs.
4558  CF		RST  1	                    ; Go to Command Mode.

	       NOTE: Following ISR is used by all the Modes of 8251
	MONITOR UTILITIES EQUATES
04EA  =		CRLF:	         EQU  04EAH
0410  =		OUTMSG:  EQU  0410H
06C7  =		DELAY:      EQU  06C7H
0340  =		NMOUT:     EQU  0340H

4560		ORG  4560H
4560  32  E0  20	   DSPLY:	STA  20E0H	                    ; Store received data in memory
4563  3E  00		MVI  A,00H	                    ; Set cursor.
4565  32  8F  20		STA  208FH
4568  21  89  45		LXI  H,MSGDA                    ; Pointer for look up table.
456B CD 10  04		CALL OUTMSG                   ; Calls display routine
456E  0E  03		MVI  C,03H	                    ; Set counter for delay
4570  11  FF  FF	   LOOP3:	LXI  D,0FFFFH	                    ; Wait to stabilise the display
4573  CD C7 06	                     CALL DELAY	                    ; Call delay routine
4576  3E   06		MVI  A,06H	                    ; Set cursor to seventh display
4578  32   8F  20	STA  208FH
457B  06  02		MVI  B,02H	                    ; Number of digits to be displayed					; in data segment.
457D  3A  E0  20	LDA  20E0H	                    ; Load the data back to the ACC
4580  5F		MOV  E,A
4581  CD  40  03	CALL NMOUT	                    ; NMOUT routine is called
4584   0D		DCR  C
4585  C2  70  45 	JNZ  LOOP3
4588  C9		RET

4589   44  41544103MSGDA:  DFB "DATA", 03H
458E   42  59544503MSGBY:  DFB "BYTE", 03H

LIST  :  1 (B)

This programme demonstrates 8251 Periware in Asynchronous Mode of operation using Interrupt RST 5.5.

	PROGRAMME START
45A0	ORG  45A0H
45A0  21  F0  65	LXI  H,65F0H	            ; Address of ISR.
45A3  22   55  20	SHLD  2055H
45A6  3E   0E	MVI  A,0EH	; Unmask RST 5.5
45A8  30	SIM
45A9  3E   00	MVI  A,00H	; Dummy code.
45AB  D3  E1	OUT CP
45AD  CD EA  04	CALL CRLF	; Clear screen. Give delay.
45B0   D3  F1	OUT  CP	; Dummy code
45B2  CD  EA  04	CALL CRLF	
45B5  D3  F1	OUT  CP	; Dummy code	
45B7  CD  EA  04	CALL CRLF
45BA  3E  40	MVI  A,40H
45BC  D3  F1	OUT CP	; Reset code
45BE  CD  EA  04	CALL CRLF
45C1  3E  4D	MVI  A,4DH
45C3  D3  F1	OUT CP	; Mode word, Stop Bits=1, 
		; Character length=8 Bits
45C5  CD  EA  04	CALL CRLF	; Baud Rate Factor =1.
45C8  3E  27	MVI  A,27H
45CA  D3  F1	OUT  CP	; Command word, RxEnable=1, 
		; TxEnable=1DSR=1
45CC  DB  F1     LOOP4:	IN CP	; Check for transmitter ready
45CE   E6  81	ANI  81H	; if no then remain in loop
                                                                                             ; and wait.
45D0  FE  81	CPI  81H	
45D2  C2  CC  45	JNZ  LOOP4
45D5  C1	POP  B	; Remove programme counter  
                                                                                             ; from stack.                    
45D6  CD  EA  04	CALL CRLF	; Set cursor to left
45D9  21  8E  45	LXI  H,MSGBY	; Pointer for look up table.
45DC  06  02	MVI  B,02H
45DE  0E  10	MVI  C,10H
45E0  CD  C8  04	CALL RCVNO	; Routine to receive number
45E3  7B	MOV  A,E
45E4  D3  F0	OUT DP	; Send data to Transmitter Buffer
45E6  FB          HERE:	EI
45E7  C3  E6  45	JMP  HERE





                                   ISR for receiving data byte

45F0	ORG  45F0H
45F0  F3	DI	; Disable Interrupt
45F1  DB  F0	IN  DP	; Receive the data from 
		; receiver output.
 45F3  CD  60  45	CALL DSPLY	; Displays the byte on seven     
                                                                                            ; segments.
45F6  CF	RST  1	; Go to Command Mode.









































LIST  :  2 (A)

This programme demonstrates 8251 Periware in its Synchronous Mode of operation. It uses Internal Sync Detection for the operation of receiver.

	   PROGRAMME START
4600	ORG  4600H
4600  CD  EA  04	CALL CRLF	; Set cursor to left position. 
                                                                                             ; Clear screen
4603  3E  00	MVI  A,00H	; Dummy Code
4605  D3  F1	OUT  CP
4607  CD  EA  04	CALL CRLF	; Clear screen. Give delay
460A  D3  F1	OUT  CP	; Dummy Code
460C  CD  EA  04	CALL CRLF	
460F  D3  F1	OUT  CP	; Dummy Code
4611  CD  EA  04	CALL CRLF
4614  3E  40	MVI  A,40H
4616  D3  F1	OUT  CP	; Reset code
4618  CD  EA  04	CALL CRLF
461B  3E  8C	MVI  A,8CH	; Mode word, Character 
		; Length=8 Bits
461D  D3  F1	OUT  CP	; Internal SYNC detect, no. of 
                                                                                             ; SYNC Char = 1
461F  CD  EA  04	CALL CRLF
4622  3E  AA	MVI  A, 0AAH	; SYNC Character
4624  D3  F1	OUT  CP
4626  3E  B5	MVI  A,0B5H	; Command word, RxEnable=1, 
				; TxEnable=1, Error
4628  D3  F1	OUT  CP	; Reset=1, Enter Hunt Mode.
462A  DB F1           LOOP5:	IN  CP	; Check for transmitter ready.
		; if no then remain in loop and  
                                                                                             ; wait.
462C  E6  01	ANI  01H
462E  CA  2A  46	JZ  LOOP5
4631  C1	POP  B	; Remove programme counter 
                                                                                             ; form stack.
4632  CD  EA  04	CALL CRLF	; Set cursor to left
4635  21  8E  45	LXI  H,MSGBY	; Pointer for look up table.
4638  06  02	MVI  B,02H
463A  0E  10	MVI  C,10H
463C  CD  C8  04	CALL RCVNO	; Routine to receive number
463F  7B	MOV  A,E
4640  D3  F0	OUT  DP	; Send SYNC Char to Transmitter 
                                                                                             ; Buffer.
4642  CD  EA  04    LOOP6:	CALL CRLF
4645  DB  F1	IN  CP	; Check for SYNDET pin	
4647  E6  40	ANI  40H	; if no then remain in loop and  
464B  C2  42  46	JNZ  LOOP6
464E   C1                                POP B                                  ; Remove Programme Counter 
                                                                                             ; from stack.
464F  CD  EA 04                    CALL CRLF                         ; Set cursor to left
4652  21   8E  45                    LXI H,MSGBY                     ; Pointer for look up table.
4655  06   02                          MVI B,02H
4657  0E   10                          MVI C,10H
4659  CD  C8  04                   CALL RCVNO                      ; Routine to receive number
465C  7B                                MOV  A,E                              
465D  D3  F0                         OUT  DP                               ; Send data byte to Transmitter
                                                                                            ; Buffer.
465F  0E   02                         MVI C,02H                           ; Counter for no. of  bytes to be
                                                                                            ; transmitted.
4661  CD  EA  04    LOOP7:  CALL CRLF
4664  DB   F1                         IN  CP                                  ; Check for receiver ready   
4666  E6    02                          ANI 02H                             ; if no then remain in loop
                                                                                           ; and wait.         
4668  FE  02	CPI  02H
466A  C2  61  46	JNZ  LOOP7
466D  C5	PUSH  B
466E  CD  EA  04	CALL CRLF
4671  DB  F0	IN  DP                                  ; Receive the data from
                                                                                           ; receiver output. 	  
4673  CD  60  45	CALL DSPLY                      ; Displays the byte on seven 
                                                                                           ; segments.
4676  C1	POP  B
4677  0D	DCR  C
4678  C2  61  46	JNZ  LOOP7
467B  CF                                RST 1                                  ; Go to Command Mode.





















LIST  :  2 (B)

This programme demonstrates 8251 Periware in its Synchronous Mode of operation. It uses External Sync Detection for the operation of receiver.

	PROGRAMME START
4690	ORG  4690H
4690  CD  EA  04	CALL CRLF	; Set cursor to left position. 
                                                                                             ; Clear screen. 
4693  3E  00	MVI  A,00H	; Dummy code
4695  D3  F1	OUT  CP
4697  CD  EA  04	CALL CRLF	; Clear screen. Give delay.
469A  D3  F1	OUT  CP	; Dummy code
469C  CD  EA  04	CALL CRLF
469F  D3  F1	OUT  CP	; Dummy code
46A1 CD  EA  04	CALL CRLF
46A4  3E  40	MVI  A,40H
46A6  D3  F1	OUT  CP	; Reset code
46A8  CD  EA  04	CALL  CRLF 
46AB  3E  CC	MVI  A,0CCH	; Mode Word, Character 
		; Length  = 8 Bits.
46AD  D3  F1	OUT  CP	; External SYNC detect, no. of 
                                                                                             ; SYNC Char = 1
46AF  CD  EA  04	CALL CRLF
46B2  3E  AA	MVI  A,0AAH	; SYNC Character
46B4  D3  F1	OUT  CP	
46B6  3E  95	MVI  A,95H	; Command word, RxEnable=1, 
		; TxEnable=1, Error
46B8  D3  F1 	OUT  CP	; Reset=1
46BA  DB  F1       LOOP8 :	IN  CP	; Check for transmitter ready.
46BC  E6  01	ANI  01H	; If no then remain in loop and 
                                                                                             ; wait.
46BE  FE  01	CPI  01H
46C0  C2  BA  46	JNZ  LOOP8
46C3  C1	POP  B	; Remove Programme Counter 
                                                                                             ; from stack.
46C4  CD  EA  04	CALL CRLF	; Set cursor to left
46C7  21  8E  45	LXI  H,MSGBY	; Pointer for look up table.
46CA  06  02	MVI  B,02H
46CC  0E  10	MVI  C,10H
46CE  CD  C8  04	CALL  RCVNO	; Routine to receive number
46D1  7B	MOV  A,E
46D2  D3  F0	OUT  DP	; Send data byte to Transmitter 
                                                                                             ; Buffer.



       
 Make SYNDET input pin high by connecting it to Vcc.
46D4  0E  02	MVI  C,02H	; Counter for no. of bytes to be 
		;  transmitted.
46D6  CD  EA  04   LOOP9 :	CALL  CRLF
46D9  DB  F1	IN  CP	; Check for receiver ready
46DB  E6  02	ANI  02H	; if no then remain in loop and 
                                                                                             ; wait.
46DD  FE  02	CPI  02H
46DF  C2  D6  46	JNZ  LOOP9
46E2  C5	PUSH  B
46E3  CD  EA  04	CALL CRLF
46E6  DB  F0	IN  DP	; Receive the data from 	 
                                                                                             ; receiver output.
46E8  CD  60  45	CALL DSPLY	; Displays the byte on seven 
                                                                                             ; segments.
46EB  C1	POP  B
46EC  05	DCR  B
46ED  C2  D6  46	JNZ  LOOP9
46F0  CF	RST  1	; Go to Command Mode.


************ END OF FILE ***********


  






















LIST  :  1 (A)

This programme demonstrates 8251 Periware in Asynchronous Mode of operation using polling

0000	CPU  "8085.TBL"			< CLASSIK >
0000	HOF  "INT8"
	 	MONITOR UTILITIES EQUATES
048A  =	CRLF:	EQU  048AH
0476  =	RCVNO:	EQU  0476H
0615  =	DELAY:	EQU  0615H
6560  =	DSPLY:	EQU  6560H

	  	PORT NOS EQUATES
00F0  =		DP:	EQU  0F0H
00F1  =		CP:	EQU  0F1H

	 	PROGRAMME START
6510		ORG  6510H
6510  3E  00		MVI  A,00H	; Dummy code.
6512  D3  F1		OUT CP
6514  CD  EA  04	CALL CRLF	; Clear screen. Give delay.
6517  D3  F1		OUT CP	; Dummy code.
6519  CD  EA  04	CALL CRLF
651C  D3  F1		OUT CP	; Dummy code.
651E  CD  8A  04	CALL CRLF
6521  3E  40		MVI  A,40H
6523  D3  F1		OUT CP	; Reset code
6525  CD  8A  04	CALL CRLF
6528  3E  4D		MVI  A,4DH
652A  D3  F1		OUT CP	; Mode word, Stop Bits=1, 
			; Character Length=8 Bits
652C  CD  8A  04	CALL CRLF	; Baud Rate Factor = 1
652F  3E  27		MVI  A,27H
6531  D3  F1		OUT CP	; Command Word, Rx 
			; Enable=1,  TxEnable=1 
			; DSR=1
6533  DB  F1	LOOP1:	IN CP	; Check for transmitter ready.
6535  E6  81		ANI  81H	; If no then remain in loop and 
                                                                                             ; wait.
6537  FE  81		CPI  81H	
6539  C2  33  65		JNZ  LOOP1
653C  C1		POP B	; Remove programme counter 
                                                                                             ; from stack.
653D  CD  8A  04	CALL CRLF	; Set cursor to left.
6540  21  8E  45		LXI  H, MSGBY	; Pointer for look up table
6543  06  02		MVI  B, 02H
6545  0E  10		MVI  C,10H
6547  CD  76  04	CALL RCVNO	; Routine to receive number
654A  7B		MOV  A,E
654B  D3  F0		OUT  DP	; Send data to Transmitter Buffer

654D  DB  F1	   LOOP2:	IN  CP	; Check for receiver ready.
654F  E6  02		ANI  02H	; If no then remain in loop and 
                                                                                             ; wait.
6551  FE  02		CPI  02H	
6553  C2  4D  65	JNZ  LOOP2
6556  DB  F0		IN DP	; Receive the data from
                                                                                             ; receiver output.
6558  CD  60  45	CALL DSPLY	; Displays the byte on seven 
                                                                                             ; segments
655B  CF		RST  1	 ; Go to Command Mode.

	         NOTE: Following ISR is used by all the Modes of 8251
	         MONITOR UTILITIES EQUATES
048A  =		CRLF:	  EQU  048AH
03DB  =		OUTMSG:  EQU  03D8H
0615  =		DELAY:	EQU  0615H
036C  =		NMOUT:	EQU  036CH

6560		ORG  6560H
6560  32  E0 20	   DSPLY:	STA  20E0H	 ; Store received data in memory
6563  3E  00		MVI  A,00H	 ; Set cursor.
6565  32  8F  20		STA  208FH
6568  21  89  65		LXI  H,MSGDA                     ; Pointer for look up table.
656B  CD D8 03	CALL OUTMSG                    ; Calls display routine
656E  0E  03		MVI  C,03H	                     ; Set Counter for delay
6570  11  FF  FF   LOOP3:	LXI  D,0FFFFH	                     ; Wait to stabilise the display
6573  CD 15  06		CALL DELAY	                     ; Calls delay routine
6576  3E  06		MVI  A,06H	                     ; Set cursor to seventh display
6578  32  8F  20		STA  208FH
657B  06  02		MVI  B,02H	                    ; Number of digits to be displayed
			                     ; in data segment.
657D  3A  E0  20	LDA  20E0H	                    ; Load the data back to the ACC
6580  5F		MOV  E,A
6581  CD  6C 03	CALL NMOUT	                    ; NMOUT routine is called
6584  0D		DCR  C
6585  C2 70 65		JNZ  LOOP3
6588  C9		RET

6589   44  41544103MSGDA:  DFB "DATA", 03H
658E   42  59544503MSGBY:  DFB "BYTE", 03H

		


LIST  :  1 (B)

This programme demonstrates 8251 Periware in Asynchronous Mode of operation using Interrupt RST 5.5.

                                   PROGRAMME START
65A0	ORG  65A0H
65A0  21  F0  65	LXI  H,65F0H	; Address of ISR.
65A3  22  55  20	SHLD  2055H
65A6  3E  0E	MVI  A,0EH	; Unmask RST 5.5
65A8  30	SIM
65A9  3E  00	MVI  A,00H	; Dummy code.
65AB  D3  F1	OUT CP
65AD  CD  8A  04	CALL CRLF	; Clear screen. Give delay.
65B0  D3  F1	OUT  CP	; Dummy code
65B2  CD  8A  04	CALL CRLF	
65B5  D3  F1	OUT  CP	; Dummy code	
65B7  CD  8A  04	CALL CRLF
65BA  3E  40	MVI  A,40H
65BC  D3  F1	OUT CP	; Reset code
65BE  CD  8A  04	CALL CRLF
65C1  3E  4D	MVI  A,4DH
65C3  D3  F1	OUT CP	; Mode word, Stop Bits=1, 
		; Character Length=8 Bits
65C5  CD  8A  04	CALL CRLF	; Baud Rate Factor =1.
65C8  3E  27	MVI  A,27H
65CA  D3  F1	OUT  CP	; Command Word, 
                                                                                            ; RxEnable=1, TxEnable=1
		; DSR=1
65CC  DB  F1         LOOP4:	IN CP	; Check for transmitter ready
65CE  E6  81	ANI  81H	; If no then remain in loop and 
                                                                                            ; wait.	        
65D0  FE  81	CPI  81H	
65D2  C2  CC  65	JNZ  LOOP4
65D5  C1		POP  B	; Remove programme counter 
			; from stack
65D6  CD  8A  04	CALL CRLF	; Set cursor to left
65D9  21  8E  65	LXI  H,MSGBY	; Pointer for look up table.
65DC  06  02	MVI  B,02H
65DE  0E  10	MVI  C,10H
65E0  CD  76  04	CALL RCVNO	; Routine to receive number
65E3  7B	MOV  A,E
65E4  D3  F0	OUT DP	; Send data to Transmitter Buffer
65E6  FB                 HERE:   EI
65E7  C3  E6  65	JMP  HERE
	                                   


                                   ISR for receiving data byte
65F0	ORG  65F0H
65F0  F3	DI	; Disable Interrupt
65F1  DB  F0	IN  DP	; Receive the data from receiver 
                                                                                             ; output.
65F3  CD  60  65	CALL DSPLY	; Displays the byte on seven 
                                                                                             ; segments.
65F6  CF	RST  1	; Go to Command Mode.



































LIST  :  2 (A)

This programme demonstrates 8251 Periware in its Synchronous Mode of operation. It uses Internal Sync Detection for the operation of receiver.

                                   PROGRAMME START
6600	ORG  6600H
6600  CD  8A  04	CALL CRLF	; Pointer to new line.
6603  3E  00	MVI  A,00H	; Dummy code
6605  D3  F1	OUT  CP
6607  CD  8A  04	CALL CRLF	; Clear screen. Give delay
660A  D3  F1	OUT  CP	; Dummy code
660C  CD  8A  04	CALL CRLF	
660F  D3  F1	OUT  CP	; Dummy code
6611  CD  8A  04	CALL CRLF
6614  3E  40	MVI  A,40H
6616  D3  F1	OUT  CP	; Reset code
6618  CD  8A  04	CALL CRLF
661B  3E  8C	MVI  A,8CH	; Mode word, Character 
		; Length=8 Bits
661D  D3  F1	OUT  CP	; Internal SYNC Detect, 
		; no. of SYNC Char=1
661F  CD  8A  04	CALL CRLF
6622  3E  AA	MVI  A, 0AAH	; SYNC Character
6624  D3  F1	OUT  CP
6626  3E  B5	MVI  A,0B5H	; Command Word,
                                                                                             ; RxEnable=1, TxEnable=1,  
6628  D3  F1	OUT  CP	; Error reset=1, enter Hunt Mode.
662A  DB  F1         LOOP5:	IN  CP	; Check for transmitter ready.
		; If no then remain in loop and 
                                                                                             ; wait.
662C  E6  01	ANI  01H
662E  CA  2A  66	JZ  LOOP5
6631  C1	POP  B	; Remove Programme Counter 
                                                                                             ; from stack.
6632  CD  8A  04	CALL CRLF	; Set cursor to left
6635  21  8E  65	LXI  H,MSGBY	; Pointer for look up table.
6638  06  02	MVI  B,02H
663A  0E  10	MVI  C,10H
663C  CD  76  04	CALL RCVNO	; Routine to receive number
663F  7B	MOV  A,E
6640  D3  F0	OUT  DP	; Send SYNC Char to Transmitter 
                                                                                             ; Buffer.
6642  CD  8A  04    LOOP6:	CALL CRLF
6645  DB  F1	IN  CP	; Check for SYNDET pin	
6647  E6   40	ANI  40H	; If no then remain in loop and 
                                                                                             ; wait.
6649  FE   40	CPI  40H
664B  C2  42  66	JNZ  LOOP6
664E  C1	POP  B	; Remove programme counter 
                                                                                             ; from stack.
664F  CD  8A  04	CALL CRLF	                       ; Set cursor to left
6652   21   8E  65	LXI  H,MSGBY	; Pointer for look up table.
6655   06   02	MVI  B,02H
6657   0E  10	MVI  C,10H
6659   CD 76  04	CALL RCVNO	; Routine to receive number
665C  7B	MOV  A,E
665D  D3  F0	OUT  DP	; Send data byte to Transmitter 
                                                                                             ; Buffer.
665F  0E   02	MVI  C,02H	; Counter for no. of bytes to be 
		;  transmitted.
6661  CD  8A  04    LOOP7:	CALL CRLF
6664  DB  F1	IN  CP	; Check for receiver ready .
6666  E6   02	ANI  02H	; If no then remain in loop and 
                                                                                             ; wait.
6668  FE   02	CPI  02H
666A  C2  61  66	JNZ  LOOP7
666D  C5	PUSH  B
666E  CD  8A  04	CALL CRLF
6671  DB  F0	IN  DP	; Receive the data from receiver 
                                                                                             ; output.
6673  CD  60  65	CALL DSPLY	; Displays the byte on seven 
                                                                                             ; segments.
6676  C1	POP  B
6677  0D	DCR  C
6678  C2   61  66	JNZ  LOOP7
667B  CF	RST  1	; Go to Command Mode.





LIST  :  2 (B)

This programme demonstrates 8251 Periware in its Synchronous Mode of operation. It uses External SYNC Detection for the operation of receiver.

	PROGRAMME START
6690	ORG  6690H
6690  CD  8A  04	CALL CRLF	; Set cursor to left position. 
                                                                                             ; Clear screen.
6693  3E   00	MVI  A,00H	; Dummy code
6695  D3   F1	OUT  CP
6697  CD  8A  04	CALL CRLF	; Clear screen. Give delay.
669A  D3  F1	OUT  CP	; Dummy code
669C  CD 8A  04	CALL CRLF
669F  D3  F1	OUT  CP	; Dummy code
66A1 CD  8A  04	CALL CRLF
66A4  3E  40	MVI  A,40H
66A6  D3  F1	OUT  CP	; Reset code
66A8  CD 8A  04	CALL  CRLF 
66AB  3E  CC	MVI  A,0CCH	; Mode word, Character 
		; Length = 8 Bits.
66AD  D3  F1	OUT  CP	; External SYNC Detect, 
		; no. of SYNC Char=1
66AF  CD  8A  04	CALL CRLF
66B2  3E   AA	MVI  A,0AAH	; Sync Character
66B4  D3   F1	OUT  CP	
66B6  3E   95	MVI  A,95H	; Command Word,
                                                                                             ; RxEnable=1, TxEnable=1, 
66B8  D3  F1 	OUT  CP	; Error Reset=1
66BA  DB F1    LOOP8	IN  CP	; Check for transmitter ready.
66BC  E6  01	ANI  01H	; If no then remain in loop and 
                                                                                             ; wait.
66BE  FE  01	CPI  01H
66C0  C2  BA  66	JNZ  LOOP8
66C3  C1	POP  B	; Remove Programme Counter 
                                                                                             ; from stack.
66C4  CD  8A  04	CALL CRLF	; Set cursor to left
66C7  21   8E   65	LXI  H,MSGBY	; Pointer for look up table.
66CA  06  02	MVI  B,02H
66CC  0E  10	MVI  C,10H
66CE  CD  76  04	CALL  RCVNO	; Routine to receive number
66D1  7B	MOV  A,E
66D2  D3  F0	OUT  DP	; Send data byte to Transmitter 
                                                                                             ; Buffer.




                                   Make SYNDET input pin high by connecting it to Vcc.
66D4  0E  02	MVI  C,02H	; Counter for no. of bytes to be 
		;  transmitted.
66D6  CD  8A 04    LOOP9:	CALL  CRLF
66D9  DB  F1	IN  CP	; Check for receiver ready
66DB  E6  02	ANI  02H	; If no then remain in loop and 
                                                                                             ; wait.
66DD  FE   02	CPI  02H
66DF  C2   D6  66	JNZ  LOOP9
66E2  C5	PUSH  B
66E3  CD  8A  04	CALL CRLF
66E6  DB  F0	IN  DP	; Receive the data from receiver 
                                                                                             ; output.
66E8  CD  60  65	CALL DSPLY	; Displays the byte on seven 
                                                                                             ; segments.
66EB  C1	POP  B
66EC  05	DCR  B
66ED  C2  D6  66	JNZ  LOOP9
66F0  CF	RST  1	; Go to Command Mode.


************ END OF FILE ***********


