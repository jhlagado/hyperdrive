; HYP1 save codec: format1/rules1,44 payload bytes at16..59.
; CRC16 CCITT-FALSE; header reserved and padding60..127 zero.
; Explicit fields; candidate fully validated before any live publication.
SVENC:
        LD HL,SVBUF
        LD DE,SVBUF+1
        LD BC,127
        LD (HL),0
        LDIR
        LD A,72
        LD (SVBUF+0),A
        LD A,89
        LD (SVBUF+1),A
        LD A,80
        LD (SVBUF+2),A
        LD A,49
        LD (SVBUF+3),A
        LD A,1
        LD (SVBUF+4),A
        LD A,1
        LD (SVBUF+5),A
        LD A,44
        LD (SVBUF+6),A
        LD HL,ROOM
        LD DE,SVBUF+16
        LD BC,1
        LDIR
        LD HL,TURNS
        LD DE,SVBUF+17
        LD BC,2
        LDIR
        LD HL,RNGSTATE
        LD DE,SVBUF+19
        LD BC,2
        LDIR
        LD HL,DOCKED
        LD DE,SVBUF+21
        LD BC,1
        LDIR
        LD HL,OBJS
        LD DE,SVBUF+22
        LD BC,24
        LDIR
        LD HL,SHOTS
        LD DE,SVBUF+46
        LD BC,1
        LDIR
        LD HL,FUTAKEN
        LD DE,SVBUF+47
        LD BC,1
        LDIR
        LD HL,MATCHLIT
        LD DE,SVBUF+48
        LD BC,1
        LDIR
        LD HL,ECHODONE
        LD DE,SVBUF+49
        LD BC,1
        LDIR
        LD HL,SONIC
        LD DE,SVBUF+50
        LD BC,1
        LDIR
        LD A,(EXITS+5)
        LD (SVBUF+51),A
        LD A,(EXITS+36)
        LD (SVBUF+52),A
        LD A,(EXITS+44)
        LD (SVBUF+53),A
        LD A,(EXITS+67)
        LD (SVBUF+54),A
        LD A,(EXITS+78)
        LD (SVBUF+55),A
        LD A,(EXITS+84)
        LD (SVBUF+56),A
        LD A,(EXITS+176)
        LD (SVBUF+57),A
        LD A,(EXITS+191)
        LD (SVBUF+58),A
        LD A,(EXITS+200)
        LD (SVBUF+59),A
        CALL SVCRC
        LD (SVBUF+8),DE
        XOR A
        RET
SVVALID:
        LD A,(SVBUF+0)
        CP 72
        JP NZ,SVBAD
        LD A,(SVBUF+1)
        CP 89
        JP NZ,SVBAD
        LD A,(SVBUF+2)
        CP 80
        JP NZ,SVBAD
        LD A,(SVBUF+3)
        CP 49
        JP NZ,SVBAD
        LD A,(SVBUF+4)
        CP 1
        JP NZ,SVBAD
        LD A,(SVBUF+5)
        CP 1
        JP NZ,SVBAD
        LD A,(SVBUF+6)
        CP 44
        JP NZ,SVBAD
        LD A,(SVBUF+7)
        CP 0
        JP NZ,SVBAD
        LD HL,SVBUF+10
        LD B,6
        CALL SVZEROS
        JP NZ,SVBAD
        LD HL,SVBUF+60
        LD B,68
        CALL SVZEROS
        JP NZ,SVBAD
        CALL SVCRC
        LD HL,(SVBUF+8)
        OR A
        SBC HL,DE
        JP NZ,SVBAD
        LD A,(SVBUF+16)
        DEC A
        CP 54
        JP NC,SVBAD
        LD HL,(SVBUF+19)
        LD A,H
        OR L
        JP Z,SVBAD
        LD A,(SVBUF+21)
        CP 2
        JP NC,SVBAD
        LD A,(SVBUF+47)
        CP 2
        JP NC,SVBAD
        LD A,(SVBUF+48)
        CP 2
        JP NC,SVBAD
        LD A,(SVBUF+49)
        CP 2
        JP NC,SVBAD
        LD A,(SVBUF+50)
        CP 2
        JP NC,SVBAD
        LD HL,SVBUF+22
        LD B,6
SVENEMY:
        LD A,(HL)
        CP 55
        JP NC,SVBAD
        INC HL
        DJNZ SVENEMY
        LD B,18
        LD C,0
SVOBJ:
        LD A,(HL)
        CP 255
        JR NZ,SVROOM
        INC C
        JR SVNEXTO
