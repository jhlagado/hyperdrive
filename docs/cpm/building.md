# Building and verifying the CP/M port

Use Node.js 24 and a full Git clone of this repository. Tests read the pinned
historical BASIC revisions from Git, so a source ZIP or shallow clone needs the
missing history before those tests can run.

```sh
npm ci
npm run check
node tools/measure.mjs
```

The lockfile pins ATOM and the development Z80 runtime. Assembly is performed by
the native ATOM engine; the production game contains no JavaScript or BASIC
interpreter. `npm run check` builds `build/HYPERDRV.COM`, enforces 8.3 assembly
filenames and the 500-line module limit, checks the complete allocation, and
runs the gameplay and failure tests. The measurement command enforces guest CPU
budgets and records the observed stack use.

The `build` directory is generated and ignored by Git. Its manifest identifies
the exact COM bytes, assembler revision, source hashes and memory allocation.
`symbols.json` and the debugger metadata are development artifacts; neither is
required on a player's disk.

## Historical tables

`tools/extract-world.mjs` extracts room descriptions, object names and numeric
world data from pinned BASIC revisions. It regenerates `cpm/world.asm` and
`cpm/roomtext.asm`. Dynamic puzzle behavior belongs in the handwritten modules.
The historical `src` directory remains the recovered VIC-20 material; `cpm`
contains the native port.

## Actual CP/M and browser checks

A qualified Triptych checkout supplies the production WASM CPU host, disk
builder and browser automation dependency. After building that host:

```sh
TRIPTYCH_ROOT=/path/to/triptych node tools/prove-cpm.mjs
```

This boots real CP/M, installs the exact local COM into a disposable disk,
compares state throughout the complete winning route, saves, exits, relaunches,
loads and finishes. It does not replace any user's disk.

The browser proof requires a running Triptych site that includes the same COM:

```sh
TRIPTYCH_ROOT=/path/to/triptych \
HYPERDRIVE_URL=http://127.0.0.1:4177/ \
HYPERDRIVE_REPORT_DIR=/tmp/hyperdrive-browser-proof \
HYPERDRIVE_OLD_DISK=/path/to/pre-hyperdrive-caverns-disk.img \
node tools/prove-browser.mjs
```

The old disk must be a standard CP/M image containing Caverns and no Hyperdrive.
The proof uses isolated browser contexts. It checks exact release assets, full
victory, reload, export/import, and explicit installation onto that older disk.
Every pre-existing file, system record and preceding disk backup is compared.
Omitting HYPERDRIVE_URL selects the public Triptych website; the expected COM
must already be deployed there.

Technical reports, route helpers and tests contain spoilers. The
[player guide](player-guide.md) describes commands without puzzle solutions.
