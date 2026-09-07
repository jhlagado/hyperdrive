; CP/M named saves. Main-register scratch; IX/IY preserved by BDOS wrapper.
; Every command restores DMA0080h. Files are one validated128byte record.
; Failed calls retain existing committed/recovery files; no live mutation.
SAVECMD:
        CALL SDNAME
        JP NZ,SDNAMERR
        ; CP/M read-only vector is HL, current drive is A.
        LD C,25
        CALL SDCALL
        LD B,A
        LD C,29
        PUSH BC
        PUSH IX
        PUSH IY
        CALL 5
        POP IY
        POP IX
        POP BC
        LD A,B
        OR A
        JR Z,SDROBIT
SDROSHFT:
        SRL H
        RR L
        DJNZ SDROSHFT
SDROBIT:
        BIT 0,L
        JP NZ,SDFAIL
        ; Preflight every existing file before any delete/make/rename.
        ; CP/M may warm boot instead of returning from protected writes.
        LD HL,SDFMAIN
        CALL SDWRCHK
        JP NZ,SDFAIL
        LD HL,SDFTMP
        CALL SDWRCHK
        JP NZ,SDFAIL
        LD HL,SDFBAK
        CALL SDWRCHK
        JP NZ,SDFAIL
        LD HL,SDFMAIN
        CALL SDREAD
        CP 2
        JR Z,SDNEW
        OR A
        JP NZ,SDUNRES
        LD HL,SDOVER
        CALL SDYES
        JP NZ,SDCANCEL
        LD A,1
        LD (SDHAD),A
        JR SDENCODE
SDNEW:
        LD HL,SDFBAK
        CALL SDEXISTS
        JP NZ,SDUNRES
        LD HL,SDFTMP
        CALL SDEXISTS
        JP NZ,SDUNRES
        XOR A
        LD (SDHAD),A
SDENCODE:
        CALL SVENC
        LD HL,SVBUF
        LD DE,SDEXPECT
        LD BC,128
        LDIR
        LD HL,SDFTMP
        CALL SDEXISTS
        CP 2
        JP NC,SDFAIL
        OR A
        JR Z,SDMAKTMP
        LD DE,SDFTMP
        LD C,19
        CALL SDCALL
        CP 255
        JP Z,SDFAIL
SDMAKTMP:
        LD HL,SDFTMP
        CALL SDRESET
        LD DE,SDFTMP
        LD C,22
        CALL SDCALL
        CP 255
        JP Z,SDFAIL
        CALL SDDMA
        LD DE,SDFTMP
        LD C,21
        CALL SDCALL
        LD (SDSTATUS),A
        LD C,16
        CALL SDCALL
        CP 255
        JP Z,SDFAIL
        LD A,(SDSTATUS)
        OR A
        JP NZ,SDFAIL
        LD HL,SDFTMP
        CALL SDREAD
        OR A
        JP NZ,SDFAIL
        LD HL,SVBUF
        LD DE,SDEXPECT
        LD B,128
SDCMPARE:
        LD A,(DE)
        CP (HL)
        JP NZ,SDFAIL
        INC HL
        INC DE
        DJNZ SDCMPARE
        LD A,(SDHAD)
        OR A
        JR Z,SDCOMMIT
        ; Remove stale backup only while committed primary is intact.
        LD HL,SDFBAK
        CALL SDEXISTS
        CP 2
        JP NC,SDFAIL
        OR A
        JR Z,SDNOBACK
        LD DE,SDFBAK
        LD C,19
        CALL SDCALL
        CP 255
        JP Z,SDFAIL
SDNOBACK:
        LD HL,SDFMAIN
        LD DE,SDFBAK
        CALL SDRENAME
        CP 255
        JP Z,SDFAIL
SDCOMMIT:
        LD HL,SDFTMP
        LD DE,SDFMAIN
        CALL SDRENAME
        CP 255
        JP Z,SDFAIL
        LD HL,SDSAVED
        JP SDMSG

