#!/usr/bin/env python3
import argparse
import re

LOC_START = (
    "YOU ARE ",
    "YOU HAVE ENTERED",
    "YOU ARE IN ",
)

def is_location_header(line: str) -> bool:
    u = line.upper()
    return u.startswith(LOC_START)

def classify(lines: list[str]):
    groups = []
    current = None

    for line in lines:
        line = line.strip()
        if not line:
            continue

        if is_location_header(line):
            if current:
                groups.append(current)
            current = {"header": line, "lines": []}
        else:
            if current:
                current["lines"].append(line)
            else:
                # preamble / global text
                if not groups or groups[-1].get("header") != "__GLOBAL__":
                    groups.append({"header": "__GLOBAL__", "lines": []})
                groups[-1]["lines"].append(line)

    if current:
        groups.append(current)
    return groups

def lightly_clean(s: str) -> str:
    # Fix doubled quotes, trim stray trailing quotes, collapse spaces
    s = s.replace('""', '"')
    s = re.sub(r"\s+", " ", s).strip()
    if s.endswith('."') and not s.endswith('..."'):
        s = s[:-1]  # remove final stray quote
    return s

def main():
    ap = argparse.ArgumentParser(description="Group extracted strings into locations (heuristic).")
    ap.add_argument("-i", "--infile", default="all_strings.txt", help="Input file from tap_dump_all_strings.py")
    ap.add_argument("-o", "--out", default="grouped_by_location.txt", help="Grouped output file")
    args = ap.parse_args()

    raw_lines = [l.rstrip("\n") for l in open(args.infile, "r", encoding="utf-8", errors="replace")]
    raw_lines = [lightly_clean(l) for l in raw_lines if l.strip()]

    groups = classify(raw_lines)

    with open(args.out, "w", encoding="utf-8") as f:
        for g in groups:
            hdr = g["header"]
            if hdr == "__GLOBAL__":
                f.write("GLOBAL / SYSTEM TEXT\n")
            else:
                f.write(hdr + "\n")
            for line in g["lines"]:
                f.write("  " + line + "\n")
            f.write("\n")

    print(f"Groups written: {len(groups)} -> {args.out}")

if __name__ == "__main__":
    main()
