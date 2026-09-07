# Hyperdrive recovered rules and reachability

**SPOILERS: this document gives puzzle solutions and a complete winning route.**

This concerns Ken Stone's original Hyperdrive, whose recovered banner credits
Ken Stone and John Hardy, copyright Micro Parts 1982. It is not Hyperdrive 2.
Rules below are grounded in recovered BASIC revision `fc90c8e`. The later
`4c9db58` listing changes presentation and parsing but preserves all numeric
world data and the puzzle/combat/scoring rules. The repository pseudocode is
not an oracle: its compass and transmat conditions are reversed and its tool
indices and oxygen-death explanation are incorrect.

## Source-to-rule inventory

| BASIC lines | Recovered behavior |
| --- | --- |
| 385–418 | 54 rooms, N/S/W/E exits, 24 object positions; 0 absent, -1 carried |
| 178–179 | A command on ladder 11 closes 10N and 12N |
| 184–185 | Removing then returning fuse in pod 17 opens 17E on next command |
| 229–230 | Compass carried or present gives reliable direction; otherwise random |
| 242–255 | TRANSMAT returns to 16 anywhere; bracelet carried at 16 permits Y→1, B→31, C→41 |
| 265–272 | Carry capacity 11 |
| 280–287 | Screwdriver in 2 opens yacht; in 27 opens to54; tool stays behind |
| 211–226, 289–309 | Hostile machines demand blaster; rusty drone abducts to33; hit chance38%; cumulative shot count raises fatal risk |
| 311–325 | Matches with bomb consume bomb, displace to previous numeric room; conditional exits at2,51,20 |
| 326–333 | Rope at28 lowers player into27, leaving rope above |
| 476–485 | Room47 requires ECHO before ordinary command input resumes |
| 88–92 | Second room description with processor still at50 kills player |
| 182–183,186 | Vault visit opens45N→31; visiting49 opens48E→49 |
| 465–475,486 | READ at31 gives processor/memory shutdown clue |
| 22–24,112–115,152 | Oxygen warning suppresses description, not death; abbreviated directions bypass turn increment |
| 335–371 | Weighted salvage scoring; 126 gives best ending at yacht after docking |

The bomb contributes six deposited points but is consumed on the verified
route. The other ten salvage objects deposited give126. Death or QUIT invokes
scoring; merely returning to the yacht does not end play. At yacht after docking,
less than80 explodes,80–109 strands the yacht,110–125 returns at half speed,
and exactly126 gives the superior-drive ending.132 is numerically possible
with all salvage banked but has no complete ending paragraph in the BASIC.

## Executed ordinary route

Run `node test/support/original-route.mjs` to reproduce the trace and assertions.
The reference model executes commands against extracted original exits and
object placements; it never assigns a location to obtain an item. It enforces
compass availability,11-item capacity, ladder collapse, encounters, transmat
bracelet/destination conditions, echo, bomb consumption and vault exposure.
The source's fuse mutation is implemented although this winning route does not
visit the pod. Every combat roll is deliberately a successful shot: this proves
reachability, not probability or survivability for arbitrary random seeds. The
model is a bounded route oracle, not a general BASIC interpreter. It does not
qualify CP/M assembly execution or emulate the source parser.

Each row gives command and resulting room. TRANSMAT Y/B/C represents the
TRANSMAT command followed by its separate destination-code answer.

