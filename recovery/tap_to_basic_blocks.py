#!/usr/bin/env python3
import argparse, struct
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
    stream = b[20:20 + data_len]
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

# ---------------- pulse clustering (S/M/L) ----------------

def kmeans_1d(values: List[int], k: int = 3, iters: int = 40) -> List[float]:
    vs = sorted(values)
    seeds = [vs[int((i + 1) * len(vs) / (k + 1))] for i in range(k)]
    centers = [float(s) for s in seeds]
    for _ in range(iters):
        buckets = [[] for _ in range(k)]
        for v in values:
            j = min(range(k), key=lambda i: abs(v - centers[i]))
            buckets[j].append(v)
        new_centers = [(sum(b) / len(b)) if b else centers[i] for i, b in enumerate(buckets)]
        if all(abs(new_centers[i] - centers[i]) < 1e-6 for i in range(k)):
            break
        centers = new_centers
    return sorted(centers)

def classify_short_medium_long(pulses: List[int]) -> Tuple[List[Optional[int]], List[float]]:
    small = [p for p in pulses if 10 <= p <= 250]
    if not small:
        raise ValueError("No clusterable pulses found (10..250).")
    centers = kmeans_1d(small, 3)

    def cat(p: int) -> Optional[int]:
        if p < 10 or p > 250: return None
        return min(range(3), key=lambda i: abs(p - centers[i]))  # 0=S,1=M,2=L

    return [cat(p) for p in pulses], centers

# ---------------- pulse categories -> bytes ----------------
# Still "best effort": enough to get block structure if decoding is close.

def decode_bytes_from_pulse_categories(cats: List[Optional[int]]) -> bytes:
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
                if a is None or b is None: ok = False; break
                if (a, b) == (1, 0): bits.append(1)
                elif (a, b) == (0, 1): bits.append(0)
                else: ok = False; break
                j += 2
            if ok and len(bits) == 8:
                val = 0
                for k, bit in enumerate(bits):
                    val |= (bit << k)  # LSB-first
                out.append(val)
                i = j
                continue
        i += 1

    return bytes(out)

# ---------------- Commodore tape block parsing ----------------

COUNTDOWN_A = bytes([0x89,0x88,0x87,0x86,0x85,0x84,0x83,0x82,0x81])  # first copy
COUNTDOWN_B = bytes([0x09,0x08,0x07,0x06,0x05,0x04,0x03,0x02,0x01])  # duplicate copy

def xor_checksum(payload: bytes) -> int:
    x = 0
    for b in payload:
        x ^= b
    return x & 0xFF

def find_blocks(decoded: bytes) -> List[Tuple[int, bytes, int, bool]]:
    """
    Return list of (offset_after_countdown, payload192, checksum_byte, is_copyB).
    """
    blocks = []
    i = 0
    L = len(decoded)

    while i < L - (9 + 192 + 1):
        if decoded[i:i+9] == COUNTDOWN_A:
            off = i + 9
            payload = decoded[off:off+192]
            cks = decoded[off+192]
            blocks.append((off, payload, cks, False))
            i = off + 192 + 1
            continue
        if decoded[i:i+9] == COUNTDOWN_B:
            off = i + 9
            payload = decoded[off:off+192]
            cks = decoded[off+192]
            blocks.append((off, payload, cks, True))
            i = off + 192 + 1
            continue
        i += 1

    return blocks

def u16le(b: bytes, off: int) -> int:
    return b[off] | (b[off+1] << 8)

def parse_header(header192: bytes) -> Tuple[int,int,int,bytes]:
    """
    Returns: (file_type, start_addr, end_addr, raw_filename_16)
    """
    ftype = header192[0]
    start = u16le(header192, 1)
    end = u16le(header192, 3)
    rawname = header192[5:21]  # 16 bytes, PETSCII-ish padded with spaces
    return ftype, start, end, rawname

