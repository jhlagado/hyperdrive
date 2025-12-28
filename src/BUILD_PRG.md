# Build VIC-20 PRG (Uppercase ASCII Strings)

This build exists because VIC-20 BASIC stores strings in PETSCII, while the
source is ASCII. Tokenizing with `petcat` produces PETSCII uppercase strings
(193–218). The game compares against ASCII input (65–90), so strings must be
patched back to ASCII inside quotes to keep display and input matching correct.

## Single command

```sh
python3 build_prg.py hyperdrive.bas
```

Output:

```
Built /Users/johnhardy/Documents/projects/hyperdrive/src/hyperdrive.prg
```

These steps take an ASCII `.bas` file, create a temporary file for tokenizing,
build a VIC-20 `.prg`, then patch string bytes so printed text and input
comparisons stay in ASCII uppercase.

## What the build script does

1) Creates `<source>.temp.bas` by converting quoted strings and DATA fields
to PETSCII.
2) Tokenizes the temp file with `petcat` into `<source>.prg`.
3) Writes PETSCII bytes for quoted strings and DATA fields before tokenizing,
so the PRG uses proper PETSCII without post-build patching.
4) The PRG is ready to run in VICE.

## Examples

```sh
python3 build_prg.py hyperdrive.bas
python3 build_prg.py vic20-input-test.bas
python3 build_prg.py hyperdrive.bas /Users/johnhardy/Documents/projects/hyperdrive/src/hyperdrive.prg
```

## Run in VICE

```sh
xvic -memory 16k hyperdrive.prg
```
