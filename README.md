# Hyperdrive: The Lost 1982 Text Adventure

## A Lost Game, Recovered

For years, the VIC-20 game *Hyperdrive* survived only as a rumor and a damaged
cassette. It was written in 1982 by Ken Stone, building on earlier work he and
John Hardy created together. That earlier project began on a Sinclair ZX81 as a
fantasy adventure called `Caverns`, then grew into something larger when it was
ported to the VIC-20 with a 16K expansion cartridge.

*Hyperdrive* took the ideas that came before and pushed them into science
fiction. It traded dragons and dungeons for derelict starships and uncertain
technology. The tone is different, but the same DNA is there: curiosity,
exploration, and the slow accumulation of knowledge that lets you survive just
one more move.

Typical of text adventures of the time, it also carries a few frustrating
quirks. That is part of its character. It is a game from a moment when players
were expected to map the world by hand and live with the consequences of a bad
guess.

The only surviving copy lived on an aging tape. Around 2019 that tape was
transferred to a WAV file, and from that capture the original BASIC listing was
recovered with what appears to be complete fidelity to the 1982 program.

## What the Game Feels Like

You are the pilot of a small space yacht damaged in a freak accident. You dock
with a massive derelict cruiser to find what you need to survive and get home.
The ship is cold, dim, and silent. Its corridors are cracked, its machinery is
half alive, and its air is not always safe to breathe. Every room description
feels like a clue and a warning at once.

The joy is in discovery: charting the ship, learning its rules, and keeping
calm while the game tests your patience and your nerve.

## What You Will Find Here

This repository keeps the original program and its recovery artifacts together
so the full story remains intact:

- `src/hyperdrive.bas`: the restored BASIC source listing
- `src/hyperdrive.wav`: the original cassette capture
- `src/hyperdrive.tap`: pulse-accurate tape data derived from the WAV
- `src/hyperdrive.prg`: the reconstructed VIC-20 program file

Supporting material and notes:

- `docs/recovery-notes.md`: the technical narrative of the recovery process
- `docs/peek-poke-notes.md`: VIC-20 hardware notes used by the game
- `recovery/`: scripts and intermediate outputs used during reconstruction

## A Small Addendum

Later, John Hardy wrote a sequel titled `Hyperdrive II` for the Australian
Microbee computer. It is its own game, but it echoes some of the atmosphere and
themes established by the original VIC-20 *Hyperdrive*.

![Original Talking Electronics Issue 8 ad for Hyperdrive and Caverns (1982).](assets/vic20-versions-te-8.png)

Original ad for Hyperdrive and Caverns, from Talking Electronics Issue 8
(published in 1982).
