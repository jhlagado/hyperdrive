; Utility commands do not change puzzle state or consume a turn.
GAMEPRE:
        LD A,(COMMAND)
        CP 5
        JP C,PRECMD
        CP 9
        RET C
        CP 13
        RET NC
        JP PRECMD
; Source puzzle mutations performed before recognized commands (BASIC178-186).
PRECMD:
        LD A,(ROOM)
        CP 11
        JR NZ,PREVAULT
        XOR A
        LD (EXITS+36),A
        LD (EXITS+44),A
PREVAULT:
        LD A,(ROOM)
        CP 50
        JR NZ,PREFUSE
        LD A,53
        LD (EXITS+84),A
        LD A,31
        LD (EXITS+176),A
PREFUSE:
        LD A,(OBJS+23)
        CP 17
        JR Z,PREPOD
        LD A,1
        LD (FUTAKEN),A
        JR PREMINE
PREPOD:
        LD A,(FUTAKEN)
        OR A
        JR Z,PREMINE
        LD A,12
        LD (EXITS+67),A
PREMINE:
        LD A,(ROOM)
        CP 49
        RET NZ
        LD A,49
        LD (EXITS+191),A
        RET
; A object1..24, Z if carried or in room. Preserve BC; clobber AF DE HL.
AVAIL:
        DEC A
        LD E,A
        LD D,0
        LD HL,OBJS
        ADD HL,DE
        LD A,(HL)
        CP $FF
        RET Z
        LD A,(ROOM)
        CP (HL)
        RET
CMDUSE:
        CALL GETOBJ
        OR A
        JP Z,UNKNOWN
        LD (OBJECT),A
        CALL AVAIL
        JP NZ,UNAVAIL
        LD A,(OBJECT)
        CP 18
        JP Z,MATCHUSE
        CP 19
        JR Z,SCREWUSE
        CP 20
        JR Z,BLASTUSE
        CP 22
        JR Z,ROPEUSE
        LD HL,NOEFFECT
        CALL TERPUT1
        JP MAINLOOP
BLASTUSE:
        CALL TURN
        CALL SHOOT
        CP 1
        JP Z,AGAIN
        CP 2
        JP Z,NEWROOM
        JP MAINLOOP
SCREWUSE:
        LD A,(ROOM)
        CP 2
        JR Z,SCREWY
        CP 27
        JR NZ,NOTOPEN
        LD A,54
        JR SCREWDO
SCREWY:
        LD A,1
SCREWDO:
        LD B,A
        LD A,(ROOM)
        LD (OBJS+18),A
        LD A,B
        LD (ROOM),A
        CALL TURN
        LD HL,OPENMSG
        CALL TERPUT1
        JP NEWROOM
NOTOPEN:
        LD HL,LOCKMSG
        CALL TERPUT1
        JP MAINLOOP
ROPEUSE:
        LD A,(ROOM)
        CP 28
        JR NZ,NOTOPEN
        LD A,28
        LD (OBJS+21),A
        LD A,27
        LD (ROOM),A
        CALL TURN
        LD HL,ROPEMSG
        CALL TERPUT1
        JP NEWROOM
MATCHUSE:
        LD A,9
        CALL AVAIL
        JR Z,MATCHBOM
        XOR A
        LD (MATCHLIT),A
        LD HL,MATCHOUT
        CALL TERPUT1
        JP MAINLOOP
MATCHBOM:
        LD A,(MATCHLIT)
        OR A
        JR Z,MATCHBAD
        LD A,(ROOM)
        CP 2
        JR NZ,MATCHAIR
        LD A,1
        LD (EXITS+5),A
MATCHAIR:
        LD A,(ROOM)
        CP 51
        JR NZ,MATCHMOV
        LD A,130
        LD (EXITS+200),A
MATCHMOV:
        LD A,(ROOM)
        CP 1
        JR Z,MATCHCLR
        DEC A
        LD (ROOM),A
        CP 20
        JR NZ,MATCHCLR
        LD A,19
        LD (EXITS+78),A
MATCHCLR:
        XOR A
        LD (OBJS+8),A
        CALL TURN
        LD HL,BOOMMSG
        CALL TERPUT1
        JP NEWROOM
MATCHBAD:
        LD HL,MATCHOUT
        CALL TERPUT1
        JP MAINLOOP
CMDTRANS:
        LD A,(ROOM)
        CP 16
        JR NZ,TRANSIN
        LD A,(OBJS+16)
        CP $FF
        JR NZ,TRANSIN
        LD HL,(ARGPTR)
        LD A,(HL)
        OR A
        JR NZ,TRANSCOD
        LD HL,CODEMSG
        CALL TERPUT1
        CALL READLINE
        LD A,(INOVER)
        OR A
        JP NZ,UNKNOWN
        LD HL,INBUF
TRANSCOD:
        LD A,(HL)
        CP 'Y'
        JR Z,TRANSY
        CP 'B'
        JR Z,TRANSB
        CP 'C'
        JR Z,TRANSC
        JP UNKNOWN
TRANSY:
        LD A,1
        JR TRANSSET
TRANSB:
        LD A,31
        JR TRANSSET
TRANSC:
        LD A,41
        JR TRANSSET
TRANSIN:
        LD A,16
TRANSSET:
        LD (ROOM),A
        CALL TURN
        LD HL,TRANSMSG
        CALL TERPUT1
        JP NEWROOM
CMDREAD:
        LD A,(ROOM)
        CP 31
        JR Z,READMAP
        CP 16
        JR Z,READCODE
        LD A,17
        CALL AVAIL
        JR Z,READCODE
        LD A,13
        CALL AVAIL
        JR NZ,READNONE
        LD HL,BOOKMSG
        JR READOUT
READMAP:
        LD HL,CHARTMSG
        JR READOUT
READCODE:
        LD HL,CODEMSG
        JR READOUT
READNONE:
        LD HL,READMSG
READOUT:
        CALL TERPUT1
        JP MAINLOOP
CMDECHO:
        LD A,(ROOM)
        CP 47
        JP NZ,UNKNOWN
        LD A,1
        LD (ECHODONE),A
        LD HL,ECHOMSG
        CALL TERPUT1
        JP MAINLOOP
NEWROOM:
        CALL LOOK
        JP MAINLOOP
