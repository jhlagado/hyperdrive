import {mkdtemp,readFile,writeFile,rm} from 'node:fs/promises';
import {assembleAtomProject,materializeAtomGeneration,renderAtomArtifacts} from 'atom-z80';
import {createZ80Runtime} from '@jhlagado/debug80-runtime/z80/runtime';
import assert from 'node:assert/strict';
import test from 'node:test';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
test('native combat: exhaustive byte thresholds, enemy bounds and preserved ABI', async (t) => {
const root=await mkdtemp(join(tmpdir(),'hypercombat-'));
t.after(()=>rm(root,{recursive:true,force:true}));
await writeFile(root+'/combat.asm',await readFile(new URL('../cpm/combat.asm',import.meta.url)));
await writeFile(root+'/main.asm',`%INCLUDE "combat.asm"
TERPUT1: RET
RNG:
 PUSH HL
 PUSH DE
 LD A,(INDEX)
 LD E,A
 LD D,0
 INC A
 LD (INDEX),A
 LD HL,VALUES
 ADD HL,DE
 LD A,(HL)
 POP DE
 POP HL
 RET
INDEX: DB 0
VALUES: DB 0,0,0,0
ROOM: DB 1
SHOTS: DB 0
OBJS: DS 24,0
`);
const result=await assembleAtomProject({root,entry:'main.asm',target:{start:256,capacity:60000}});
const bytes=materializeAtomGeneration(result.generation,{base:256}).bytes;
const sym=Object.fromEntries(renderAtomArtifacts(result,{base:256,entryAddress:256}).d8.symbols.map(s=>[s.name.toUpperCase(),s.address??s.value]));
function run({id=1,room=1,shots=0,gun=255,r1=255,r2=0,r3=0,entry='SHOOT',also=[],carried=0}={}){
 const memory=new Uint8Array(65536);memory.set(bytes,256);
 const runtime=createZ80Runtime({memory,startAddress:sym[entry]},0),c=runtime.cpu,m=runtime.hardware.memory;
 m[sym.ROOM]=room;m[sym.SHOTS]=shots;if(id)m[sym.OBJS+id-1]=room;m[sym.OBJS+19]=gun;m.set([r1,r2,r3],sym.VALUES);for(const enemy of also)m[sym.OBJS+enemy-1]=room;for(let i=0;i<carried;i++)m[sym.OBJS+6+i]=255;
 c.pc=sym[entry];c.sp=0xf000;m[0xf000]=0;m[0xf001]=0xff;c.b=0x12;c.c=0x34;c.d=0x56;c.e=0x78;c.h=0x9a;c.l=0xbc;
 for(let i=0;c.pc!==0xff00;i++){assert(i<1000);runtime.step();}
 assert.deepEqual([c.b,c.c,c.d,c.e,c.h,c.l,c.sp],[0x12,0x34,0x56,0x78,0x9a,0xbc,0xf002]);
 return {a:c.a,shots:m[sym.SHOTS],room:m[sym.ROOM],enemy:id?m[sym.OBJS+id-1]:0,gun:m[sym.OBJS+19],draws:m[sym.INDEX]};
}
for(let id=0;id<=6;id++)assert.equal(run({id,entry:'ENCOUNTR'}).a,id);
assert.equal(run({id:5,also:[2,6],entry:'ENCOUNTR'}).a,2);
for(let r=0;r<256;r++){
 for(let n=1;n<=17;n++){
  const v=run({shots:n-1,r1:r,r2:0});
  const risk=[0,37,73,110,146,183,219,256][Math.max(0,n-10)];
  assert.equal(v.a,n>=17||r<risk?1:0,`shot${n} rng${r}`);
 }
 assert.equal(run({r2:r}).enemy,r<97?0:1);
}
for(let id=1;id<=6;id++){
 const hit=run({id,room:44});assert.equal(hit.enemy,id===3||id===5?54:0);
 assert.equal(run({id,room:45}).enemy,0);
}
assert.deepEqual(run({id:5,room:47,r2:97}),{a:2,shots:1,room:33,enemy:54,gun:255,draws:2});
assert.equal(run({id:5,room:48,r2:97}).enemy,0);
assert.equal(run({shots:255}).shots,255);
assert.equal(run({shots:255}).a,1);
for(const opts of [{id:0},{gun:0}]){const v=run(opts);assert.equal(v.shots,0);assert.equal(v.draws,0);}
assert.equal(run({gun:1}).gun,255);
for(const carried of [10,11]){
 const v=run({gun:1,carried});
 assert.equal(v.gun,carried===10?255:1);
 assert.equal(v.enemy,0);
 assert.equal(v.draws,2);
 assert.equal(v.shots,1);
}

t.diagnostic('4,352 threshold cases; 256 aim cases; enemy identities, bounds, rejected shots and ABI passed');
});
