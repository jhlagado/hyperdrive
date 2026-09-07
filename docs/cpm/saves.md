# Hyperdrive CP/M saves

SAVE and LOAD take an optional one-to-eight-character basename containing letters,
digits or underscore. The default is HYPERDRV.SAV. Files stay on the current drive.
Names cannot contain a drive, extension, wildcard or path.

The disk protocol is adapted from Caverns80 v0.1.1. SAVE first checks drive and file
write protection. It writes a complete candidate to .$$$, closes it, reads it back,
validates it, and compares every byte with the intended record. Only then does it
move an existing .SAV to .BAK and rename the candidate to .SAV. Replacing a save
requires confirmation. An interrupted commit can leave recovery files; LOAD offers
valid .BAK and .$$$ candidates when the primary cannot be loaded. Recovery does not
automatically overwrite disk files: save into a new slot afterward.

A failure does not promise atomic directory operations across power loss. It keeps
a valid primary or recovery copy available through the staged protocol. DMA is
restored to0080h on all ordinary command returns. LOAD validates the complete record
before changing any game state and does not describe the room or advance exposure.

## Record format

One128-byte CP/M record. Bytes0–3 are ASCII HYP1;4 is format version1;5 is rules
version1;6–7 are little-endian payload size44;8–9 are CRC16/CCITT-FALSE, initialFFFF,
polynomial1021. CRC covers all128bytes with8–9 treated as zero. Bytes10–15 and60–127
are reserved zero bytes.

| Offset | Content |
| --- | --- |
|16|Room1–54|
|17–18|Turn count|
|19–20|Nonzero deterministic RNG state|
|21|Docked flag|
|22–45|24 object/enemy locations|
|46|Shot counter|
|47–50|Fuse removed, match lit, echo solved, sonic exposure|
|51–59|Nine mutable exit values|

Enemy locations must be0–54; object locations permit255 for carried. Carry count
cannot exceed11. Flags and live sonic exposure are0–1. Exit bytes correspond to
zero-based offsets5,36,44,67,78,84,176,191,200 in the216-byte room table; each accepts
only its initial or implemented changed destination. LOAD restores the immutable
base exit table and then applies those nine values. Terminal presentation, command
buffers and stack are not serialized.

Run `node --test test/save.test.mjs` after building. These tests use a development
BDOS adapter. Real native CP/M and deployed WASM save/transfer checks are separate
release requirements.
