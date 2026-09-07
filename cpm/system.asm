; Adapted from Caverns80 v0.1.1, GPL-3.0; see docs/cpm/architecture.md.
; CP/M console ABI. All output preserves main registers and flags.
; Input returns A (flags undefined), preserving BC DE HL IX IY.
TERPUT:
        PUSH AF
        PUSH BC
        PUSH DE
        PUSH HL
        PUSH IX
        PUSH IY
        LD E,A
        ; Track logical column for raw echo and composed string calls.
        CP 13
        JR Z,TCRESET
        CP 10
        JR Z,TCRESET
        CP 8
        JR Z,TCBACK
        CP 32
        JR C,TCSEND
        LD A,(TERCOL)
        CP 255
        JR Z,TCSEND
        INC A
        LD (TERCOL),A
        JR TCSEND
TCBACK:
        LD A,(TERCOL)
        OR A
        JR Z,TCSEND
        DEC A
        LD (TERCOL),A
        JR TCSEND
TCRESET:
        XOR A
        LD (TERCOL),A
TCSEND:
        LD C,6
        CALL 5
        POP IY
        POP IX
        POP HL
        POP DE
        POP BC
        POP AF
        PUSH AF
        CP 10
        CALL Z,PGLINE
        POP AF
        RET
TERGET:
        PUSH BC
        PUSH DE
        PUSH HL
        PUSH IX
        PUSH IY
GETWAI:
        LD E,$FF
        LD C,6
        CALL 5
        OR A
        JR Z,GETWAI
        POP IY
        POP IX
        POP HL
        POP DE
        POP BC
        RET
 ; HL points to a null-terminated string. All main registers/flags preserved.
; Wrap words at78columns. Lookahead stops after79bytes; a long word makes
; bounded forward progress in78column chunks. State spans composed calls.
TERPUT1:
        PUSH AF
        PUSH BC
        PUSH DE
        PUSH HL
PUTLOO:
        LD A,(PGSKIP)
        OR A
        JP NZ,PUTDON
        LD A,(HL)
        OR A
        JP Z,PUTDON
        CP 33
        JR C,PUTSPACE
        LD D,H
        LD E,L
        LD C,0
PUTSCAN:
        LD A,(DE)
        CP 33
        JR C,PUTFIT
        INC DE
        INC C
        LD A,C
        CP 79
        JR C,PUTSCAN
PUTFIT:
        LD A,(TERCOL)
        OR A
        JR Z,PUTWORD
        ADD A,C
        JR C,PUTBREAK
        CP 79
        JR C,PUTWORD
PUTBREAK:
        CALL TERNEW
PUTWORD:
        LD A,(PGSKIP)
        OR A
        JR NZ,PUTDON
        LD A,(HL)
        CP 33
        JR C,PUTLOO
        LD A,(TERCOL)
        CP 78
        JR C,PUTCHAR
        CALL TERNEW
PUTCHAR:
        LD A,(PGSKIP)
        OR A
        JR NZ,PUTDON
        LD A,(HL)
        CALL TERPUT
        INC HL
        JR PUTWORD
PUTSPACE:
        CP 32
        JR NZ,PUTCTRL
        LD A,(TERCOL)
        CP 78
        JR C,PUTCTRL
        CALL TERNEW
        INC HL
        JR PUTLOO
PUTCTRL:
        LD A,(HL)
        CALL TERPUT
        INC HL
        JR PUTLOO
PUTDON:
        POP HL
        POP DE
        POP BC
        POP AF
        RET
TERNEW:
        PUSH AF
        LD A,13
        CALL TERPUT
        LD A,10
        CALL TERPUT
        POP AF
        RET
; Terminal path: BDOS warm boot returns to CP/M, never an old command.
CPMEXIT:
        LD SP,STACKTOP
        LD C,0
        CALL 5
        JP 0
; Deterministic 16-bit LFSR. A result; flags clobbered; other registers preserved.
RNG:
        PUSH HL
        LD HL,(RNGSTATE)
        SRL H
        RR L
        JR NC,RNGDONE
        LD A,H
        XOR $B4
        LD H,A
RNGDONE:
        LD (RNGSTATE),HL
        LD A,L
        POP HL
        RET
; One byte of presentation workspace (count separately from executable code).
TERCOL: DB 0
