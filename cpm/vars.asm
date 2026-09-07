; Persistent region; the versioned save codec will encode fields explicitly.
STATE:
ROOM: DB 1
TURNS: DW 0
RNGSTATE: DW $ACE1
DOCKED: DB 0
OBJS: DS 24,0
EXITS: DS 216,0
SHOTS: DB 0
FUTAKEN: DB 0
MATCHLIT: DB 1
ECHODONE: DB 0
SONIC: DB 0
STATEEND:
; Presentation and command scratch are excluded from saves.
INBUF: DS 64,0
INOVER: DB 0
VERBPTR: DW 0
ARGPTR: DW 0
COMMAND: DB 0
OBJECT: DB 0
PGON: DB 0
PGROWS: DB 0
PGSKIP: DB 0
SVBUF: DS 128,0
