#!/usr/bin/env python3
import argparse, struct, re
from typing import List, Optional, Tuple, Dict

TAP_SIG = b"C64-TAPE-RAW"

# ---------------- TAP v1 pulses ----------------

def read_tap_v1_pulses(path: str) -> List[int]:
    b = open(path, "rb").read()
    if len(b) < 20 or b[:12] != TAP_SIG:
        raise ValueError("Not a TAP file with C64-TAPE-RAW signature")
    ver = b[12]
    if ver != 1:
        raise ValueError(f"Unsupported TAP version {ver} (expect 1)")
    data_len = struct.unpack("<I", b[16:20])[0]
    stream = b[20:20+data_len]
    pulses: List[int] = []
    i = 0
    while i < len(stream):
        x = stream[i]
        if x != 0:
            pulses.append(x); i += 1
        else:
            if i + 3 >= len(stream): break
            v = stream[i+1] | (stream[i+2] << 8) | (stream[i+3] << 16)
            pulses.append(v); i += 4
    return pulses

# ---------------- clustering / decoding ----------------

def kmeans_1d(values: List[int], k: int = 3, iters: int = 40) -> List[float]:
    vs = sorted(values)
    seeds = [vs[int((i + 1) * len(vs) / (k + 1))] for i in range(k)]
    centers = [float(s) for s in seeds]
    for _ in range(iters):
        buckets = [[] for _ in range(k)]
        for v in values:
            j = min(range(k), key=lambda i: abs(v - centers[i]))
            buckets[j].append(v)
        new_centers = [(sum(b)/len(b)) if b else centers[i] for i,b in enumerate(buckets)]
        if all(abs(new_centers[i] - centers[i]) < 1e-6 for i in range(k)):
            break
        centers = new_centers
    return sorted(centers)

def classify_sml(pulses: List[int]) -> Tuple[List[Optional[int]], List[float]]:
    small = [p for p in pulses if 10 <= p <= 250]
    if not small:
        raise ValueError("No clusterable pulses found (10..250).")
    centers = kmeans_1d(small, 3)

    def cat(p: int) -> Optional[int]:
        if p < 10 or p > 250: return None
        return min(range(3), key=lambda i: abs(p - centers[i]))  # 0=S,1=M,2=L

    return [cat(p) for p in pulses], centers

def decode_bytes_from_categories(cats: List[Optional[int]]) -> bytes:
    """
    Best-effort byte decoder:
      Look for a plausible byte boundary (L then S/M), then 8 bits as pairs:
        (M,S) -> 1
        (S,M) -> 0
    LSB-first.
    """
    out = bytearray()
    i = 0
    n = len(cats)
    while i < n - 60:
        if cats[i] == 2 and cats[i+1] in (0, 1):
            j = i + 2
            bits = []
            ok = True
            for _ in range(8):
                a, b = cats[j], cats[j+1]
                if a is None or b is None:
                    ok = False; break
                if (a, b) == (1, 0):
                    bits.append(1)
                elif (a, b) == (0, 1):
                    bits.append(0)
                else:
                    ok = False; break
                j += 2
            if ok and len(bits) == 8:
                v = 0
                for k, bit in enumerate(bits):
                    v |= (bit << k)
                out.append(v)
                i = j
                continue
        i += 1
    return bytes(out)

# ---------------- BASIC PRG finder (tolerant) ----------------

def u16le(b: bytes, off: int) -> int:
    return b[off] | (b[off+1] << 8)

def find_eol(buf: bytes, start: int, limit: int) -> int:
    end = min(len(buf), start + limit)
    return buf.find(b"\x00", start, end)