SVROOM:
        CP 55
        JP NC,SVBAD
SVNEXTO:
        INC HL
        DJNZ SVOBJ
        LD A,C
        CP 12
        JP NC,SVBAD
        LD A,(SVBUF+51)
        CP 0
        JR Z,SVX0
        CP 1
        JP NZ,SVBAD
SVX0:
        LD A,(SVBUF+52)
        CP 11
        JR Z,SVX1
        CP 0
        JP NZ,SVBAD
SVX1:
        LD A,(SVBUF+53)
        CP 11
        JR Z,SVX2
        CP 0
        JP NZ,SVBAD
SVX2:
        LD A,(SVBUF+54)
        CP 0
        JR Z,SVX3
        CP 12
        JP NZ,SVBAD
SVX3:
        LD A,(SVBUF+55)
        CP 0
        JR Z,SVX4
        CP 19
        JP NZ,SVBAD
SVX4:
        LD A,(SVBUF+56)
        CP 53
        JR Z,SVX5
        CP 53
        JP NZ,SVBAD
SVX5:
        LD A,(SVBUF+57)
        CP 46
        JR Z,SVX6
        CP 31
        JP NZ,SVBAD
SVX6:
        LD A,(SVBUF+58)
        CP 0
        JR Z,SVX7
        CP 49
        JP NZ,SVBAD
SVX7:
        LD A,(SVBUF+59)
        CP 0
        JR Z,SVX8
        CP 130
        JP NZ,SVBAD
SVX8:
        XOR A
        RET
SVBAD:
        LD A,1
        OR A
        RET
SVZEROS:
        LD A,(HL)
        OR A
        RET NZ
        INC HL
        DJNZ SVZEROS
        RET
SVAPPLY:
        CALL SVVALID
        RET NZ
        LD HL,SVBUF+16
        LD DE,ROOM
        LD BC,1
        LDIR
        LD HL,SVBUF+17
        LD DE,TURNS
        LD BC,2
        LDIR
        LD HL,SVBUF+19
        LD DE,RNGSTATE
        LD BC,2
        LDIR
        LD HL,SVBUF+21
        LD DE,DOCKED
        LD BC,1
        LDIR
        LD HL,SVBUF+22
        LD DE,OBJS
        LD BC,24
        LDIR
        LD HL,SVBUF+46
        LD DE,SHOTS
        LD BC,1
        LDIR
        LD HL,SVBUF+47
        LD DE,FUTAKEN
        LD BC,1
        LDIR
        LD HL,SVBUF+48
        LD DE,MATCHLIT
        LD BC,1
        LDIR
        LD HL,SVBUF+49
        LD DE,ECHODONE
        LD BC,1
        LDIR
        LD HL,SVBUF+50
        LD DE,SONIC
        LD BC,1
        LDIR
        LD HL,H_EXITS
        LD DE,EXITS
        LD BC,216
        LDIR
        LD A,(SVBUF+51)
        LD (EXITS+5),A
        LD A,(SVBUF+52)
        LD (EXITS+36),A
        LD A,(SVBUF+53)
        LD (EXITS+44),A
        LD A,(SVBUF+54)
        LD (EXITS+67),A
        LD A,(SVBUF+55)
        LD (EXITS+78),A
        LD A,(SVBUF+56)
        LD (EXITS+84),A
        LD A,(SVBUF+57)
        LD (EXITS+176),A
        LD A,(SVBUF+58)
        LD (EXITS+191),A
        LD A,(SVBUF+59)
        LD (EXITS+200),A
        XOR A
        RET
; SVCRC returns DE checksum; leaves SVBUF unchanged.
SVCRC:
        LD HL,SVBUF
        LD DE,$FFFF
        LD B,128
        LD C,0
SVCRBYTE:
        LD A,C
        CP 8
        JR Z,SVCRZERO
        CP 9
        JR Z,SVCRZERO
        LD A,(HL)
        JR SVCRXOR
SVCRZERO:
        XOR A
SVCRXOR:
        XOR D
        LD D,A
        PUSH BC
        LD B,8
SVCRBIT:
        SLA E
        RL D
        JR NC,SVCRNEXT
        LD A,D
        XOR $10
        LD D,A
        LD A,E
        XOR $21
        LD E,A
SVCRNEXT:
        DJNZ SVCRBIT
        POP BC
        INC HL
        INC C
        DJNZ SVCRBYTE
        RET
SVCODEND:
