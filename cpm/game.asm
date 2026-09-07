; Native CP/M command loop. Core routines use the private application stack.
START:
        LD SP,STACKTOP
        CALL RESET
        LD HL,TITLE
        CALL TERPUT1
        CALL LOOK
MAINLOOP:
        CALL PAGEEND
        LD HL,PROMPT
        CALL TERPUT1
        CALL READLINE
        LD A,(INOVER)
        OR A
        JR Z,MAINPAR
        LD HL,LONGMSG
        CALL TERPUT1
        JR MAINLOOP
MAINPAR:
        CALL SPLIT
        CALL PARSE
        LD (COMMAND),A
        OR A
        JR Z,UNKNOWN
        CALL GAMEPRE
        CALL GATE
        LD A,(COMMAND)
        CP 5
        JP C,MOVE
        CP 5
        JR Z,CMDLOOK
        CP 6
        JR Z,CMDINV
        CP 7
        JR Z,CMDHELP
        CP 8
        JR Z,CMDQUIT
        CP 9
        JR Z,CMDTAKE
        CP 10
        JP Z,CMDDROP
        CP 11
        JP Z,CMDUSE
        CP 12
        JP Z,CMDTRANS
        CP 13
        JP Z,CMDREAD
        CP 14
        JP Z,CMDECHO
        CP 15
        JP Z,CMDFIN
        CP 16
        JP Z,CMDSCORE
        CP 17
        JP Z,CMDSTART
        CP 18
        JP Z,CMSAVE
        CP 19
        JP Z,CMLOAD
UNKNOWN:
        LD HL,UNKNMSG
        CALL TERPUT1
        JP MAINLOOP
CMDLOOK:
        CALL LOOK
        JP MAINLOOP
CMDINV:
        CALL INVENT
        JP MAINLOOP
CMDHELP:
        CALL PGBEGIN
        LD HL,HELPMSG
        CALL TERPUT1
        CALL PAGEEND
        JP MAINLOOP
CMDQUIT:
        LD HL,QUITMSG
        CALL TERPUT1
        CALL READYES
        JP Z,CPMEXIT
        JP MAINLOOP
CMDTAKE:
        CALL GETOBJ
        OR A
        JR Z,UNKNOWN
        DEC A
        LD E,A
        LD D,0
        LD HL,OBJS
        ADD HL,DE
        LD A,(ROOM)
        CP (HL)
        JR NZ,UNAVAIL
        PUSH HL
        LD HL,OBJS
        LD B,24
        LD C,0
TAKECNT:
        LD A,(HL)
        CP $FF
        JR NZ,TAKENEXT
        INC C
TAKENEXT:
        INC HL
        DJNZ TAKECNT
        POP HL
        LD A,C
        CP 11
        JR NC,FULL
        LD (HL),$FF
        JR DONE
CMDDROP:
        CALL GETOBJ
        OR A
        JP Z,UNKNOWN
        DEC A
        LD E,A
        LD D,0
        LD HL,OBJS
        ADD HL,DE
        LD A,(HL)
        CP $FF
        JR NZ,UNAVAIL
        LD A,(ROOM)
        LD (HL),A
DONE:
        CALL TURN
        LD HL,DONEMSG
        CALL TERPUT1
        JP MAINLOOP
UNAVAIL:
        LD HL,ABSENT
        CALL TERPUT1
        JP MAINLOOP
FULL:
        LD HL,FULLMSG
        CALL TERPUT1
        JP MAINLOOP
; Commands1..4 address N,S,W,E; objects and exits remain byte-sized.
MOVE:
        DEC A
        LD C,A
        LD A,(OBJS+7)
        CP $FF
        JR Z,MOVEDIR
        LD B,A
        LD A,(ROOM)
        CP B
        JR Z,MOVEDIR
        CALL RNG
        AND 3
        LD C,A
MOVEDIR:
        LD A,(ROOM)
        DEC A
        ADD A,A
        ADD A,A
        ADD A,C
        LD E,A
        LD D,0
        LD HL,EXITS
        ADD HL,DE
        LD A,(HL)
        OR A
        JR Z,NOWAY
        CP 128
        JR NC,FATAL
        LD (ROOM),A
        CP 2
        JR NZ,MOVETURN
        LD A,1
        LD (DOCKED),A
MOVETURN:
        CALL TURN
        CALL LOOK
        JP MAINLOOP
NOWAY:
        LD HL,NOWAYMSG
        CALL TERPUT1
        JP MAINLOOP
FATAL:
        LD HL,VACUUM
        CP 128
        JR Z,FATPRINT
        LD HL,SHAFT
        CP 129
        JR Z,FATPRINT
        LD HL,AIRLOCK
FATPRINT:
        CALL TERPUT1
        JP AGAIN
DEAD:
        LD HL,DEADMSG
        CALL TERPUT1
        JP AGAIN
TURN:
        LD HL,(TURNS)
        INC HL
        LD (TURNS),HL
        RET
RESET:
        LD HL,STATE
        LD DE,STATE+1
        LD BC,STATEEND-STATE-1
        LD (HL),0
        LDIR
        LD A,1
        LD (ROOM),A
        LD (MATCHLIT),A
        LD HL,$ACE1
        LD (RNGSTATE),HL
        LD HL,H_INIT
        LD DE,OBJS
        LD BC,24
        LDIR
        LD HL,H_EXITS
        LD DE,EXITS
        LD BC,216
        LDIR
        RET
GETOBJ:
        LD HL,(VERBPTR)
        PUSH HL
        LD HL,(ARGPTR)
        LD (VERBPTR),HL
        LD HL,OBJWORDS
        CALL PARLOOP
        POP HL
        LD (VERBPTR),HL
        RET

CMSAVE:
        CALL SAVECMD
        JP MAINLOOP
CMLOAD:
        CALL LOADCMD
        JP MAINLOOP