| Step | Command | Room |
| --- | --- | --- |
| 1 | `TAKE COMPASS` | 1 |
| 2 | `N` | 2 |
| 3 | `TAKE MATCHES` | 2 |
| 4 | `E` | 3 |
| 5 | `S` | 6 |
| 6 | `E` | 7 |
| 7 | `TAKE BLASTER` | 7 |
| 8 | `N` | 8 |
| 9 | `N` | 9 |
| 10 | `TAKE CLOCK` | 9 |
| 11 | `N` | 10 |
| 12 | `N` | 11 |
| 13 | `N` | 12 |
| 14 | `TAKE MASK` | 12 |
| 15 | `S` | 36 |
| 16 | `USE BLASTER` | 36 |
| 17 | `N` | 37 |
| 18 | `TAKE PUMP` | 37 |
| 19 | `N` | 36 |
| 20 | `E` | 24 |
| 21 | `E` | 25 |
| 22 | `USE BLASTER` | 25 |
| 23 | `W` | 24 |
| 24 | `W` | 36 |
| 25 | `N` | 37 |
| 26 | `S` | 38 |
| 27 | `S` | 39 |
| 28 | `W` | 40 |
| 29 | `TAKE ROPE` | 40 |
| 30 | `E` | 39 |
| 31 | `N` | 37 |
| 32 | `N` | 36 |
| 33 | `E` | 24 |
| 34 | `E` | 25 |
| 35 | `N` | 28 |
| 36 | `USE ROPE` | 27 |
| 37 | `TAKE BRACELET` | 27 |
| 38 | `TRANSMAT` | 16 |
| 39 | `USE BLASTER` | 16 |
| 40 | `TRANSMAT Y` | 1 |
| 41 | `DROP PUMP` | 1 |
| 42 | `DROP CLOCK` | 1 |
| 43 | `TRANSMAT` | 16 |
| 44 | `N` | 26 |
| 45 | `TAKE BOMB` | 26 |
| 46 | `USE MATCHES` | 25 |
| 47 | `W` | 24 |
| 48 | `W` | 36 |
| 49 | `W` | 23 |
| 50 | `W` | 22 |
| 51 | `S` | 21 |
| 52 | `TAKE BOOK` | 21 |
| 53 | `W` | 20 |
| 54 | `N` | 18 |
| 55 | `W` | 19 |
| 56 | `TAKE TOOLKIT` | 19 |
| 57 | `TAKE SCREWDRIVER` | 19 |
| 58 | `TRANSMAT` | 16 |
| 59 | `TRANSMAT Y` | 1 |
| 60 | `DROP BOOK` | 1 |
| 61 | `DROP TOOLKIT` | 1 |
| 62 | `DROP SCREWDRIVER` | 1 |
| 63 | `TRANSMAT` | 16 |
| 64 | `TRANSMAT B` | 31 |
| 65 | `E` | 32 |
| 66 | `S` | 33 |
| 67 | `TAKE TAPE` | 33 |
| 68 | `TRANSMAT` | 16 |
| 69 | `TRANSMAT Y` | 1 |
| 70 | `DROP TAPE` | 1 |
| 71 | `TRANSMAT` | 16 |
| 72 | `TRANSMAT C` | 41 |
| 73 | `TAKE SERVO` | 41 |
| 74 | `S` | 42 |
| 75 | `USE BLASTER` | 42 |
| 76 | `W` | 43 |
| 77 | `S` | 44 |
| 78 | `N` | 45 |
| 79 | `E` | 47 |
| 80 | `ECHO` | 47 |
| 81 | `S` | 48 |
| 82 | `S` | 49 |
| 83 | `N` | 50 |
| 84 | `TAKE PROCESSOR` | 50 |
| 85 | `TAKE MEMORY` | 50 |
| 86 | `TRANSMAT` | 16 |
| 87 | `TRANSMAT Y` | 1 |
| 88 | `DROP SERVO` | 1 |
| 89 | `DROP PROCESSOR` | 1 |
| 90 | `DROP MEMORY` | 1 |
| 91 | `DROP BRACELET` | 1 |
| 92 | `DROP COMPASS` | 1 |
| 93 | `QUIT` | 1 |

Final assertions: score126; bomb absent; ladder exits closed; maze return45N
opened to31; minefield48E opened to49; ECHO solved; one sonic exposure only.
No random navigation or oxygen-description suppression was needed.

## Repairs proposed separately from historical rules

These are port design recommendations, not silently assumed in the oracle:

- Use a bounded case-insensitive parser with valid object indices. The modern
  listing introduces duplicate155 and inconsistent case conversion.
- Explain YACHT/BRIDGE/COMPUTER codes through available text and resolve the pod
  description's secret-code claim against its actual fuse mechanism.
- Define consistent turn/resource policy. Retain period tension without making
  HELP or inventory lethal; prove sufficient resources through ordinary routes.
- Resolve score126 versus132 explicitly; provide clear finish, quit and restart
  commands with cancellation and predictable CP/M return.
- Keep echo as a puzzle state while allowing help, save and exit commands.
- Bound defeated/abducting enemy relocation; original additions can exceed54.
- Decide deliberately whether the minefield remains a narrative danger; its
  original north/south route is safe and needs no magnet or random check.
- Document any changed map edges. Preserve the original graph as a comparison
  artifact so changes remain reviewable.

The CP/M implementation must independently prove full play, saves and recovery,
then actual deployed browser execution. This route model does not replace those
acceptance gates.
