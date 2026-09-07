import {createMachine} from '../test/support/machine.mjs';
import {proveFullRoute} from '../test/support/full-route.mjs';
import {readFile,writeFile} from 'node:fs/promises';
import assert from 'node:assert/strict';
const manifest=JSON.parse(await readFile(new URL('../build/manifest.json',import.meta.url)));
const m=await createMachine();const proof=proveFullRoute(m);
const extra={};for(const command of ['HELP','SAVE','LOAD']){const before=m.metrics.cycles;m.command(command);extra[command]=m.metrics.cycles-before;}
const sorted=proof.checkpoints.map(p=>p.cycles).sort((a,b)=>a-b);
const report={artifactSha256:manifest.sha256,memory:manifest.memory,commands:sorted.length,guestCycles:{p95:sorted[Math.ceil(sorted.length*.95)-1],max:sorted.at(-1),...extra},observedStackBytes:manifest.memory.stackEndExclusive-m.metrics.minSp,scope:'Development BDOS adapter; guest instruction cycles exclude OS, serial pacing and browser wall time. Stack observation covers this route and HELP/SAVE/LOAD, not every possible path.'};
assert(report.observedStackBytes>0&&report.observedStackBytes<=512);
assert(report.guestCycles.max<1_000_000,'ordinary command guest CPU budget: one quarter second at4MHz');
assert(extra.HELP<4_000_000,'HELP guest CPU budget');assert(extra.SAVE<1_000_000);assert(extra.LOAD<1_000_000);
await writeFile(new URL('../build/measurements.json',import.meta.url),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report,null,2));
