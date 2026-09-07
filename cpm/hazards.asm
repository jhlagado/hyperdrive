; GATE can abandon its caller only through MAINLOOP/NEWROOM/AGAIN.
; It drops the GATE return address on those paths. Pure utility commands
; remain usable around enemies and inside the echo puzzle.
GATE:
        LD A,(COMMAND)
        CP 5
        JR C,GATEACT
        CP 9
        RET C
        CP 13
        RET NC
GATEACT:
        LD A,(ROOM)
        CP 47
        JR NZ,GATEFOE
        LD A,(ECHODONE)
        OR A
        JR NZ,GATEFOE
        LD HL,ECHOWAIT
        CALL TERPUT1
        POP HL
        JP MAINLOOP
GATEFOE:
        CALL ENCOUNTR
        OR A
        RET Z
        LD B,A
        LD A,(COMMAND)
        CP 11
        JR NZ,GATEKILL
        PUSH BC
        CALL GETOBJ
        POP BC
        CP 20
        RET Z
GATEKILL:
        LD A,B
        CP 5
        JR Z,GATEAB
        POP HL
        JP DEAD
GATEAB:
        LD A,33
        LD (ROOM),A
        LD A,(OBJS+4)
        ADD A,7
        CP 55
        JR C,GATESET
        XOR A
GATESET:
        LD (OBJS+4),A
        LD HL,C_ABMSG
        CALL TERPUT1
        POP HL
        JP NEWROOM
; Called by LOOK. Original sonic hazard counts room descriptions.
; Rejected commands, HELP and disk operations never call LOOK implicitly.
DYNAMIC:
        CALL AIRTEXT
        LD A,(ROOM)
        CP 50
        JR NZ,DYNLAD
        LD A,(OBJS+10)
        CP 50
        JR NZ,DYNLAD
        LD A,(SONIC)
        OR A
        JR NZ,DYNDIE
        INC A
        LD (SONIC),A
        LD HL,SONICMSG
        CALL TERPUT1
DYNLAD:
        LD A,(ROOM)
        CP 10
        JR Z,DYNLOW
        CP 12
        JR NZ,DYNECHO
        LD A,(EXITS+44)
        JR DYNBRK
DYNLOW:
        LD A,(EXITS+36)
DYNBRK:
        OR A
        JR NZ,DYNECHO
        LD HL,LADDERMS
        CALL TERPUT1
DYNECHO:
        LD A,(ROOM)
        CP 47
        RET NZ
        LD A,(ECHODONE)
        OR A
        RET NZ
        LD HL,ECHOWAIT
        JP TERPUT1
DYNDIE:
        LD HL,SONICDIE
        CALL TERPUT1
        JP AGAIN
DEADMSG: DB "The hostile machine attacks before you can act. Your adventure ends.",13,10,0

; The recovered game's atmosphere is warning-only: BASIC24 returns to input.
; Preserve that nonfatal policy; normalized action turns replace parser counts.
AIRTEXT:
        LD HL,(TURNS)
        LD A,H
        OR A
        JR NZ,AIRLOW
        LD A,L
        CP 201
        JR C,AIRROOM
AIRLOW:
        LD HL,AIRWARN
        CALL TERPUT1
AIRROOM:
        LD A,(ROOM)
        CP 18
        RET C
        LD A,(OBJS+20)
        CP $FF
        RET Z
        LD B,A
        LD A,(ROOM)
        CP B
        RET Z
        LD HL,FUMEMSG
        JP TERPUT1
AIRWARN: DB "Your oxygen supply is running low.",13,10,0
FUMEMSG: DB "The air is poisoned by fumes. You struggle to breathe.",13,10,0
