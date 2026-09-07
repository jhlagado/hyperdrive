TITLE: DB "Hyperdrive",13,10
       DB "By Ken Stone and John Hardy. Copyright Micro Parts, 1982.",13,10
       DB "Your space yacht was damaged in a freak accident. You have docked",13,10
       DB "with a huge derelict cruiser to find equipment for repairs.",13,10
       DB "Type HELP for instructions and SAVE to keep your progress.",13,10,0
PROMPT: DB 13,10,"? ",0
SEEMSG: DB "You see: ",0
CARRYMSG: DB "You are carrying:",13,10,0
NOTHING: DB "Nothing.",13,10,0
UNKNMSG: DB "I don't understand that command. Type HELP.",13,10,0
LONGMSG: DB "That command is too long (63 characters maximum).",13,10,0
QUITMSG: DB "Return to CP/M? (Y/N) ",0
DONEMSG: DB "Done.",13,10,0
ABSENT: DB "That object is not available here.",13,10,0
FULLMSG: DB "You can carry at most eleven objects.",13,10,0
NOWAYMSG: DB "You can't go that way.",13,10,0
FATALMSG: DB "You venture into a lethal breach in the wreck. Your adventure ends.",13,10,0
HELPMSG:
 DB "Your space yacht was damaged in a freak accident. You have docked with",13,10
 DB "the wreck of a huge space cruiser. Search for equipment to repair your",13,10
 DB "yacht, then bring the salvage home.",13,10,13,10
 DB "NORTH, SOUTH, WEST, EAST (or N, S, W, E) move through the wreck.",13,10
 DB "LOOK describes your surroundings. INVENTORY, INVENT, I and LIST",13,10
 DB "show carried objects. TAKE object and DROP object manage equipment.",13,10
 DB "You can carry eleven objects. A compass helps you keep your bearings.",13,10
 DB "USE object operates a tool; READ examines written instructions.",13,10
 DB "TRANSMAT operates the transporter. Read its controls for destinations.",13,10
 DB "SCORE reports salvage value. Return equipment to the yacht for full value.",13,10
 DB "FINISH or LAUNCH repairs the yacht and attempts the journey home.",13,10
 DB "SAVE name and LOAD name use disk slots (up to eight letters or digits).",13,10
 DB "SAVE alone uses HYPERDRV.SAV. Copy or export your disk to keep a backup.",13,10
 DB "HELP displays these instructions. QUIT returns to CP/M after confirmation.",13,10
 DB "RESTART starts again after confirmation. Save first to retain this game.",13,10
 DB "Commands are case-insensitive. Backspace corrects typing.",13,10,13,10
 DB "Hyperdrive was written for the VIC-20 by Ken Stone; the recovered",13,10
 DB "program credits Ken Stone and John Hardy, copyright Micro Parts, 1982.",13,10
 DB "This is the original Hyperdrive, distinct from John Hardy's Hyperdrive II.",13,10,0
VERBS:
 DB 1,"N",0,1,"NORTH",0,1,"UP",0
 DB 2,"S",0,2,"SOUTH",0,2,"DOWN",0
 DB 3,"W",0,3,"WEST",0,4,"E",0,4,"EAST",0
 DB 5,"LOOK",0,5,"L",0
 DB 6,"INVENTORY",0,6,"INVENT",0,6,"I",0,6,"LIST",0
 DB 7,"HELP",0,7,"ABOUT",0
 DB 8,"QUIT",0,8,"EXIT",0
 DB 9,"TAKE",0,9,"GET",0,10,"DROP",0
 DB 11,"USE",0,12,"TRANSMAT",0,13,"READ",0,14,"ECHO",0
 DB 15,"FINISH",0,15,"LAUNCH",0,16,"SCORE",0,17,"RESTART",0
 DB 18,"SAVE",0,19,"LOAD",0,0
OBJWORDS:
 DB 7,"PUMP",0,8,"COMPASS",0,9,"BOMB",0,10,"MEMORY",0
 DB 11,"PROCESSOR",0,12,"TAPE",0,13,"BOOK",0,14,"SERVO",0
 DB 15,"TOOLKIT",0,15,"TOOL KIT",0,15,"TOOLS",0
 DB 16,"CLOCK",0,17,"BRACELET",0,18,"MATCHES",0
 DB 19,"SCREWDRIVER",0,20,"BLASTER",0,21,"MASK",0
 DB 22,"ROPE",0,23,"MAGNET",0,24,"FUSE",0,0