def score_basic_candidate(buf: bytes, off: int) -> Optional[Tuple[int,int,int,int]]:
    """
    Try parse a BASIC program at buf[off:].
    Returns (score, load, end_off, line_count) if plausible.
    """
    if off + 10 >= len(buf):
        return None

    load = u16le(buf, off)
    # VIC-20 BASIC often around $1001; allow broad range but penalise far away.
    if not (0x0400 <= load <= 0x4000):
        return None

    p = off + 2
    lines = 0
    total_penalty = 0
    last_lnum = -1
    last_nextptr = load

    # cap scanning so we don’t chew forever
    for _ in range(5000):
        if p + 4 >= len(buf):
            break

        nextptr = u16le(buf, p)
        lnum = u16le(buf, p+2)

        # program terminator: nextptr == 0 and lnum == 0 is common
        if nextptr == 0:
            # require at least a few lines to consider valid
            if lines >= 3:
                end_off = p + 4
                # Score: more lines, less penalty, closer load to $1001
                closeness = max(0, 40 - (abs(load - 0x1001) // 16))
                score = lines * 50 + closeness - total_penalty
                return (score, load, end_off, lines)
            break

        # Line number sanity: usually increasing, not necessarily strictly but mostly
        if lnum > 63999:
            break
        if lines > 0 and lnum < last_lnum:
            total_penalty += 10  # tolerate small glitches

        # Find end-of-line (0x00) within 512 bytes
        eol = find_eol(buf, p+4, 512)
        if eol == -1:
            break

        # Expected next offset from pointer: off + 2 + (nextptr - load)
        expected_next_off = off + 2 + (nextptr - load)
        actual_next_off = eol + 1

        # If decode is slightly off, pointer may be wrong. Penalise mismatch but continue.
        mismatch = abs(expected_next_off - actual_next_off)
        if mismatch > 64:
            total_penalty += 25
        elif mismatch > 0:
            total_penalty += mismatch // 4

        # Nextptr should generally move forward
        if nextptr <= last_nextptr:
            total_penalty += 15

        # Advance using actual EOL (more robust than trusting pointer)
        last_lnum = lnum
        last_nextptr = nextptr
        p = actual_next_off
        lines += 1

        # If penalty gets ridiculous, bail
        if total_penalty > 400:
            break

    return None

def find_best_basic(buf: bytes) -> Tuple[int,int,int,int]:
    """
    Returns (best_off, load, end_off, line_count)
    """
    best = None  # (score, off, load, end_off, lines)
    # scanning every byte is fine for ~few MB; your decoded stream is smaller
    for off in range(0, max(0, len(buf) - 4096)):
        r = score_basic_candidate(buf, off)
        if r:
            score, load, end_off, lines = r
            if best is None or score > best[0]:
                best = (score, off, load, end_off, lines)
    if best is None:
        raise RuntimeError(
            "Could not find a plausible BASIC PRG in the decoded bytes.\n"
            "This means the byte decoder is still too lossy for structural recovery.\n"
            "Next step would be bit/parity-correct decoding from pulses."
        )
    _, off, load, end_off, lines = best
    return off, load, end_off, lines

# ---------------- BASIC detokeniser ----------------

TOK: Dict[int, str] = {
    0x80:"END",0x81:"FOR",0x82:"NEXT",0x83:"DATA",0x84:"INPUT#",0x85:"INPUT",0x86:"DIM",
    0x87:"READ",0x88:"LET",0x89:"GOTO",0x8A:"RUN",0x8B:"IF",0x8C:"RESTORE",0x8D:"GOSUB",
    0x8E:"RETURN",0x8F:"REM",0x90:"STOP",0x91:"ON",0x92:"WAIT",0x93:"LOAD",0x94:"SAVE",
    0x95:"VERIFY",0x96:"DEF",0x97:"POKE",0x98:"PRINT#",0x99:"PRINT",0x9A:"CONT",0x9B:"LIST",
    0x9C:"CLR",0x9D:"CMD",0x9E:"SYS",0x9F:"OPEN",0xA0:"CLOSE",0xA1:"GET",0xA2:"NEW",
    0xA3:"TAB(",0xA4:"TO",0xA5:"FN",0xA6:"SPC(",0xA7:"THEN",0xA8:"NOT",0xA9:"STEP",
    0xAA:"+",0xAB:"-",0xAC:"*",0xAD:"/",0xAE:"^",0xAF:"AND",0xB0:"OR",0xB1:">",0xB2:"=",
    0xB3:"<",0xB4:"SGN",0xB5:"INT",0xB6:"ABS",0xB7:"USR",0xB8:"FRE",0xB9:"POS",0xBA:"SQR",
    0xBB:"RND",0xBC:"LOG",0xBD:"EXP",0xBE:"COS",0xBF:"SIN",0xC0:"TAN",0xC1:"ATN",0xC2:"PEEK",
    0xC3:"LEN",0xC4:"STR$",0xC5:"VAL",0xC6:"ASC",0xC7:"CHR$",0xC8:"LEFT$",0xC9:"RIGHT$",
    0xCA:"MID$",
}

def petscii_best_ascii_byte(x: int) -> str:
    if x == 0xA0: return " "
    if 32 <= x <= 126: return chr(x)
    return "."

def detokenise_line(body: bytes) -> str:
    out = []
    in_quotes = False
    i = 0
    while i < len(body):
        b = body[i]
        if b == 0x00: break
        if b == 0x22:
            in_quotes = not in_quotes
            out.append('"'); i += 1; continue
        if in_quotes:
            out.append(petscii_best_ascii_byte(b)); i += 1; continue
        if b >= 0x80:
            out.append(TOK.get(b, "{%02X}" % b)); i += 1; continue
        out.append(petscii_best_ascii_byte(b)); i += 1
    s = "".join(out)
    s = " ".join(s.split())
    return s

def prg_to_listing(prg: bytes) -> str:
    load = u16le(prg, 0)
    off = 2
    lines_out = []
    for _ in range(20000):
        if off + 4 > len(prg): break
        nextptr = u16le(prg, off)
        lnum = u16le(prg, off+2)
        if nextptr == 0:
            break
        eol = prg.find(b"\x00", off+4)
        if eol == -1: break
        body = prg[off+4:eol]
        lines_out.append(f"{lnum} {detokenise_line(body)}")
        # advance by actual eol (robust)
        off = eol + 1
    return "\n".join(lines_out) + "\n"

# ---------------- main ----------------

def main():
    ap = argparse.ArgumentParser(description="Find and recover VIC/Commodore BASIC PRG from a TAP by structural scanning.")
    ap.add_argument("tap")
    ap.add_argument("--decoded", default="decoded_bytes.bin", help="Write raw decoded bytes here (debug)")
    ap.add_argument("--prg", default="recovered.prg")
    ap.add_argument("--bas", default="recovered.bas.txt")
    args = ap.parse_args()

    pulses = read_tap_v1_pulses(args.tap)
    cats, centers = classify_sml(pulses)
    decoded = decode_bytes_from_categories(cats)

    open(args.decoded, "wb").write(decoded)

    best_off, load, end_off, line_count = find_best_basic(decoded)
    prg = decoded[best_off:end_off]
    open(args.prg, "wb").write(prg)

    listing = prg_to_listing(prg)
    open(args.bas, "w", encoding="utf-8").write(listing)

    print("Pulse centers (S/M/L):", centers)
    print("Decoded bytes length:", len(decoded))
    print("Best BASIC candidate at decoded offset:", best_off)
    print("Candidate load address: $%04X" % load)
    print("Candidate PRG length:", len(prg))
    print("Candidate line count:", line_count)
    print("Wrote:", args.decoded)
    print("Wrote:", args.prg)
    print("Wrote:", args.bas)

if __name__ == "__main__":
    main()
