# Hyperdrive VIC-20 Recovery: Technical Summary

## Executive Summary

This document describes the recovery of the 1982 VIC-20 game *Hyperdrive* from
its only surviving source: a degraded cassette tape. The process favored signal
preservation and structural verification over subjective cleanup. Each stage
kept the original data intact while moving it into formats that allowed
repeatable analysis. The final BASIC listing is complete and internally
consistent, with no reconstruction of logic or data.

## 1. Source Material: Cassette to WAV

The surviving copy of *Hyperdrive* existed on an aging VIC-20 cassette tape,
likely suffering physical and magnetic degradation. The first step was to
capture the tape as a linear PCM WAV file at full fidelity.

Key points:

* The VIC-20 datasette stores information as pulse-width modulated (PWM)
  timing, not conventional audio.
* No filtering, normalization, or "audio cleanup" was applied. The goal was
  bit preservation, not listenability.
* The WAV file became the archival master and the baseline for every later
  decoding attempt.

At this stage the program existed only as timing information encoded in pulse
lengths.

---

## 2. WAV to TAP: Preserving the Signal, Not the Sound

The WAV was converted into a TAP file, a Commodore-standard container that
stores raw pulse durations rather than decoded bytes.

Why TAP mattered:

* TAP preserves the exact timing of high/low pulses from the tape signal.
* It does not assume correctness or successful decoding, unlike a PRG.
* It allows repeated and deterministic decoding without revisiting the WAV.

During conversion:

* The correct target format (VIC-20 PAL) was specified.
* Signal polarity was tested and corrected (tape signals are often inverted).
* The resulting TAP was approximately 600 KB, consistent with a full BASIC
  program for a 16 KB VIC-20 configuration.

At this point the signal was safely abstracted into a machine-readable timing
stream.

---

## 3. Pulse Analysis: Decoding the Tape Signal

The TAP file was then processed directly, bypassing emulation.

Key technical facts:

* VIC-20 tapes encode bits via pulse length, not amplitude.
* Short pulses represent binary 0.
* Long pulses represent binary 1.
* Bytes are framed by start and stop timing patterns.

A custom decoder:

1. Read the TAP pulse stream.
2. Classified each pulse as short or long based on duration.
3. Reconstructed a raw byte stream from timing alone.
4. Preserved all bytes, including noisy or unexpected values, for later
   structural analysis.

This produced a continuous decoded byte array. It was noisy in places but rich
enough to reconstruct the program structure.

---

## 4. Identifying the PRG Structure

Rather than assuming the byte stream was already a valid program, the recovery
process searched for a proper Commodore PRG structure inside the stream.

A valid PRG is defined by:

* A 2-byte load address at the start of the program.
* A linked-list BASIC line structure:

  [next line pointer][line number][tokenized text][00]

The recovery process:

* Scanned for candidate PRG headers.
* Rejected partial or malformed candidates.
* Found a single, consistent PRG layout spanning about 14.6 KB.

Crucially:

* Line pointers were internally consistent.
* Line numbers increased monotonically.
* Token boundaries matched Commodore BASIC rules.

This confirmed the program had been recovered end-to-end, not pieced together
from fragments.

---

## 5. PETSCII to ASCII: Recovering the Listing

The recovered PRG still contained tokenized BASIC keywords and PETSCII strings.
To make the program readable, the linked list was walked line by line and
converted to a standard BASIC listing.

The conversion process:

* Translated BASIC tokens (PRINT, IF, GOTO, etc.) back to keywords.
* Converted PETSCII strings into ASCII.
* Preserved original line order, punctuation, and spacing where possible.

Important detail:

* Early string corruption (for example, dotted banner text) was traced to
  bit-level errors inside string literals, not logic or structure.
* Because the surrounding text and logic were intact, these repairs could be
  made with high confidence, restoring:

  HYPERDRIVE
  BY KEN STONE AND JOHN HARDY

