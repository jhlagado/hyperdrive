#!/usr/bin/env python3
import argparse
import struct
import re
from typing import List, Optional, Tuple

TAP_SIG = b"C64-TAPE-RAW"

def read_tap_v1_pulses(path: str) -> List[int]:
    b = open(path, "rb").read()
    if len(b) < 20 or b[:12] != TAP_SIG:
        raise ValueError("Not a TAP file with C64-TAPE-RAW signature")

    version = b[12]
    if version != 1:
        raise ValueError(f"Unsupported TAP version {version}")

    data_len = struct.unpack("<I", b[16:20])[0]
    stream = b[20:20 + data_len]

    pulses = []
    i = 0
    while i < len(stream):
        x = stream[i]
        if x != 0:
            pulses.append(x)
            i += 1
        else:
            if i + 3 >= len(stream):
                break
            v = stream[i+1] | (stream[i+2] << 8) | (stream[i+3] << 16)
            pulses.append(v)
            i += 4
    return pulses

def kmeans_1d(values: List[int], k: int = 3, iters: int = 40) -> List[float]:
    vs = sorted(values)
    seeds = [vs[int((i + 1) * len(vs) / (k + 1))] for i in range(k)]
    centers = [float(s) for s in seeds]

    for _ in range(iters):
        buckets = [[] for _ in range(k)]
        for v in values:
            j = min(range(k), key=lambda i: abs(v - centers[i]))
            buckets[j].append(v)

        new_centers = [
            (sum(b) / len(b)) if b else centers[i]
            for i, b in enumerate(buckets)
        ]

        if all(abs(new_centers[i] - centers[i]) < 1e-6 for i in range(k)):
            break
        centers = new_centers

    return sorted(centers)

def classify_short_medium_long(
    pulses: List[int]
) -> Tuple[List[Optional[int]], List[float]]:
    small = [p for p in pulses if 10 <= p <= 250]
    if not small:
        raise ValueError("No usable pulses found")

    centers = kmeans_1d(small, 3)

    def cat(p: int) -> Optional[int]:
        if p < 10 or p > 250:
            return None
        return min(range(3), key=lambda i: abs(p - centers[i]))

    cats = [cat(p) for p in pulses]
    return cats, centers

def decode_bytes_from_pulse_categories(cats: List[Optional[int]]) -> bytes:
    out = bytearray()
    i = 0
    n = len(cats)

    while i < n - 40:
        if cats[i] == 2 and cats[i+1] in (0, 1):
            j = i + 2
            bits = []
            ok = True

            for _ in range(8):
                a, b = cats[j], cats[j+1]
                if a is None or b is None:
                    ok = False
                    break
                if (a, b) == (1, 0):
                    bits.append(1)
                elif (a, b) == (0, 1):
                    bits.append(0)
                else:
                    ok = False
                    break
                j += 2

            if ok and len(bits) == 8:
                val = sum(bit << k for k, bit in enumerate(bits))
                out.append(val)
                i = j
                continue

        i += 1

    return bytes(out)

def bytes_to_best_effort_ascii(data: bytes) -> str:
    chars = []
    for b in data:
        if b in (10, 13):
            chars.append("\n")
        elif b == 0xA0:
            chars.append(" ")
        elif 32 <= b <= 126:
            chars.append(chr(b))
        else:
            chars.append("\0")
    return "".join(chars)

def extract_strings(text: str, min_len: int) -> List[str]:
    out = []
    for m in re.finditer(r"[A-Za-z0-9][A-Za-z0-9 \-_,\.\!\?'\"]+", text):
        s = re.sub(r"\s+", " ", m.group()).strip()
        if len(s) >= min_len:
            out.append(s)
    return out

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("tap")
    ap.add_argument("-o", "--out", default="all_strings.txt")
    ap.add_argument("--minlen", type=int, default=2)
    args = ap.parse_args()

    pulses = read_tap_v1_pulses(args.tap)
    cats, centers = classify_short_medium_long(pulses)
    decoded = decode_bytes_from_pulse_categories(cats)
    text = bytes_to_best_effort_ascii(decoded)
    strings = extract_strings(text, args.minlen)

    seen = set()
    uniq = []
    for s in strings:
        if s not in seen:
            seen.add(s)
            uniq.append(s)

    with open(args.out, "w") as f:
        for s in uniq:
            f.write(s + "\n")

    print("Pulse centers (S/M/L):", centers)
    print("Decoded bytes:", len(decoded))
    print("Strings written:", len(uniq))

if __name__ == "__main__":
    main()
