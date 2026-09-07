import test from 'node:test';
import assert from 'node:assert/strict';
import {createMachine} from './support/machine.mjs';
test('COM entry, compass, inventory aliases and confirmed CP/M exit',async()=>{
 const m=await createMachine();m.run();
 assert.match(m.output,/Ken Stone and John Hardy/);
 assert.equal(m.byte('ROOM'),1);
 assert.match(m.command(' take compass  '),/Done/);
 assert.equal(m.memory[m.symbols.OBJS+7],255);
 for(const cmd of ['inventory','invent','list','i'])assert.match(m.command(cmd),/compass/i);
 assert.match(m.command('quit')+m.command('n'),/Return to CP\/M/);
 assert.equal(m.exited,false);
 m.command('quit');m.command('y');assert.equal(m.exited,true);
 assert.equal(m.runtime.cpu.sp,m.symbols.STACKTOP-2);
});
test('input overflow cannot execute a truncated command',async()=>{
 const m=await createMachine();m.run();
 assert.match(m.command('take compass'+' '.repeat(80)),/too long/);
 assert.equal(m.memory[m.symbols.OBJS+7],1);
 assert.match(m.command('take compass'),/Done/);
});
test('unknown nouns and empty commands leave persistent state unchanged',async()=>{
 const m=await createMachine();m.run();
 const before=m.memory.slice(m.symbols.STATE,m.symbols.STATEEND);
 for(const cmd of ['','  ','take north','take','drop nobody'])m.command(cmd);
 assert.deepEqual(m.memory.slice(m.symbols.STATE,m.symbols.STATEEND),before);
});
test('overflowed confirmation cannot authorize quitting or restarting',async()=>{
 const m=await createMachine();m.run();m.command('take compass');
 for(const cmd of ['quit','restart']){m.command(cmd);m.command('Y'.repeat(80));assert.equal(m.exited,false);assert.equal(m.memory[m.symbols.OBJS+7],255);}
});