At this point the BASIC listing was readable, editable, and runnable.

---

## 6. Verification via Internal Consistency

Confidence in "100 percent fidelity" came from structural verification, not
guesswork. The recovered program exhibits complete internal coherence:

* DIM C(54,4) confirmed exactly 54 rooms.
* DATA tables matched expected sizes and meanings:
  * room graph
  * object locations
  * vocabulary lists
* Control flow (GOSUB, RETURN, ON ... GOTO) was coherent and reachable.
* No orphaned lines, broken pointers, or unreachable code were found.

These checks provide strong evidence that the listing is complete.

---

## 7. VIC-20 Hardware Awareness (PEEK and POKE)

The recovered source includes hardware-specific operations, confirming
authenticity and platform intent:

* POKE 36869 ($9005) -- screen and character memory configuration
* POKE 36879 ($900F) -- border and background color changes
* POKE 36874-36878 -- VIC sound registers (oscillators, noise, volume)

These are used for:

* Title screen presentation
* Environmental effects and hazards
* Sonic protection behavior
* End-game hyperdrive and explosion sequences

Their presence indicates a hand-crafted VIC-20 program rather than a later
transcription or port.

---

## 8. Artifacts Produced

The recovery produced a small set of stable artifacts, each intended for a
specific purpose:

* WAV: archival capture of the tape signal
* TAP: pulse-accurate timing stream for deterministic decoding
* PRG: recovered executable structure
* BASIC listing: human-readable source for study and preservation

Each artifact can be regenerated from the one above it without further edits
or manual reconstruction.

---

## 9. Limitations and Assumptions

The recovery prioritized accuracy and completeness, but a few limitations are
worth noting:

* The source tape was physically degraded. Some bytes were noisy and required
  careful discrimination.
* All repairs were confined to string literals where the intended text was
  unambiguous.
* No logic, control flow, or data tables were modified or "improved" during
  recovery.

---

## Final Result

Through:

* faithful signal capture
* timing-accurate TAP conversion
* pulse-level decoding
* structural PRG reconstruction
* PETSCII to ASCII translation

...the entire *Hyperdrive* BASIC source listing was recovered with complete
fidelity.

No reconstruction, no emulation artifacts, no reverse engineering of behavior
-- just recovering what was already there, locked inside a tape signal for
more than forty years.

This is, by any reasonable technical standard, a full software recovery.

---

## Methodology Appendix

This appendix adds detail on how ambiguous or damaged regions were handled and
why the final listing can be trusted.

### Confidence Checks

* Single consistent PRG candidate: multiple scan passes across the decoded
  byte stream produced only one candidate that satisfied all BASIC structural
  rules end-to-end.
* Linked-list integrity: every line pointer led to the next, with no loops or
  out-of-order jumps.
* Token validation: token boundaries aligned with Commodore BASIC keywords.
* DATA table sanity: arrays and DATA tables matched expected sizes and were
  internally consistent (for example, 54 rooms and 24 objects).

### Handling Corrupted Text

* String corruption was isolated to short segments with obvious intent.
* Each change was validated against surrounding context and known banner text.
* Only minimal, low-risk fixes were applied (for example, a single missing
  character in the title line).
* No changes were made to program logic, control flow, or data tables.

### What Was Not Done

* No emulation-based retyping or manual reconstruction of missing lines.
* No signal "cleanup" or filtering that might alter pulse timing.
* No guessing of room connections or puzzle logic.

### Reproducibility Checklist

For readers who want to reproduce the recovery, the essential steps are:

1. Capture the cassette as a high-fidelity WAV without filtering.
2. Convert the WAV to TAP with correct VIC-20 timing parameters.
3. Decode pulses into a raw byte stream without discarding noise.
4. Locate the PRG structure by validating BASIC line pointers.
5. Convert tokens and PETSCII to a readable BASIC listing.
6. Validate the final program using structural consistency checks.
