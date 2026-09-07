import test from 'node:test';
import assert from 'node:assert/strict';
import {createMachine} from './support/machine.mjs';
import {winningRoute} from './support/original-route.mjs';

test('ordinary native route completes original126 ending, restart and CP/M exit',async()=>{
 const oracle=winningRoute();const m=await createMachine();m.run();
 for(const [index,step] of oracle.trace.entries()){
  let output=m.command(step.command==='QUIT'?'FINISH':step.command);
  if(step.command==='USE BLASTER'){
   for(let retry=0;retry<17&&m.memory.slice(m.symbols.OBJS,m.symbols.OBJS+6).includes(m.byte('ROOM'));retry++){
    assert.doesNotMatch(output,/Another adventure/);output+=m.command('USE BLASTER');
   }
  }
  assert.equal(m.byte('ROOM'),step.room,`step ${index}: ${step.command}: ${output}`);
  assert.equal(m.exited,false);
  assert.doesNotMatch(output,/Another adventure\?|don't understand/);
 }
 assert.deepEqual(Array.from(m.memory.slice(m.symbols.OBJS,m.symbols.OBJS+24)),oracle.objects.map(v=>v===-1?255:v));
 assert.deepEqual(Array.from(m.memory.slice(m.symbols.EXITS,m.symbols.EXITS+216)),oracle.exits.flat());
 assert.match(m.command('y'),/Salvage score: 126[\s\S]*Congratulations! You made it/);
 assert.match(m.command('y'),/Hyperdrive/);
 assert.equal(m.byte('ROOM'),1);assert.equal(m.byte('SHOTS'),0);
 m.command('quit');m.command('y');assert.equal(m.exited,true);
});

test('sonic vault permits immediate processor removal but repeated LOOK is fatal',async()=>{
 const m=await createMachine();m.run();
 m.memory[m.symbols.ROOM]=50;
 assert.match(m.command('look'),/sonic protection/);
 assert.equal(m.byte('SONIC'),1);
 const safeState=m.memory.slice(m.symbols.STATE,m.symbols.STATEEND);
 m.command('inventory');m.command('help');
 // Utility commands leave the vault state unchanged.
 assert.deepEqual(m.memory.slice(m.symbols.STATE,m.symbols.STATEEND),safeState);
 assert.match(m.command('take processor'),/Done/);
 assert.doesNotMatch(m.command('look'),/Another adventure/);
 const doomed=await createMachine();doomed.run();doomed.memory[doomed.symbols.ROOM]=50;
 doomed.command('look');assert.match(doomed.command('look'),/Prolonged sonic[\s\S]*Another adventure/);
 doomed.command('n');assert.equal(doomed.exited,true);
});

test('echo gate blocks movement but permits inventory and explicit solution',async()=>{
 const m=await createMachine();m.run();m.memory[m.symbols.ROOM]=47;m.memory[m.symbols.OBJS+7]=255;
 const sp=m.runtime.cpu.sp;
 for(let i=0;i<50;i++)assert.match(m.command('s'),/voice echoes/);
 assert.equal(m.byte('ROOM'),47);assert.equal(m.runtime.cpu.sp,sp);
 m.command('inventory');m.command('echo');m.command('s');assert.equal(m.byte('ROOM'),48);
});
