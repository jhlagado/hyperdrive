#!/usr/bin/env python3
import re
import subprocess
import sys
from pathlib import Path


def lower_keywords_keep_strings(src_text: str) -> str:
    lines = src_text.splitlines()
    out = []
    for line in lines:
        m = re.match(r"^(\d+\s+)(.*)$", line)
        if not m:
            out.append(line.lower())
            continue
        num, rest = m.groups()
        parts = re.split(r'(".*?")', rest)
        for i in range(0, len(parts), 2):
            parts[i] = parts[i].lower()
        out.append(num + "".join(parts))
    return "\n".join(out) + "\n"


def patch_prg_strings(prg_path: Path) -> None:
    blob = bytearray(prg_path.read_bytes())
    idx = 2  # skip load address
    while idx + 4 <= len(blob):
        next_ptr = int.from_bytes(blob[idx:idx + 2], "little")
        if next_ptr == 0:
            break
        idx += 2  # next line pointer
        idx += 2  # line number
        in_str = False
        while idx < len(blob) and blob[idx] != 0:
            b = blob[idx]
            if b == 0x22:
                in_str = not in_str
            elif in_str and 193 <= b <= 218:
                blob[idx] = b - 128
            idx += 1
        if idx < len(blob) and blob[idx] == 0:
            idx += 1
    prg_path.write_bytes(blob)


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

    tmp.write_text(lower_keywords_keep_strings(src.read_text()))

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

    patch_prg_strings(prg)
    print(f"Built {prg}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
