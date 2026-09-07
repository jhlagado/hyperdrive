; Salvage objects7..17 are worth1..11 carried, double in the yacht.
GETSCORE:
        LD HL,OBJS+6
        LD B,11
        LD C,1
        LD E,0
SCLOOP:
        LD A,(HL)
        CP 1
        JR Z,SCBANK
        CP $FF
        JR NZ,SCNEXT
        LD A,E
        ADD A,C
        LD E,A
        JR SCNEXT
SCBANK:
        LD A,E
        ADD A,C
        ADD A,C
        LD E,A
SCNEXT:
        INC HL
        INC C
        DJNZ SCLOOP
        LD A,E
        RET
CMDSCORE:
        CALL SHOWSCOR
        JP MAINLOOP
SHOWSCOR:
        CALL GETSCORE
        PUSH AF
        LD HL,SCOREMSG
        CALL TERPUT1
        POP AF
        LD L,A
        LD H,0
        CALL PRIWOR
        LD HL,MOVESMSG
        CALL TERPUT1
        LD HL,(TURNS)
        CALL PRIWOR
        CALL TERNEW
        RET
CMDFIN:
        LD A,(ROOM)
        CP 1
        JR NZ,FINWRONG
        LD A,(DOCKED)
        OR A
        JR Z,FINWRONG
        LD HL,FINASK
        CALL TERPUT1
        CALL READYES
        JP NZ,MAINLOOP
        CALL SHOWSCOR
        LD HL,REPAIR
        CALL TERPUT1
        CALL GETSCORE
        CP 80
        LD HL,EXPLODE
        JR C,FINPRINT
        CP 110
        LD HL,STRANDED
        JR C,FINPRINT
        CP 126
        LD HL,HALFSPD
        JR C,FINPRINT
        LD HL,VICTORY
FINPRINT:
        CALL TERPUT1
        JP AGAIN
FINWRONG:
        LD HL,FINWHERE
        CALL TERPUT1
        JP MAINLOOP
CMDSTART:
        LD HL,RESTARTQ
        CALL TERPUT1
        CALL READYES
        JP Z,START
        JP MAINLOOP
AGAIN:
        LD SP,STACKTOP
        CALL PAGEEND
        LD HL,AGAINMSG
        CALL TERPUT1
        CALL READYES
        JP Z,START
        JP CPMEXIT
DECDIV: DW 10000,1000,100,10,1
SCOREMSG: DB "Salvage score: ",0
MOVESMSG: DB ". Moves: ",0
FINASK: DB "Repair the yacht and launch now? (Y/N) ",0
FINWHERE: DB "Return to your yacht with salvage before launching.",13,10,0
RESTARTQ: DB "Abandon this game and restart? (Y/N) ",0
AGAINMSG: DB "Another adventure? (Y/N) ",0
REPAIR: DB "You spend the next day repairing your yacht with the equipment",13,10
 DB "you found on the wreck. You manoeuvre into space and engage Hyperdrive.",13,10,0
EXPLODE: DB "The drive overloads and explodes, blowing you into cosmic dust.",13,10,0
STRANDED: DB "The Hyperdrive fails to engage. You drift in space. Perhaps someone",13,10
 DB "will hear your mayday.",13,10,0
HALFSPD: DB "The Hyperdrive engages! You are limited to half speed, but you will",13,10
 DB "get home.",13,10,0
VICTORY: DB "The alien Hyperdrive is superior to your old drive. You can achieve",13,10
 DB "speeds greater than ever before! Selling it could make you one of the",13,10
 DB "richest people on Earth. Congratulations! You made it.",13,10,0
