// SPOILERS: complete winning transcript with the native deterministic RNG.
import assert from 'node:assert/strict';
import {winningRoute} from './original-route.mjs';
export function proveFullRoute(machine){
 machine.run();const checkpoints=[];
 function command(text){
  const before=machine.metrics;const output=machine.command(text);
  assert.doesNotMatch(output,/Another adventure\?|don't understand/,text);
  checkpoints.push({command:text,room:machine.byte('ROOM'),state:Array.from(machine.memory.slice(machine.symbols.STATE,machine.symbols.STATEEND)),cycles:machine.metrics.cycles-before.cycles,output});
 }
 for(const step of winningRoute().trace){
  if(step.command==='QUIT')break;
  command(step.command);
  if(step.command==='USE BLASTER')for(let retry=0;retry<17&&machine.memory.slice(machine.symbols.OBJS,machine.symbols.OBJS+6).includes(machine.byte('ROOM'));retry++)command('USE BLASTER');
  assert.equal(machine.byte('ROOM'),step.room,step.command);
 }
 assert.match(machine.command('SCORE'),/Salvage score: 126/);
 return {checkpoints,score:126};
}
