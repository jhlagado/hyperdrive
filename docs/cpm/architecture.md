# Hyperdrive for CP/M

Status: native implementation and real CP/M route qualified; public browser
deployment remains in progress. See [qualification](qualification.md).

This port implements Ken Stone's original VIC-20 Hyperdrive. The recovered
listing credits Ken Stone and John Hardy and records copyright Micro Parts,
1982. John Hardy's Hyperdrive II is a separate game and supplies no content or
rules for this port.

## Source authority

The earliest recovered listing is `src/hyperdrive.bas` at revision
`fc90c8ef4b2484155c75bb385fbb92593dc6d060`. The repository's later listing has
presentation and input changes. Its 24 object placements and 216 direction
entries remain identical to that revision. The recovered BASIC governs the
world and puzzles; `src/pseudocode.txt` contains conflicting interpretations
and is not an implementation specification. The archived recordings and VIC-20
artifacts remain intact. Recovery fidelity to the physical cassette has not
been independently established by this port.

## Implementation choice

Use handwritten Z80 assembly assembled by pinned ATOM, with tables for room
text, exits, vocabulary and objects. A BASIC interpreter would preserve more
incidental input and arithmetic behavior but require a second runtime and
hardware emulation for a small game. Translating the existing pseudocode would
be shorter initially but would change several puzzle predicates. Native code
with an explicit source-to-rule inventory permits direct testing of each
adaptation and reuses the CP/M service boundaries qualified for Caverns.

The deliverable is `HYPERDRV.COM`, using CP/M's eight-character name limit.
Assembly modules use 8.3 names and at most 500 lines. Historical BASIC filenames
and archives retain their names. Generated symbols and binaries belong in the
ignored build directory.

## Boundaries and contracts

The command loop performs bounded ASCII input, case normalization, verb/noun
lookup, one state transition and output. The game state contains the current
room, all object locations, mutable exits, puzzle flags, turn counter and RNG
state. Console pagination and input scratch are outside persistent game state.
Object and destination indexes are checked before indexing tables; fatal exit
markers are decoded separately from room numbers.

The console layer uses CP/M BDOS and paginates long passages for a 25-row
terminal. Help and credits are available during play. Startup installs a
private 512-byte stack before subroutine calls. Normal exits use BDOS function
0 with a warm-boot fallback. The complete code, data, workspace and stack extent
must fit below the supported Triptych resident boundary.

Saves use versioned records, integrity checks and a staged replacement with a
recoverable backup. Loading validates a candidate before replacing live state.
The saved RNG state makes replay reproducible. Disk failure tests cover both
return errors and operations whose effects occur before an error response.

VIC-20 sound and display register writes become text effects. Busy-wait delays
are removed. Playing time may be represented by turns; no puzzle timeout will
be tied to browser execution speed. Any change to resource exhaustion or combat
probabilities requires an explicit rule entry and a full-game proof.

## Delivery milestones

1. Establish the source baseline, inventory every rule, and build the CP/M
   shell, parser and complete world representation. Verify startup, navigation,
   input bounds, pagination and clean exit in an executed COM file.
2. Implement every puzzle, encounter and ending, add disk saves, and execute an
   ordinary complete winning route. Test adverse routes, restart, malformed
   saves, disk failures and deterministic replay. Measure guest CPU costs and
   assembled memory independently of browser timing.
3. Publish the qualified owner artifact and provenance, pin it in Triptych,
   run consumer checks, and deploy to the public WASM site. Verify a complete
   game and persistence through that deployed terminal, including an existing
   saved disk. Supply the public link and launch command.

A local build or an opening-screen demonstration does not complete milestone
3. The goal remains active through public deployment and playable verification.
