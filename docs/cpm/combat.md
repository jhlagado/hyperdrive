# Combat rules — spoilers

This document reveals encounter outcomes and probabilities.

The authority is the recovered BASIC at `fc90c8ef4b2484155c75bb385fbb92593dc6d060`,
lines 211–227 and 289–310. `ENCOUNTR` scans object slots 1–6 in order and
returns the first machine in the current room. It does not itself attack,
advance time or mutate state. Command dispatch decides when an encounter is
hostile; this module handles firing the blaster only.

`SHOOT` requires object 20 (the blaster) carried or in the room. No enemy or
no available blaster produces a response without consuming shots or random
numbers. An actual shot increments the persistent global shot counter. The
original compares that counter with a fresh random threshold between 10 and
17: repeated firing eventually guarantees death. The port preserves this
escalation. Shots 1–10 survive the first check; shots 11–16 die with respective
probabilities 37, 73, 110, 146, 183 and 219 out of 256; shot 17 and later are
fatal. These are nearest-byte approximations to `(shots - 10) / 7`. The
measure-zero boundary in the original floating-point comparison at shot 10
is treated as survival. The counter saturates rather than wrapping.

After surviving this check, a fresh random byte below 97 hits: 97/256, or
37.89%, approximating BASIC's 38%. A hit makes a floor blaster carried only when fewer than eleven objects
are already carried. With a full inventory the shot still works, but the
blaster remains on the floor. This repairs BASIC's implicit pickup bypass of
the carrying limit and keeps the resulting state valid for saving. Enemies 3
and 5 retreat ten room numbers; all other enemies disappear. A missed shot
at enemy 5 causes abduction to room 33 and moves that drone seven room
numbers. Other misses choose one of four original response types. The
original also draws a response random number before an abduction, whereas
the port omits that unused draw. Replay is defined by the port's saved RNG
state, not by the VIC-20 RNG sequence.

Retreats beyond room 54 remove the enemy (location zero). BASIC could leave
these machines at non-existent room numbers. Bounding that result preserves
their disappearance from the playable world and keeps object locations valid.

Both public routines preserve BC, DE, HL, IX and IY, and return with their
entry stack depth. Flags are unspecified. `SHOOT` returns A=0 for an ordinary
result, A=1 for death, or A=2 for abduction; the caller owns death handling
and redisplaying the new room. Writable gameplay fields are `SHOTS`, `ROOM`,
`OBJS`, and the RNG state through `RNG`. Console state is changed only through
`TERPUT1`.

Integration tests should distinguish: first-of-several enemies; absent or
room-local blaster; shot counters 9, 10, 15, 16 and 255; each probability
boundary; hit bytes 96 and 97; all six enemy identities; retreats from rooms
44 and 45; abduction from rooms 47 and 48; register and stack preservation;
and unchanged state and RNG on rejected shots. Ordinary full-game testing
must also demonstrate that the global shot budget permits victory.
