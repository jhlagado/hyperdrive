; READLINE returns a zero-terminated uppercase line, at most 63 bytes.
; Overflow rejects the entire command. Backspace corrects accepted bytes.
; Ctrl-C returns through CP/M's warm boot. Clobbers main registers.
READLINE:
        LD HL,INBUF
        LD B,0
        XOR A
        LD (INOVER),A
INNEXT:
        CALL TERGET
        CP 3
        JP Z,CPMEXIT
        CP 13
        JR Z,INEND
        CP 10
        JR Z,INEND
        CP 8
        JR Z,INBACK
        CP 127
        JR Z,INBACK
        CP 32
        JR C,INNEXT
        CP 127
        JR NC,INNEXT
        LD C,A
        LD A,B
        CP 63
        JR C,INSTORE
        LD A,1
        LD (INOVER),A
        JR INNEXT
INSTORE:
        LD A,C
        CALL TERPUT
        CP 'a'
        JR C,INUP
        CP 'z'+1
        JR NC,INUP
        SUB 32
INUP:
        LD (HL),A
        INC HL
        INC B
        JR INNEXT
INBACK:
        LD A,B
        OR A
        JR Z,INNEXT
        DEC B
        DEC HL
        LD A,8
        CALL TERPUT
        LD A,32
        CALL TERPUT
        LD A,8
        CALL TERPUT
        JR INNEXT
INEND:
        LD (HL),0
        CALL TERNEW
        RET
; Split first word and remainder, trim spaces at both ends.
SPLIT:
        LD HL,INBUF
SPLLEAD:
        LD A,(HL)
        CP 32
        JR NZ,SPLSTART
        INC HL
        JR SPLLEAD
SPLSTART:
        LD (VERBPTR),HL
SPLWORD:
        LD A,(HL)
        OR A
        JR Z,SPLARG
        CP 32
        JR Z,SPLZERO
        INC HL
        JR SPLWORD
SPLZERO:
        LD (HL),0
        INC HL
SPLARG:
        LD A,(HL)
        CP 32
        JR NZ,SPLSAVE
        INC HL
        JR SPLARG
SPLSAVE:
        LD (ARGPTR),HL
        LD D,H
        LD E,L
SPLTAIL:
        LD A,(HL)
        OR A
        JR Z,SPLTRIM
        INC HL
        CP 32
        JR Z,SPLTAIL
        LD D,H
        LD E,L
        JR SPLTAIL
SPLTRIM:
        XOR A
        LD (DE),A
        RET
; HL and DE zero strings, Z iff equal. Preserves BC, clobbers AF DE HL.
STREQ:
        LD A,(DE)
        CP (HL)
        RET NZ
        OR A
        RET Z
        INC HL
        INC DE
        JR STREQ
; Vocabulary entries: byte command ID, zero string; final byte zero.
; Returns A=ID or zero. Clobbers AF BC DE HL.
PARSE:
        LD HL,VERBS
PARLOOP:
        LD A,(HL)
        OR A
        RET Z
        LD B,A
        INC HL
        PUSH HL
        LD DE,(VERBPTR)
        CALL STREQ
        POP HL
        JR Z,PARFOUND
PARSKIP:
        LD A,(HL)
        INC HL
        OR A
        JR NZ,PARSKIP
        JR PARLOOP
PARFOUND:
        LD A,B
        RET

; Confirmation: Z iff a complete, non-overflowed answer begins Y.
READYES:
        CALL READLINE
        LD A,(INOVER)
        OR A
        JR Z,YESVALID
        LD A,1
        OR A
        RET
YESVALID:
        LD A,(INBUF)
        CP 'Y'
        RET
