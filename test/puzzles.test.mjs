// SPOILERS: isolated optional puzzle and ending boundaries complement the full route.
import test from 'node:test';
import assert from 'node:assert/strict';
import {createMachine} from './support/machine.mjs';
async function room(number){const m=await createMachine();m.run();m.command('TAKE COMPASS');m.memory[m.symbols.ROOM]=number;return m;}
const object=(m,id,value)=>m.memory[m.symbols.OBJS+id-1]=value;
test('escape pod requires fuse removal, replacement and a subsequent action',async()=>{
 const m=await room(17);assert.equal(m.memory[m.symbols.EXITS+67],0);
 m.command('TAKE FUSE');assert.equal(m.memory[m.symbols.EXITS+67],0);
 m.command('DROP FUSE');assert.equal(m.byte('FUTAKEN'),1);assert.equal(m.memory[m.symbols.EXITS+67],0);
 m.command('E');assert.equal(m.byte('ROOM'),12);assert.equal(m.memory[m.symbols.EXITS+67],12);
});
test('sonic screwdriver opens each original door and remains in its source room',async()=>{
 for(const [from,to] of [[2,1],[27,54]]){
  const m=await room(from);object(m,19,255);assert.match(m.command('USE SCREWDRIVER'),/open the door/);
  assert.equal(m.byte('ROOM'),to);assert.equal(m.memory[m.symbols.OBJS+18],from);
 }
 const m=await room(19);assert.match(m.command('USE SCREWDRIVER'),/won't open/);assert.equal(m.byte('ROOM'),19);
});
test('bomb opens docking, iron-door and workshop branches and removes itself',async()=>{
 for(const [from,to,offset,destination] of [[2,1,5,1],[51,50,200,130],[21,20,78,19]]){
  const m=await room(from);object(m,18,255);object(m,9,255);
  assert.match(m.command('USE MATCHES'),/BOOM/);assert.equal(m.byte('ROOM'),to);
  assert.equal(m.memory[m.symbols.EXITS+offset],destination);assert.equal(m.memory[m.symbols.OBJS+8],0);
  const before=m.memory.slice(m.symbols.STATE,m.symbols.STATEEND);
  assert.match(m.command('SAVE PUZZLE'),/saved/);m.command('DROP COMPASS');
  assert.match(m.command('LOAD PUZZLE'),/loaded/);assert.deepEqual(m.memory.slice(m.symbols.STATE,m.symbols.STATEEND),before);
 }
});
test('an extinguished match cannot later detonate a bomb',async()=>{
 const m=await room(2);object(m,18,255);m.command('USE MATCHES');assert.equal(m.byte('MATCHLIT'),0);
 object(m,9,255);assert.match(m.command('USE MATCHES'),/match is out/);
 assert.equal(m.byte('ROOM'),2);assert.equal(m.memory[m.symbols.OBJS+8],255);
});
test('transmat retains bracelet restriction and all three destinations',async()=>{
 const m=await room(1);object(m,4,0);
 m.command('TRANSMAT Y');assert.equal(m.byte('ROOM'),16);
 m.command('TRANSMAT Y');assert.equal(m.byte('ROOM'),16);
 object(m,17,255);assert.match(m.command('READ'),/YACHT, BRIDGE, COMPUTER/);
 for(const [name,destination] of [['YACHT',1],['BRIDGE',31],['COMPUTER',41]]){
  m.memory[m.symbols.ROOM]=16;m.command('TRANSMAT '+name);assert.equal(m.byte('ROOM'),destination);
 }
 m.memory[m.symbols.ROOM]=16;const before=m.memory.slice(m.symbols.STATE,m.symbols.STATEEND);
 assert.match(m.command('TRANSMAT UNKNOWN'),/don't understand/);
 assert.deepEqual(m.memory.slice(m.symbols.STATE,m.symbols.STATEEND),before);
});
test('ordinary pickup rejects the twelfth object without mutation',async()=>{
 const m=await room(1);for(let id=7;id<=17;id++)object(m,id,255);object(m,18,1);
 const before=m.memory.slice(m.symbols.STATE,m.symbols.STATEEND);
 assert.match(m.command('TAKE MATCHES'),/eleven/);assert.deepEqual(m.memory.slice(m.symbols.STATE,m.symbols.STATEEND),before);
});
test('all score thresholds and the original unhandled132 ending are defined',async()=>{
 for(const [score,expected] of [[0,/overloads and explodes/],[79,/overloads and explodes/],[80,/fails to engage/],[109,/fails to engage/],[110,/half speed/],[125,/half speed/],[126,/Congratulations/],[132,/Congratulations/]]){
  const m=await room(1);m.memory[m.symbols.DOCKED]=1;let remaining=score;
  for(let id=17;id>=7;id--){const weight=id-6;let value=0;if(remaining>=2*weight){value=1;remaining-=2*weight;}else if(remaining>=weight){value=255;remaining-=weight;}object(m,id,value);}
  assert.equal(remaining,0);assert.match(m.command('SCORE'),new RegExp(`Salvage score: ${score}\\.`));
  m.command('FINISH');assert.match(m.command('Y'),expected);assert.equal(m.exited,false);
  m.command('N');assert.equal(m.exited,true);
 }
});
test('ordinary hostile actions kill, while the rusty drone abducts within bounds',async()=>{
 const m=await room(5);m.command('INVENTORY');assert.equal(m.exited,false);
 assert.match(m.command('E'),/hostile machine[\s\S]*Another adventure/);m.command('N');assert.equal(m.exited,true);
 const drone=await room(52);const sp=drone.runtime.cpu.sp;
 assert.match(drone.command('E'),/rusty drone picks you up/);assert.equal(drone.byte('ROOM'),33);
 assert.equal(drone.memory[drone.symbols.OBJS+4],0);assert.equal(drone.runtime.cpu.sp,sp);
});
test('all three special exit markers produce their own terminal outcome',async()=>{
 for(const [from,offset,marker,message] of [[5,16,128,/plexiglass cracks/],[28,108,129,/fall down the shaft/],[51,200,130,/outer door opens/]]){
  const m=await room(from);m.memory.fill(0,m.symbols.OBJS,m.symbols.OBJS+6);m.memory[m.symbols.EXITS+offset]=marker;
  assert.match(m.command('N'),message);assert.equal(m.byte('ROOM'),from);
  m.command('N');assert.equal(m.exited,true);
 }
});
