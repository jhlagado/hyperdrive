; HL unsigned word to decimal. AF BC DE HL clobbered, IX/IY preserved.
PRIWOR:
        PUSH IX
        LD IX,DECDIV
        LD B,0
DECSTEP:
        LD E,(IX+0)
        LD D,(IX+1)
        LD C,0
DECSUB:
        OR A
        SBC HL,DE
        JR C,DECREM
        INC C
        JR DECSUB
DECREM:
        ADD HL,DE
        LD A,E
        CP 1
        JR Z,DECEMIT
        LD A,B
        OR C
        JR Z,DECNEXT
DECEMIT:
        LD A,C
        ADD A,'0'
        CALL TERPUT
        LD B,1
DECNEXT:
        LD A,E
        CP 1
        JR Z,DECEND
        INC IX
        INC IX
        JR DECSTEP
DECEND:
        POP IX
        RET
