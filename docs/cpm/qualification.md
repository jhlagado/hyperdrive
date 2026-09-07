# CP/M qualification

**Spoilers:** the linked tests and reports disclose the winning route and endings.

The native ATOM build reaches the original 126-point ending through ordinary
commands. The independent BASIC rules model provides a route with scripted
successful shots; the native proof uses the actual deterministic RNG and retries
a missed shot. It performs 93 commands before the final launch interaction.
The complete native state is compared after every command under real CP/M using
the Triptych WASM CPU host. Saving, exiting to the CCP, relaunching, loading and
finishing also pass.

The [CP/M evidence](evidence/cpm-proof.json) identifies the COM digest, host
revision and WASM artifact hashes. The [measurements](evidence/measurements.json)
identify the same game artifact: 15,152 bytes including the full 512-byte private
stack, with no dynamic allocation. The measured route uses at most 50 bytes of
that stack. This observation covers the route and HELP/SAVE/LOAD, not every
possible execution path.

The development adapter measures a 129,376-cycle 95th percentile and
189,632-cycle maximum for route commands. At a nominal 4 MHz these are about
32 and 47 milliseconds of guest instruction execution. They exclude the CP/M
implementation, serial pacing and browser wall time. HELP, SAVE and LOAD costs
are reported separately. The enforced ordinary-command budget is one million
guest cycles; the measured maximum is below it.

The automated suite checks the full game, restart, return stack, input overflow,
confirmation overflow, echo gating, sonic exposure, exact world tables, all
1,024 single-bit save corruptions, semantic save validation, read-only media,
failed writes and interrupted rename recovery. Combat checks exhaust byte-wide
hit and fatal thresholds and verify register and stack preservation.

The [public browser proof](evidence/public-game.json) passed on the deployed
Triptych revision `5582a20c8bd15da18dbdf2ed7d2167ec290257e7`: full victory,
save/reload, export and fresh-context import. The [installation proof](evidence/public-install.json)
retained every existing Caverns-disk file, its system tracks and an exact disk
backup. [Asset verification](evidence/public-assets.json) matches the released
COM and complete distribution image. Observed public-browser command latency
was about 18 ms at the 95th percentile and 22 ms maximum on the recorded Apple M2
and Chromium host; these are browser observations, separate from guest cycles.

The maintained owner suite now contains 33 tests, including optional puzzle
branches and all ending thresholds. Triptych's complete check passed 469 tests,
91 browser tests and its native, WASM, CP/M and Rust gates. The
[Pages release](https://github.com/jhlagado/triptych/actions/runs/34152578646)
passed before the live-site proof.

## Deliberate adaptations

The [rules audit](rules.md) retains the original defects and separates them from
port decisions. This implementation makes these bounded changes:

- A bounded, case-insensitive parser replaces substring matching and invalid
  array access. Inventory aliases are accepted. DOWN means south.
- Utility commands do not consume action turns or mutate puzzle exits. Successful
  moves and equipment actions use one consistent turn counter; attempted blaster
  use also counts when no enemy is present. Atmospheric
  warnings remain nonfatal, as in the recovered BASIC; no new oxygen death or
  real-time browser-dependent countdown is introduced. The port removes the
  original suppression of room descriptions and the 230-count mask depletion.
  Fumes and low oxygen produce warnings while descriptions remain available.
- ECHO uses the normal command loop, so help, inventory and saves remain usable.
  Repeated room descriptions in the computer vault still trigger the original
  sonic hazard. LOAD does not describe the room.
- READ at the transmat or with the bracelet supplies destination codes. The
  original transporter destinations and bracelet restriction are retained.
- The escape pod retains its original inconsistent reference to a secret code.
  Its actual mechanism still requires removing and replacing the fuse; the
  audit identifies this source quirk separately from implemented repairs.
- Enemy relocations outside the 54-room table remove that enemy safely. A
  successful shot leaves a ground blaster on the floor when the inventory is
  full. The [combat report](combat.md) records byte-level probability rounding.
- FINISH attempts the original score-based ending; QUIT returns to CP/M. Scores
  of 126 or greater receive the superior-drive ending, covering the original
  unhandled 127–132 range.
- Native BDOS replaces VIC-20 display and sound register operations. Text effects
  replace sound; historical busy-wait delays are removed. Pagination affects
  presentation only. Saves include the RNG and every mutable puzzle field.

The console, pager, decimal output, disk protocol and development BDOS adapter
are adapted from Caverns80 v0.1.1 under GPL-3.0. The repository's existing GPL
license remains in force. The original BASIC, tape, program and audio archives
are preserved without modification.
