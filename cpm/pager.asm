; Adapted from Caverns80 v0.1.1, GPL-3.0.
; Explicit pagination for story and HELP on a25row terminal.
; PGBEGIN/PAGEEND preserve all registers/flags. PGLINE is called after LF.
; Output pauses after22linefeeds; initial8row allowance reserves the title.
PGBEGIN:
        PUSH AF
        XOR A
        LD (PGSKIP),A
        LD A,8
        LD (PGROWS),A
        LD A,1
        LD (PGON),A
        POP AF
        RET
PAGEEND:
        PUSH AF
        XOR A
        LD (PGON),A
        LD (PGROWS),A
        LD (PGSKIP),A
        POP AF
        RET
PGLINE:
        PUSH AF
        LD A,(PGON)
        OR A
        JR Z,PGRETURN
        LD A,(PGROWS)
        INC A
        LD (PGROWS),A
        CP 22
        JR C,PGRETURN
        PUSH BC
        PUSH DE
        PUSH HL
        ; Prompt output cannot recursively activate the pager.
        XOR A
        LD (PGON),A
        LD HL,PGPROM
        CALL TERPUT1
PGKEY:
        CALL TERGET
        CP 3
        JP Z,CPMEXIT
        CP 32
        JR Z,PGMORE
        CP 13
        JR Z,PGMORE
        CP 10
        JR Z,PGMORE
        CP 27
        JR Z,PGQUIT
        AND $DF
        CP 'Q'
        JR NZ,PGKEY
PGQUIT:
        LD A,1
        LD (PGSKIP),A
PGMORE:
        ; Erase just the prompt; retain every line of story on screen.
        LD A,13
        CALL TERPUT
        LD HL,PGPROM
PGCLEAR:
        LD A,(HL)
        OR A
        JR Z,PGCLEARD
        LD A,32
        CALL TERPUT
        INC HL
        JR PGCLEAR
PGCLEARD:
        LD A,13
        CALL TERPUT
        XOR A
        LD (PGROWS),A
        LD A,1
        LD (PGON),A
        POP HL
        POP DE
        POP BC
PGRETURN:
        POP AF
        RET
PGPROM: DB "[Space/Enter: more, Q: skip] ",0
PGPREND:
