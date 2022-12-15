;                        TERM.ASM SOURCE LISTING

PAGE    ,132
TITLE   TERM.ASM TERMINAL EMULATOR
;
;
; This program implements a primitive terminal emulator. Keys pressed on
;the system keyboard are sent to the remote host processor via the RS232C
;transmitter.Codes received over the RS232C receiver from the remote host
;are displayed on the screen. Only the CR key is allowed out of all control
;key codes from 00 to IFH. This generates a CR,LF sequence for the screen.
;
; The operator can abort this program by pressing F1.
;
; The serial channel (COMI) is set for 2400 baud, 1 stop, 8 data,
; no parity.
;
; Absolutely no checks are done either for parity errors, framing errors,
; break errors or for device time outs. this routine is PRIMITIVE !
;
; PASCAL DESCRIPTION
;-------------------
;
; var
;  ch           : integer;              {NOT char. Code from keyboard}
;  rch          : char;                 {code received on receiver from host}
;  have key     : boolean;
;begin
;  init com1;           {initialize the COM1 port}
;  have key := false;   {no key pressed on the keyboard waiting to be sent}
;  repeat
;       if have_key then begin
;         if xmt_free then begin
;               send (ch);
;               have key := false;
;       end                     {if have key}
;       else if keypressed then begin
;           have key := true;
;           getkey (ch);        {read from keyboard}
;           if (ch = F1) then exit;     {abort program}
;       end;                    {if not keypressed}
;       if rcvd_code then begin {code received from remote host}
;         rcv(rch);             {get code from receiver}
;         strip_bit7;           {(keep only seven bits}
;         if not control_code then
;            write(rch)         {send to CRT}
;         else of (rch = CR) then
;            write(CR,LF);      {expand CR to CR,LF}
;                               {all other codes gobbled up!}
;       end;                    {if rcvd_code}
;  until false;                 {forever}
;end.
;
;
KF1             EQU     3B00H           ;F1 word code
ROM_KB          EQU     16H             ;INT 16H for keyboard input
ROM_COM         EQU     14H             ;INT 14H for COM RS232C port
DOS_PSTR        EQU     09H             ;SHOW MESG USING INT 21H STRING
DOS             EQU     21H
CR              EQU     0DH
LF              EQU     0AH

;
DSEG            SEGMENT PARA PUBLIC 'DATA'
SPIEL           DB      CR,LF,LF, " TERM.ASM Primitive Terminal Emulator."
                DB      CR,LF,    " {C} Copyright ANSHUMAN, 1990."
                DB      CR,LF,    "______________________________________"
                DB      CR,LF,LF ," You can quit the program with F!."
                DB      "$"
;
CHR             DW      ?               ; code from kdyboard. CH clashes
                                        ; with register CH!
HAVE_KEY        DW      ?               ;bit 0=1 means we have a key waiting
                                        ; to be transmitted
DSEG            ENDS

CSEG            SEGMENT PARA PUBLIC 'CODE'
                ASSUME CS:CSEG,SS:STACK ;ALREADY SET BY DOS LOADER
                
ENTPT           PROC    FAR             ;ENTRY POINT FROM DOS
                PUSH    DS              ;SET UP THE STACK TO HAVE
                XOR     AX,AX           ;THE DOUBLE WORD VECTOR SO THE
                PUSH    AX              ;FAR RETURN WILL GO BACK TO DOS

                MOV     AX,DSEG         ;SET UP ADDRESSABILITY TO
                MOV     DS,AX           ;THE DATA SEGMENT
                ASSUME  DS:DSEG         ;TELL ASSEMBLER WHAT I JUST DID
                MOV     DX,OFFSET SPIEL
                MOV     AH,DOS_PSTR
                INT     DOS             ;Show prompt
                CALL    INIT_COM        ;initialize the COM port
                MOV     HAVE_KEY,0      ;we don't have a key to start with
M10:            TEST    HAVE_KEY,1      ;DO WE HAVE A KEY
                JZ      M20             ;NO
                CALL    XMT_FREE        ;WE HAVE A KEY.IS THE TRANSMITTER
                                        ;FREE ? CY SET IF IT IS
                JNC     M30             ;TRANSMITTER IS NOT FREE,CAN'T SEND
                MOV     AX,CHR          ;TRANSMITTER IS FREE.GET CODE IN AX
                CALL    XMT             ;TRANSMIT AL
                MOV     HAVE_KEY,0      ;DON'T HAVE KEY
M20:            CALL    KEY_PRESSED     ;IF KEY IS PRESSED THEN ZF=0
                JZ      M30             ;IF KEY NOT PRESSED
                MOV HAVE_KEY,1          ;KEY IS PRESSED,SAY SO
                CALL    GETKEY          ;GET KEY CODE IN AX
                CMP     AX,KF1          ;IS THIS THE F1 KEY?
                JE      M500            ;IF YES THEN ABORT
                MOV     CHR,AX          ;ELSE SAVE KEY CODE
M30:            CALL    RCVCHAR         ;IF RECEIVE CHAR AVAILABLE THEN CY SET
                JNC     M10             ;AND CODE IN AL
                                        ;IF NO CHAR AVAILABLE FORM RECEIVER
                                        ;THEN REPEAT LOOP
                AND     AL,7FH          ;STRIP BIT 7
                CMP     AL,20H          ;IS THIS A CONTROL CODE?
                JB      M40             ;YES
                CALL    WRITE           ;NO CONTROL CODE.SEND TO CRT
                JMP     M10             ;REPEAT
M40:            CMP     AL,CR           ;IS THIS A CARRIAGE RETURN ?
                JNE     M10             ;IF NOT THEN IGNORE IT
                CALL    WRITE           ;IF IT IS CR THEN ECHO IT
                MOV     AL,LF
                CALL    WRITE           ;ALONG WITH LF CODE
                JMP     M10             ;REPEAT
;
M500:           RET                     ;RETURN TO DOS
ENTPT           ENDP
;
;------------------------------------------------------------------------------
;       WRITE SENDS THE SINGLE CHARACTER IN AL TO THE CONSOLE
;------------------------------------------------------------------------------
;
WRITE           PROC    NEAR
                PUSH    DX
                MOV     DL,AL           ;CHARACTER IN DL
                MOV     AH,2
                INT     DOS
                POP     DX
                RET
WRITE           ENDP
;
;-------------------------------------------------------------------------------
;       GETKEY WAITS TILL A KEY IS PRESSED & RETURNS WITH THE KEY CODE
;       IN AX. AL USUALLY HAS THE ASCII CODE & AH THE SCAN CODE.
;       USES THE ROM BIOS INT 16H
;-------------------------------------------------------------------------------
;
GETKEY          PROC    NEAR
                MOV     AH,0            ;READ FUNCTION
                INT     ROM_KB
                RET
GETKEY          ENDP
;
;-------------------------------------------------------------------------------
;       KEY_PRESSED RETURNS WITH ZF=0 IF A KEY IS PRESSED. IF PRESSED
;       THEN AX CONTAINS THE SCAN CODE. THE CODE REMAINS IN THE BUFFER
;       OF THE KEYBOARD HANDLER.
;-------------------------------------------------------------------------------
;
KEY_PRESSED     PROC    NEAR
                MOV     AH,1
                INT     ROM_KB
                RET
KEY_PRESSED     ENDP
;
;-------------------------------------------------------------------------------
;       INIT_COM INITILIZES COM1 FOR BAUD 9600, 1 STOP, 8 DATA, NO PARITY
;       ON RETURN AH, AL CONTAINS STATUS CODE AS FOR INT 14H
;------------
;
INIT_COM        PROC    NEAR
                PUSH    DX
                MOV     DX,0            ;COM1
                MOV     AH,0            ;INITILIZE FUNCTIONS
                MOV     AL,10100111B    ;101 = 2400 ,00 = NO PARITY
                                        ;0 = 1 STOP BIT,  11 = 8 DATA
                INT     ROM_COM         ;GO DO IT
                POP     DX
                RET
INIT_COM        ENDP

;
;-------------------------------------------------------------------------------
;XMT_FREE SEES IF THE TRANSMITTER IS FREE TO TRANSMIT ONE MORE CHARACTER
;IF YES CY IS SET,IF NO CY IS RESET.NO CHAR ARE TRANSMITTED.
;-------------------------------------------------------------------------------
;
XMT_FREE        PROC    NEAR
                PUSH    AX
                PUSH    DX
                MOV     DX,0            ;COM1
                MOV     AH,3            ;GET STATUS FUNCTION
                INT     ROM_COM         ;ON RETURN AH BIT 5 = 1,IF XMT HOLDING
                                        ;REGISTER IS EMPTY (XMT AVAILABLE)
                TEST    AH,00100000B    ;IS IT EMPTY ?
                JNZ     XF10            ;YES
                CLC                     ;NO CLEAR CY.XMT NOT AVILABLE
                JMP     SHORT XF20
XF10:           STC                     ;THIS SAYS XMT AVILABLE
XF20:           POP     DX
                POP     AX
                RET
XMT_FREE        ENDP

;-------------------------------------------------------------------------------
;XMT TRANSMITS THE CHAR IN AL ON THE COM1 TRANSMITTER.IT DOES
;NOT CHECK TO SEE IF THE TRANSMITTER IS READY.REPORTS STATUS
;CODES IN AH.
;
;THIS IS A VERY PRIMITIVE ROUTINE.YOU SHOULD CALL XMT_FREE FIRST
;TO SEE IF THE TRANSMITTER IS READY
;-------------------------------------------------------------------------------
;
XMT             PROC    NEAR
                PUSH    DX
                MOV     DX,0            ;COM1
                MOV     AH,1            ;TRANSMIT FUNCTION
                INT     ROM_COM
                POP     DX
                RET
XMT             ENDP

;
;-------------------------------------------------------------------------------
;RCVCHAR RETURNS CY SET IF A CHARACTER IS AVAILABLE ON THE COM1
;RECEIVER.IN THIS CASE AL CONTAINS THE CHAR.IF NONE IS VAILABLE
;THEN RETURNS WITH CY CLEARED.
;-------------------------------------------------------------------------------
;
RCVCHAR         PROC    NEAR
                PUSH    DX
                MOV     DX,0            ;COM1
                MOV     AH,3            ;STATUS FUNCTION
                INT     ROM_COM
                TEST    AH,00000001B
                JZ      RC10            ;NO
                MOV     AH,2            ;YES RECEIVE FUNCTION
                INT     ROM_COM         ;GET IT IN AL
                STC
                JMP     SHORT RC100
RC10:           CLC
RC100:          POP     DX
                RET
RCVCHAR         ENDP
;
CSEG            ENDS

STACK           SEGMENT PARA STACK 'STACK'
                DB      64  DUP ("STACK   ")    ;256 WORD STACK AREA
STACK           ENDS
                END     ENTPT

;----------------------------------------------------------------------------

