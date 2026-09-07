import {createMachine} from '../test/support/machine.mjs';
import {proveFullRoute} from '../test/support/full-route.mjs';
import {createRequire} from 'node:module';
import {readFile,writeFile} from 'node:fs/promises';
import assert from 'node:assert/strict';
import {pathToFileURL} from 'node:url';
import {execFileSync} from 'node:child_process';
import {createHash} from 'node:crypto';
const root=process.env.TRIPTYCH_ROOT;
if(!root)throw Error('Set TRIPTYCH_ROOT to a qualified Triptych checkout with built WASM host.');
const {buildCpmDistribution}=await import(pathToFileURL(root+'/tools/lib/cpm-distribution.mjs'));
const {installCpm22File}=await import(pathToFileURL(root+'/tools/lib/cpm22-disk.mjs'));
const hostRevision=execFileSync('git',['rev-parse','HEAD'],{cwd:root,encoding:'utf8'}).trim();
const hostDirty=execFileSync('git',['status','--porcelain'],{cwd:root,encoding:'utf8'}).length!==0;
const built=await buildCpmDistribution(root,{allowDirty:true});
const game=await readFile(new URL('../build/HYPERDRV.COM',import.meta.url));
const disk=installCpm22File(built.disk,{name:'HYPERDRV.COM',bytes:game,padByte:26});
const hostArtifacts={};
for(const name of ['triptych_host_wasm.js','triptych_host_wasm_bg.wasm'])hostArtifacts[name]=createHash('sha256').update(await readFile(root+'/dist/wasm/'+name)).digest('hex');
const {TriptychCpu}=createRequire(import.meta.url)(root+'/dist/wasm/triptych_host_wasm.js');
const cpu=new TriptychCpu(built.bootstrap);cpu.install_drive(0,disk,true);
let output='';
function until(suffix){for(let i=0;i<2000;i++){cpu.run_slice(50000,500000);output+=Buffer.from(cpu.take_serial_output()).toString('latin1');if(output.endsWith(suffix))return;if(output.endsWith('[Space/Enter: more, Q: skip] '))cpu.enqueue_serial_input(Uint8Array.of(32));}throw Error('Timeout '+output.slice(-500));}
function command(text,suffix='? '){output='';cpu.enqueue_serial_input(Buffer.from(text+'\r'));until(suffix);return output;}
const reference=await createMachine();
const proof=proveFullRoute(reference);
try {
 until('A>');command('HYPERDRV');
 for(const point of proof.checkpoints){
  command(point.command);
  assert.equal(cpu.read_ram(reference.symbols.ROOM,1)[0],point.room,point.command+' room');
  assert.deepEqual([...cpu.read_ram(reference.symbols.STATE,reference.symbols.STATEEND-reference.symbols.STATE)],point.state,point.command+' state');
 }
 assert.match(command('SCORE'),/Salvage score: 126/);
 command('SAVE');command('QUIT','Return to CP/M? (Y/N) ');command('Y','A>');
 command('HYPERDRV');assert.match(command('LOAD'),/Game loaded/);
 command('FINISH','Repair the yacht and launch now? (Y/N) ');
 assert.match(command('Y','Another adventure? (Y/N) '),/Congratulations! You made it/);
 command('N','A>');
 const saved=cpu.export_drive(0);
 await writeFile(new URL('../build/cpm-completed.img',import.meta.url),saved);
 const report={artifactSha256:createHash('sha256').update(game).digest('hex'),hostRevision,hostDirty,hostArtifacts,status:'passed',commands:proof.checkpoints.length,score:126,checks:['actual CP/M full route','state after every command','save completed game','quit to CCP','relaunch and load saved state','finish126 after loading']};
 await writeFile(new URL('../build/cpm-proof.json',import.meta.url),JSON.stringify(report,null,2)+'\n');
 console.log(JSON.stringify(report,null,2));
}finally{cpu.free();}
