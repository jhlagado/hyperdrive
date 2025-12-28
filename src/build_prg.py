#!/usr/bin/env python3
import re
import subprocess
import sys
from pathlib import Path


def to_petscii_byte(ch: str) -> int:
    o = ord(ch)
    if 65 <= o <= 90:
        return o + 128
    if 97 <= o <= 122:
        return o - 32 + 128
    return o


def petscii_transform_line(rest: str) -> bytes:
    # Convert quoted strings and DATA fields to PETSCII uppercase.
    rest_lower = rest.lower()
    data_match = re.search(r"\bdata\b", rest_lower)
    data_end = data_match.end() if data_match else -1
    in_str = False
    in_data = False
    out = bytearray()
    for idx, ch in enumerate(rest):
        if not in_str and data_end != -1 and idx >= data_end:
            in_data = True
        if ch == '"':
            in_str = not in_str
            out.append(ord(ch))
            continue
        if in_str or in_data:
            out.append(to_petscii_byte(ch))
        else:
            out.append(ord(ch))
    return bytes(out)


def main() -> int:
    here = Path(__file__).resolve().parent
    if len(sys.argv) < 2:
        print("Usage: build_prg.py <source.bas> [output.prg]", file=sys.stderr)
        return 1

    src = Path(sys.argv[1]).expanduser()
    if not src.is_absolute():
        src = here / src

    if len(sys.argv) >= 3:
        prg = Path(sys.argv[2]).expanduser()
        if not prg.is_absolute():
            prg = here / prg
    else:
        prg = src.with_suffix(".prg")

    tmp = src.with_suffix(".temp.bas")

    if not src.exists():
        print(f"Missing source: {src}", file=sys.stderr)
        return 1

    tmp_text = src.read_text()
    out_lines = []
    for line in tmp_text.splitlines():
        m = re.match(r"^(\d+\s+)(.*)$", line)
        if not m:
            out_lines.append(line.encode("latin-1"))
            continue
        num, rest = m.groups()
        out_lines.append(num.encode("latin-1") + petscii_transform_line(rest))
    tmp.write_bytes(b"\n".join(out_lines) + b"\n")

    try:
        subprocess.run(
            ["petcat", "-w2", "-l", "1001", "-f", "-o", str(prg), str(tmp)],
            check=True,
        )
    except FileNotFoundError:
        print("petcat not found in PATH.", file=sys.stderr)
        return 1
    except subprocess.CalledProcessError as exc:
        print(f"petcat failed: {exc}", file=sys.stderr)
        return 1

    print(f"Built {prg}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