def score_header_candidate(payload: bytes) -> Optional[Tuple[int,int,int,bytes,int,int]]:
    """
    Heuristically decide whether payload looks like a real Commodore header block.

    Returns (ftype, start, end, rawname, length, score) if plausible.
    """
    ftype, start, end, rawname = parse_header(payload)
    length = end - start

    # Very broad sanity checks
    if not (0x0200 <= start <= 0x8000):
        return None
    if not (512 <= length <= 32768):  # BASIC program likely >= 0.5K and <= 32K
        return None

    # Filename should be mostly printable-ish (spaces allowed)
    printable = 0
    nonspace = 0
    for c in rawname:
        if c != 0x20:
            nonspace += 1
        # accept common printable range
        if 0x20 <= c <= 0x5A or 0x61 <= c <= 0x7A or 0x30 <= c <= 0x39 or c in (0x2D, 0x2E, 0x5F):
            printable += 1
        elif c == 0x20:
            printable += 1

    if nonspace == 0:
        return None

    # Score: prefer plausible BASIC start addresses + printable names + bigger programs
    score = 0
    # VIC-20 BASIC program area often around $1001; allow range and reward closeness
    if 0x0F00 <= start <= 0x2000:
        score += 20
        score += max(0, 20 - abs(start - 0x1001) // 32)

    score += printable  # up to 16
    score += min(40, length // 512)  # reward larger payload

    return (ftype, start, end, rawname, length, score)

def decode_filename(rawname: bytes) -> str:
    # Best-effort: treat bytes as Latin-1, strip trailing spaces
    return rawname.rstrip(b"\x20").decode("latin-1", errors="replace")

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
        if b == 0x00:
            break
        if b == 0x22:  # quote
            in_quotes = not in_quotes
            out.append('"')
            i += 1
            continue
        if in_quotes:
            out.append(petscii_best_ascii_byte(b))
            i += 1
            continue
        if b >= 0x80:
            out.append(TOK.get(b, "{%02X}" % b))
            i += 1
            continue
        out.append(petscii_best_ascii_byte(b))
        i += 1
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
        if eol == -1:
            break
        body = prg[off+4:eol]
        lines_out.append(f"{lnum} {detokenise_line(body)}")
        next_off = 2 + (nextptr - load)
        if next_off <= off or next_off > len(prg):
            break
        off = next_off
    return "\n".join(lines_out) + "\n"

# ---------------- main ----------------

def main():
    ap = argparse.ArgumentParser(description="Recover Commodore BASIC listing from TAP by parsing tape blocks.")
    ap.add_argument("tap")
    ap.add_argument("--prg", default="recovered.prg")
    ap.add_argument("--bas", default="recovered.bas.txt")
    ap.add_argument("--use_copy", choices=["A","B","AUTO"], default="AUTO",
                    help="Which tape block copy to use: A, B, or AUTO (prefer A if present)")
    args = ap.parse_args()

    pulses = read_tap_v1_pulses(args.tap)
    cats, centers = classify_short_medium_long(pulses)
    decoded = decode_bytes_from_pulse_categories(cats)

    blocks = find_blocks(decoded)
    if not blocks:
        raise RuntimeError("No countdown blocks found in decoded byte stream. Try rebuilding TAP with --invert.")

    # Choose which copy stream to use
    a_blocks = [b for b in blocks if not b[3]]
    b_blocks = [b for b in blocks if b[3]]

    if args.use_copy == "A":
        use_blocks = a_blocks
    elif args.use_copy == "B":
        use_blocks = b_blocks
    else:
        use_blocks = a_blocks if a_blocks else b_blocks

    if not use_blocks:
        raise RuntimeError("No blocks available for selected copy stream.")

    # Scan all blocks for the best-looking header
    best = None  # (index, ftype, start, end, rawname, length, score)
    for idx, (_, payload, _, _) in enumerate(use_blocks):
        cand = score_header_candidate(payload)
        if cand:
            ftype, start, end, rawname, length, score = cand
            if best is None or score > best[6]:
                best = (idx, ftype, start, end, rawname, length, score)

    if best is None:
        raise RuntimeError(
            "No plausible header block found. "
            "This usually means the WAV->TAP conversion polarity/target is wrong "
            "or the byte decoding isn't stable enough."
        )

    hdr_index, ftype, start, end, rawname, length, score = best
    name = decode_filename(rawname)

    # Assemble data blocks AFTER the chosen header
    data_payloads = [b[1] for b in use_blocks[hdr_index+1:]]
    assembled = b"".join(data_payloads)

    if len(assembled) < length:
        # Still write what we have, but warn loudly
        print(f"WARNING: Need {length} bytes but only assembled {len(assembled)} bytes from blocks.")

    assembled = assembled[:length]

    prg = struct.pack("<H", start) + assembled
    open(args.prg, "wb").write(prg)

    listing = prg_to_listing(prg)
    open(args.bas, "w", encoding="utf-8").write(listing)

    # diagnostics
    def count_ck_matches(blks):
        good = 0
        for _, payload, cks, _ in blks[:min(len(blks), 200)]:
            if xor_checksum(payload) == cks:
                good += 1
        return good

    good_ck = count_ck_matches(use_blocks)
    print("Pulse centers (S/M/L):", centers)
    print("Decoded byte stream length:", len(decoded))
    print("Countdown blocks found (A/B/total):", len(a_blocks), len(b_blocks), len(blocks))
    print("Using copy:", ("A" if use_blocks is a_blocks else "B"), "blocks:", len(use_blocks))
    print("Checksum matches in first 200 used blocks:", good_ck, "/", min(len(use_blocks), 200))
    print("Selected header block index:", hdr_index, "score:", score)
    print("Header: type=$%02X start=$%04X end=$%04X len=%d name=%r" %
          (ftype, start, end, length, name))
    print("Assembled payload bytes:", len(assembled))
    print("Wrote:", args.prg)
    print("Wrote:", args.bas)

if __name__ == "__main__":
    main()
