# Hyperdrive delivery acceptance

**Spoilers:** the linked evidence and tests disclose puzzle solutions and endings.

The original Ken Stone Hyperdrive is implemented as `HYPERDRV.COM`, a native
ATOM Z80 program for CP/M. All delivery requirements are verified.

[Play on the public Triptych terminal](https://jhlagado.github.io/triptych/) by
typing `HYPERDRV`. Existing saved disks require an explicit installation through
Files and recovery before the new command is available.

| Requirement | Evidence |
| --- | --- |
| Identify the original game and exclude Hyperdrive II | [Source authority](architecture.md#source-authority), recovered BASIC revision `fc90c8ef4b2484155c75bb385fbb92593dc6d060`, unchanged historical `src` files |
| Preserve the complete recovered world | All 54 room descriptions, 24 object placements and 216 direction entries; `test/world.test.mjs` compares the emitted native tables with BASIC |
| Complete puzzles, encounters and endings | `test/full-game.test.mjs`, `test/puzzles.test.mjs` and the exhaustive native combat test; [rules inventory](rules.md) records source quirks and adaptations |
| Execute a complete game | [Real CP/M evidence](evidence/cpm-proof.json): 93 commands, complete state comparison, 126-point finish after save/relaunch/load |
| Use native ATOM and editor-friendly modules | [Build instructions](building.md); pinned ATOM, 8.3 ASM names and a maximum of 500 lines enforced during assembly |
| Follow CP/M entry, stack and exit conventions | Entry at 0100h, complete allocation below 3C30h, final 512-byte private stack, BDOS exit; Triptych A/B lifetime proofs compare WASM and native host behavior |
| Preserve saves and recover interrupted writes | [Save format and protocol](saves.md), single-bit corruption and semantic validation tests, read-only media and interrupted-rename tests |
| Measure performance and memory | [Measurements](evidence/measurements.json) identify the exact executable and distinguish guest CPU cycles from browser timing |
| Publish an identified artifact | [Release 0.1.0](https://github.com/jhlagado/hyperdrive/releases/tag/v0.1.0), source revision `624fd56518a80762821c5bfcc3355e9a76d1eb34`, exact upstream Linux CI artifact |
| Integrate without replacing saved media silently | Triptych component lock and Files catalogue include Hyperdrive; [public installation proof](evidence/public-install.json) preserves every file, system record and an exact preceding-disk backup |
| Deploy and verify the actual public terminal | [Successful Pages release](https://github.com/jhlagado/triptych/actions/runs/34152578646), [exact deployed assets](evidence/public-assets.json), [complete public game and persistence](evidence/public-game.json) |

The COM is 15,152 bytes, including workspace and stack. Its SHA-256 is
`a3db132195631da3cd80885d9072b7b7cf1bb96118fc24363be71b93c7be3870`.
Triptych consumes those bytes and the original manifest; it does not rebuild or
maintain another game implementation.
