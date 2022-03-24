;SCRDUMP.S -- Dec. 2nd, 1998
;Author: Douglas Beattie Jr.
;Source code is for ZMASM, Zilog Macro Cross Assembler (640K DOS version)
;ZMASM is available from my home page,
;  URL http://www2.whidbey.net/~beattidp/
;
        ORG     6000H
;
        JP      ENTRY
        defw    1               ;reserve 1 word (2 bytes)
                                ;  -- put MEMPTR here
;
;**************************************************************
;       U T I L I T Y   R O U T I N E S
;
;converts bits 3..0 to ASCII HEX
HXDGT   AND     0FH
        ADD     A,90H
        DAA
        ADC     A,40H
        DAA
        RET

;returns with C-flag set if printable ASCII
ckASC   CP      128
        JR      C,$ASCok
        CP      32
        CCF
$ASCok  RET

;convert byte pointed to by HL to hex ASCII in BC, C:MSD, B:LSD
; destroys A, BC
cvHX    LD      C,A
        CALL    HXDGT
        LD      B,A
        LD      A,C
        RRA
        RRA
        RRA
        RRA
        CALL    HXDGT
        LD      C,A

;write two bytes from C and B to buffer at (DE) with increment
OUPB    LD      A,C
        LD      (DE),A
        INC     DE
        LD      A,B
        LD      (DE),A
        INC     DE
        RET

;send a space to buffer at (DE) with increment
SPAC    LD      A,' '
        LD      (DE),A
        INC     DE
        RET

LINESIZ EQU     80      ;80x24 screen
VIDRAM  EQU     0F800H
VIDPTR  DEFW    VIDRAM+0
VIDSIZ  EQU     1920

;clear video screen -- note: must be in video memory map mode.
CLRSCR  LD      HL,VIDRAM
        LD      DE,VIDRAM+1
        LD      BC,VIDSIZ-1
        LD      (HL),' '
        LDIR
        RET

;Carriage-Return/LineFeed
CRLF    PUSH    HL
        LD      HL,(VIDPTR)
        LD      DE,LINESIZ
        ADD     HL,DE
        LD      (VIDPTR),HL
        EX      DE,HL           ;also return it in DE
        POP     HL
        RET

;
;**************************************************************
;       M A I N   P R O G R A M
;

ENTRY   LD      SP,5FFEH
        LD      HL,ENTRY        ;set (gimick) for re-entry every time.
        PUSH    HL
;
;select 2K video RAM in high memory
;
        LD      C,84H
        LD      E,86H
        OUT     (C),E

        CALL    CLRSCR          ; clear the screen
;
        LD      HL,(MEMPTR)
        LD      DE,(VIDPTR)
        LD      C,10            ;do ten lines for the test.
lp02    PUSH    BC
        PUSH    DE              ;save video pointer
        LD      A,H             ;p/u MSB of current address
        CALL    cvHX            ;convert to hex ascii
        LD      A,L             ;and LSB
        CALL    cvHX            ;convert to hex ascii
        CALL    SPAC
        PUSH    HL              ;save mem pointer to show ascii
        LD      B,16            ;each line has 16 bytes.
lp01    PUSH    BC              ;save loop counter
        LD      A,(HL)          ;get the byte from memory
        INC     HL
        CALL    cvHX            ;convert to hex ascii
        CALL    SPAC
        POP     BC
        DJNZ    lp01
        POP     HL              ;recover mem pointer

        LD      B,16            ;each line has 16 bytes.
lp01a   PUSH    BC
        LD      A,(HL)
        INC     HL
        CALL    ckASC
        JR      C,gd
        LD      A,'.'
gd      LD      (DE),A
        INC     DE
        POP     BC

        DJNZ    lp01a
        POP     DE              ;recover video pointer
        CALL    CRLF            ;buffer pointer -> next line

        POP     BC
        DEC     C               ;and repeat for count
        JR      NZ,lp02

        DI
        HALT

;        ORG     6000H

MEMPTR  DEFW    4000H            ;start of full-screen hex dump.

        END     ENTRY
; ********************************************************************

