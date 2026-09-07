; Room description applies the original sonic exposure hazard.
LOOK:
        CALL TERNEW
        LD A,(ROOM)
        DEC A
        ADD A,A
        LD E,A
        LD D,0
        LD HL,H_ROOMS
        ADD HL,DE
        LD E,(HL)
        INC HL
        LD D,(HL)
        EX DE,HL
        CALL TERPUT1
        CALL TERNEW
        CALL DYNAMIC
        LD B,24
        LD C,0
        LD HL,OBJS
LOOKOBJ:
        LD A,(ROOM)
        CP (HL)
        JR NZ,LOOKNEXT
        PUSH HL
        LD HL,SEEMSG
        CALL TERPUT1
        LD A,C
        CALL OBJNAME
        CALL TERNEW
        POP HL
LOOKNEXT:
        INC HL
        INC C
        DJNZ LOOKOBJ
        RET
; A zero-based object ID, preserves BC. Clobbers AF DE HL.
OBJNAME:
        ADD A,A
        LD E,A
        LD D,0
        LD HL,H_NAMES
        ADD HL,DE
        LD E,(HL)
        INC HL
        LD D,(HL)
        EX DE,HL
        JP TERPUT1
INVENT:
        LD HL,CARRYMSG
        CALL TERPUT1
        LD HL,OBJS
        LD B,24
        LD C,0
        LD D,0
INVLOOP:
        LD A,(HL)
        CP $FF
        JR NZ,INVNEXT
        PUSH HL
        PUSH DE
        LD A,C
        CALL OBJNAME
        CALL TERNEW
        POP DE
        POP HL
        INC D
INVNEXT:
        INC HL
        INC C
        DJNZ INVLOOP
        LD A,D
        OR A
        RET NZ
        LD HL,NOTHING
        JP TERPUT1
