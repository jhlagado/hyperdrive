; Original BASIC 211-227,289-310. See docs/cpm/combat.md (spoilers).
; ENCOUNTR: A=first enemy ID 1..6, or zero. Preserves BC DE HL IX IY.
; Flags undefined. Does not change state or advance randomness.
ENCOUNTR:
        PUSH BC
        PUSH HL
        LD HL,OBJS
        LD B,6
        LD C,1
C_SCAN:
        LD A,(ROOM)
        CP (HL)
        JR Z,C_FOUND
        INC HL
        INC C
        DJNZ C_SCAN
        XOR A
        JR C_EDONE
C_FOUND:
        LD A,C
C_EDONE:
        POP HL
        POP BC
        RET
; SHOOT: A=0 normal,1 dead,2 abducted (caller displays new room).
; Preserves BC DE HL IX IY, flags undefined. Consumes randomness only
; with both an enemy and an available blaster. SHOTS is a saved byte.
SHOOT:
        PUSH BC
        PUSH DE
        PUSH HL
        CALL ENCOUNTR
        OR A
        LD HL,C_NONE
        JP Z,C_NORMAL
        LD E,A
        LD A,(OBJS+19)
        CP $FF
        JR Z,C_FIRE
        LD D,A
        LD A,(ROOM)
        CP D
        LD HL,C_NOGUN
        JP NZ,C_NORMAL
C_FIRE:
        LD A,(SHOTS)
        CP 255
        JP Z,C_FATAL
        INC A
        LD (SHOTS),A
        CP 17
        JP NC,C_FATAL
        CP 11
        JR C,C_SAFE
        SUB 11
        LD C,A
        LD B,0
        LD HL,C_RISK
        ADD HL,BC
        LD B,(HL)
        CALL RNG
        CP B
        JP C,C_FATAL
        JR C_AIM
C_SAFE:
        ; Retain the original two random draws even before danger rises.
        CALL RNG
C_AIM:
        CALL RNG
        CP 97
        JR C,C_HIT
        LD A,E
        CP 5
        JR Z,C_ABDUCT
        CALL RNG
        AND 3
        ADD A,A
        LD C,A
        LD B,0
        LD HL,C_MISSES
        ADD HL,BC
        LD A,(HL)
        INC HL
        LD H,(HL)
        LD L,A
        JP C_NORMAL
C_HIT:
        ; A floor weapon must not exceed the eleven-object carry limit.
        LD HL,OBJS
        LD B,24
        LD C,0
C_COUNT:
        LD A,(HL)
        CP $FF
        JR NZ,C_NEXT
        INC C
C_NEXT:
        INC HL
        DJNZ C_COUNT
        LD A,C
        CP 11
        JR NC,C_TARGET
        LD A,$FF
        LD (OBJS+19),A
C_TARGET:
        LD A,E
        DEC A
        LD C,A
        LD B,0
        LD HL,OBJS
        ADD HL,BC
        LD A,E
        CP 3
        JR Z,C_RETRET
        CP 5
        JR Z,C_RETRET
        XOR A
        JR C_SET
C_RETRET:
        LD A,(HL)
        ADD A,10
        CP 55
        JR C,C_SET
        XOR A
C_SET:
        LD (HL),A
        LD HL,C_HITMSG
        JR C_NORMAL
C_ABDUCT:
        LD A,33
        LD (ROOM),A
        LD A,(OBJS+4)
        ADD A,7
        CP 55
        JR C,C_ABSET
        XOR A
C_ABSET:
        LD (OBJS+4),A
        LD HL,C_ABMSG
        CALL TERPUT1
        LD A,2
        JR C_RETURN
C_FATAL:
        LD HL,C_DEATH
        CALL TERPUT1
        LD A,1
        JR C_RETURN
C_NORMAL:
        CALL TERPUT1
        XOR A
C_RETURN:
        POP HL
        POP DE
        POP BC
        RET
; Byte quantization of death probability (F-10)/7 for F=11..16.
C_RISK: DB 37,73,110,146,183,219
C_MISSES: DW C_MISS0,C_MISS1,C_MISS2,C_MISS3
C_NONE: DB "There is nothing to destroy here.",13,10,0
C_NOGUN: DB "You do not have a blaster here.",13,10,0
C_HITMSG:
        DB "Your well-aimed shot sends the badly damaged machine scuttling away.",13,10,0
C_ABMSG:
        DB "The rusty drone picks you up and carries you to another place.",13,10,0
C_DEATH:
        DB "Your shot misses. The machine deals you a fatal wound.",13,10,0
C_MISS0:
        DB "You fire, but the machine moves aside.",13,10,0
C_MISS1:
        DB "The machine is damaged, but attacks again.",13,10,0
C_MISS2:
        DB "Your shot damages the machine slightly. It attacks again.",13,10,0
C_MISS3:
        DB "You miss. It fights back with a logical calmness that alarms you.",13,10,0