LOADCMD:
        CALL SDNAME
        JP NZ,SDNAMERR
        LD HL,SDFMAIN
        CALL SDREAD
        OR A
        JR Z,SDPUB
        LD HL,SDFBAK
        CALL SDREAD
        OR A
        JR NZ,SDTRYTMP
        LD HL,SDBACKQ
        CALL SDYES
        JR Z,SDPUB
SDTRYTMP:
        LD HL,SDFTMP
        CALL SDREAD
        OR A
        JP NZ,SDNOLOAD
        LD HL,SDTEMPQ
        CALL SDYES
        JP NZ,SDCANCEL
SDPUB:
        CALL SVAPPLY
        OR A
        JP NZ,SDNOLOAD
        CALL SDREST
        LD HL,SDLOADED
        JP SDPRINT

; Parse command verb then optional basename. No extension or drive syntax.
SDNAME:
        LD HL,SDFMAIN
        LD DE,SDFMAIN+1
        LD BC,107
        LD (HL),0
        LDIR
        LD HL,SDDEFLT
        LD DE,SDFMAIN+1
        LD BC,8
        LDIR
        LD HL,(ARGPTR)
        JP SDSPACES
SDLEAD:
        LD A,(HL)
        CP 32
        JR NZ,SDVERB
        INC HL
        JR SDLEAD
SDVERB:
        LD A,(HL)
        OR A
        JR Z,SDNAMEND
        INC HL
        CP 32
        JR NZ,SDVERB
SDSPACES:
        LD A,(HL)
        OR A
        JR Z,SDNAMEND
        CP 32
        JR NZ,SDCUSTOM
        INC HL
        JR SDSPACES
SDCUSTOM:
        PUSH HL
        LD HL,SDFMAIN+1
        LD B,8
SDBLANK:
        LD (HL),32
        INC HL
        DJNZ SDBLANK
        POP HL
        LD DE,SDFMAIN+1
        LD B,8
SDCHAR:
        LD A,(HL)
        OR A
        JR Z,SDNAMEND
        CP 32
        JR Z,SDTRAIL
        CP 'a'
        JR C,SDUPPER
        CP 'z'+1
        JR NC,SDUPPER
        AND $DF
SDUPPER:
        CP '_'
        JR Z,SDACCEPT
        CP '0'
        JR C,SDBADNAM
        CP '9'+1
        JR C,SDACCEPT
        CP 'A'
        JR C,SDBADNAM
        CP 'Z'+1
        JR NC,SDBADNAM
SDACCEPT:
        LD (DE),A
        INC DE
        INC HL
        DJNZ SDCHAR
        LD A,(HL)
        OR A
        JR Z,SDNAMEND
        CP 32
        JR NZ,SDBADNAM
SDTRAIL:
        INC HL
        LD A,(HL)
        OR A
        JR Z,SDNAMEND
        CP 32
        JR Z,SDTRAIL
SDBADNAM:
        LD A,1
        OR A
        RET
SDNAMEND:
        LD HL,SDFMAIN+1
        LD DE,SDFTMP+1
        LD BC,8
        LDIR
        LD HL,SDFMAIN+1
        LD DE,SDFBAK+1
        LD BC,8
        LDIR
        LD HL,SDEXTS
        LD DE,SDFMAIN+9
        LD BC,3
        LDIR
        LD DE,SDFTMP+9
        LD BC,3
        LDIR
        LD DE,SDFBAK+9
        LD BC,3
        LDIR
        XOR A
        RET

; Reset mutable FCB extent/allocation/current/random fields before open.
SDRESET:
        PUSH HL
        LD DE,12
        ADD HL,DE
        LD B,24
SDRESETL:
        LD (HL),0
        INC HL
        DJNZ SDRESETL
        POP HL
        RET
; HL FCB => A0 missing, A1 writable, A2 read-only, A3 close failure.
; Capture FCB extension attribute before close; do not strip protection.
SDWRCHK:
        CALL SDEXISTS
        CP 2
        JR NC,SDWRBAD
        XOR A
        RET
SDWRBAD:
        LD A,1
        OR A
        RET
