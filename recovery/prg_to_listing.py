#!/usr/bin/env python3
import argparse
import struct
import sys

# BASIC V2 token table (VIC-20 / C64 style)
TOKENS = {
    0x80:"END",0x81:"FOR",0x82:"NEXT",0x83:"DATA",0x84:"INPUT#",0x85:"INPUT",0x86:"DIM",0x87:"READ",
    0x88:"LET",0x89:"GOTO",0x8A:"RUN",0x8B:"IF",0x8C:"RESTORE",0x8D:"GOSUB",0x8E:"RETURN",0x8F:"REM",
    0x90:"STOP",0x91:"ON",0x92:"WAIT",0x93:"LOAD",0x94:"SAVE",0x95:"VERIFY",0x96:"DEF",0x97:"POKE",
    0x98:"PRINT#",0x99:"PRINT",0x9A:"CONT",0x9B:"LIST",0x9C:"CLR",0x9D:"CMD",0x9E:"SYS",0x9F:"OPEN",
    0xA0:"CLOSE",0xA1:"GET",0xA2:"NEW",0xA3:"TAB(",0xA4:"TO",0xA5:"FN",0xA6:"SPC(",0xA7:"THEN",
    0xA8:"NOT",0xA9:"STEP",0xAA:"+",0xAB:"-",0xAC:"*",0xAD:"/",0xAE:"^",0xAF:"AND",
    0xB0:"OR",0xB1:">",0xB2:"=",0xB3:"<",0xB4:"SGN",0xB5:"INT",0xB6:"ABS",0xB7:"USR",0xB8:"FRE",
    0xB9:"POS",0xBA:"SQR",0xBB:"RND",0xBC:"LOG",0xBD:"EXP",0xBE:"COS",0xBF:"SIN",
    0xC0:"TAN",0xC1:"ATN",0xC2:"PEEK",0xC3:"LEN",0xC4:"STR$",0xC5:"VAL",0xC6:"ASC",0xC7:"CHR$",
    0xC8:"LEFT$",0xC9:"RIGHT$",0xCA:"MID$",0xCB:"GO",
}

# Some PETSCII control codes that show up inside strings as "layout"
CTRL_SPACE = {0x11, 0x1D, 0x9D}  # cursor down/right/left -> treat as spacing
CTRL_IGNORE = {0x90}            # reverse-on etc -> ignore (extend if needed)

def petscii_to_ascii(b):
    # shifted space
    if b == 0xA0:
        return " "
    if b in CTRL_SPACE:
        return " "
    if b in CTRL_IGNORE:
        return ""
    # PETSCII shifted letters often appear in strings: 0xC1..0xDA => A..Z
    if 0xC1 <= b <= 0xDA:
        return chr((b - 0xC1) + ord("A"))
    # plain printable
    if 32 <= b <= 126:
        return chr(b)
    # unknown control/graphics
    return "."

def detokenize(line_bytes):
    out = []
    in_quotes = False
    for b in line_bytes:
        if b == 0x22:  # "
            out.append('"')
            in_quotes = not in_quotes
            continue
        if (not in_quotes) and b >= 0x80 and b in TOKENS:
            out.append(TOKENS[b])
            continue
        out.append(petscii_to_ascii(b))
    return "".join(out)

def main():
    ap = argparse.ArgumentParser(description="Convert a tokenised BASIC V2 .PRG into a readable listing (PETSCII-aware).")
    ap.add_argument("prg", help="Input .prg file")
    ap.add_argument("-o", "--out", help="Output text file (default: stdout)")
    ap.add_argument("--start-skip", type=int, default=4,
                    help="Bytes to skip at start of BASIC payload (default 4; fixes your recovered PRG’s stray header)")
    args = ap.parse_args()

    data = open(args.prg, "rb").read()
    if len(data) < 4:
        raise SystemExit("PRG too small.")

    load = struct.unpack_from("<H", data, 0)[0]
    mem = data[2:]  # payload after load address

    # IMPORTANT: your recovered PRG has 4 junk bytes right after load address.
    i = args.start_skip

    lines = []
    while i + 4 <= len(mem):
        # record header (we *ignore* the next-pointer because yours is unreliable in places)
        ln = struct.unpack_from("<H", mem, i + 2)[0]

        # find line terminator 0x00
        try:
            end = mem.index(0, i + 4)
        except ValueError:
            break

        content = mem[i + 4:end]
        text = detokenize(content)
        lines.append((ln, text))

        i = end + 1
        # end-of-program often has 00 00 00 00
        if i + 4 <= len(mem) and mem[i:i+4] == b"\x00\x00\x00\x00":
            break

    # write
    out = open(args.out, "w", encoding="utf-8") if args.out else sys.stdout
    for ln, text in lines:
        out.write(f"{ln} {text}\n")
    if args.out:
        out.close()

if __name__ == "__main__":
    main()