SDEXISTS:
        CALL SDRESET
        EX DE,HL
        LD C,15
        CALL SDCALL
        CP 255
        JR Z,SDABSENT
        PUSH DE
        POP HL
        LD BC,9
        ADD HL,BC
        LD A,(HL)
        AND $80
        PUSH AF
        LD C,16
        CALL SDCALL
        CP 255
        JR Z,SDEXERR
        POP AF
        JR Z,SDEXWRIT
        LD A,2
        OR A
        RET
SDEXWRIT:
        LD A,1
        OR A
        RET
SDEXERR:
        POP AF
        LD A,3
        OR A
        RET
SDABSENT:
        XOR A
        RET
; HL FCB => A0 valid into SVBUF, A1 invalid/I/O, A2 not found.
SDREAD:
        CALL SDRESET
        EX DE,HL
        LD C,15
        CALL SDCALL
        CP 255
        JR Z,SDMISS
        CALL SDDMA
        LD C,20
        CALL SDCALL
        OR A
        JR NZ,SDRDBAD
        ; Second record must be EOF; do not accept long files.
        LD C,20
        CALL SDCALL
        CP 1
        JR NZ,SDRDBAD
        LD C,16
        CALL SDCALL
        CP 255
        JR Z,SDRDERR
        JP SVVALID
SDRDBAD:
        LD C,16
        CALL SDCALL
SDRDERR:
        LD A,1
        RET
SDMISS:
        LD A,2
        RET
; Rename HL old FCB to DE new FCB, using a separate 36byte request.
SDRENAME:
        PUSH HL
        PUSH DE
        LD HL,SDRENFCB
        CALL SDRESET
        POP DE
        POP HL
        PUSH DE
        LD DE,SDRENFCB
        LD BC,12
        LDIR
        POP HL
        LD DE,SDRENFCB+16
        LD BC,12
        LDIR
        LD DE,SDRENFCB
        LD C,23
        JP SDCALL
SDDMA:
        PUSH DE
        LD DE,SVBUF
        LD C,26
        CALL SDCALL
        POP DE
        RET
SDREST:
        LD DE,$0080
        LD C,26
        JP SDCALL
; Preserve caller main registers except AF around CP/M.
SDCALL:
        PUSH BC
        PUSH DE
        PUSH HL
        PUSH IX
        PUSH IY
        CALL 5
        POP IY
        POP IX
        POP HL
        POP DE
        POP BC
        RET
; Confirmation leaves SVBUF intact; only explicit Y accepts.
SDYES:
        CALL TERPUT1
        CALL READYES
        RET
SDNAMERR:
        LD HL,SDNAMEER
        JR SDMSG
SDUNRES:
        LD HL,SDRECOV
        JR SDMSG
SDNOLOAD:
        LD HL,SDLOADER
        JR SDMSG
SDCANCEL:
        LD HL,SDCANMSG
        JR SDMSG
SDFAIL:
        LD HL,SDERROR
SDMSG:
        PUSH HL
        CALL SDREST
        POP HL
        JP SDPRINT
SDPRINT:
        CALL TERPUT1
        JP TERNEW
SDCODEEN:
SDDEFLT: DB "HYPERDRV"
SDEXTS: DB "SAV$$$BAK"
SDOVER: DB "Replace this saved game? (y/n) ",0
SDBACKQ: DB "Recover the previous backup? (y/n) ",0
SDTEMPQ: DB "Recover the interrupted save? (y/n) ",0
SDSAVED: DB "Game saved to disk.",0
SDLOADED: DB "Game loaded.",0
SDNAMEER: DB "Use SAVE or LOAD with a name of 1-8 letters, digits or underscore.",0
SDRECOV: DB "This slot needs recovery. Use LOAD, then SAVE with a different name.",0
SDLOADER: DB "No valid save could be loaded. Your game is unchanged.",0
SDCANMSG: DB "Cancelled.",0
SDERROR: DB "Save failed. Existing recovery files have been retained.",0
SDDATAEN:
SDFMAIN: DS 36,0
SDFTMP: DS 36,0
SDFBAK: DS 36,0
SDRENFCB: DS 36,0
SDEXPECT: DS 128,0
SDHAD: DB 0
SDSTATUS: DB 0
SDWORKEN:
