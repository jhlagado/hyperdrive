import test from 'node:test';
import assert from 'node:assert/strict';
import { createMachine } from './support/machine.mjs';
function snapshot(m) { return Array.from(m.memory.slice(m.symbols.STATE,m.symbols.STATEEND)); }
function crc(bytes) { let crc=65535; for(let i=0;i<128;i++){crc^=(i===8||i===9?0:bytes[i])<<8;for(let bit=0;bit<8;bit++)crc=((crc<<1)^((crc&32768)?0x1021:0))&65535;}return crc; }
function fixcrc(bytes){const c=crc(bytes);bytes[8]=c&255;bytes[9]=c>>8;return bytes;}
async function fresh(options){const m=await createMachine(options);m.run();return m;}
test('named save/load restores state without description side effects',async()=>{
 const m=await fresh();m.command('TAKE COMPASS');const before=snapshot(m);
 assert.match(m.command('SAVE TEST'),/saved/i);const record=m.files.get('TEST.SAV');
 assert.equal(record.length,128);assert.equal(Buffer.from(record.slice(0,4)).toString(),'HYP1');assert.equal(record[6],44);
 m.command('N');assert.notEqual(m.byte('ROOM'),before[0]);
 assert.match(m.command('LOAD TEST'),/loaded/i);assert.deepEqual(snapshot(m),before);assert.equal(m.dma,128);
});
test('default save slot, overwrite cancellation and previous backup',async()=>{
 const m=await fresh();m.command('SAVE');const first=Uint8Array.from(m.files.get('HYPERDRV.SAV'));
 m.command('TAKE COMPASS');m.command('SAVE');m.command('N');assert.deepEqual(m.files.get('HYPERDRV.SAV'),first);
 m.command('SAVE');assert.match(m.command('Y'),/saved/i);assert.deepEqual(m.files.get('HYPERDRV.BAK'),first);assert.equal(m.dma,128);
});
test('every single-bit record corruption is rejected without live publication',async()=>{
 const seed=await fresh();seed.command('SAVE');const valid=seed.files.get('HYPERDRV.SAV');
 for(let bit=0;bit<1024;bit++){
  const bad=Uint8Array.from(valid);bad[bit>>3]^=1<<(bit&7);
  const m=await fresh({files:{'BAD.SAV':bad}});const before=snapshot(m);
  assert.match(m.command('LOAD BAD'),/No valid save/);assert.deepEqual(snapshot(m),before);assert.equal(m.dma,128);
 }
});
test('valid CRC cannot conceal invalid semantic state or reserved bytes',async()=>{
 const seed=await fresh();seed.command('SAVE');const valid=seed.files.get('HYPERDRV.SAV');
 for(const [offset,value] of [[16,0],[16,55],[21,2],[22,255],[28,55],[47,2],[48,2],[49,2],[50,2],[51,130],[52,54],[53,54],[54,54],[55,54],[56,0],[57,54],[58,54],[59,54],[10,1],[60,1],[127,1]]){
  const bad=Uint8Array.from(valid);bad[offset]=value;fixcrc(bad);
  const m=await fresh({files:{'BAD.SAV':bad}});const before=snapshot(m);assert.match(m.command('LOAD BAD'),/No valid save/);assert.deepEqual(snapshot(m),before);
 }
});
test('read-only drive and file cannot be overwritten',async()=>{
 const seed=await fresh();seed.command('SAVE');const valid=seed.files.get('HYPERDRV.SAV');
 for(const option of [{readOnlyDrive:true},{readOnlyFiles:['HYPERDRV.SAV']}]){
  const m=await fresh({...option,files:{'HYPERDRV.SAV':valid}});assert.match(m.command('SAVE'),/Save failed/);assert.deepEqual(m.files.get('HYPERDRV.SAV'),valid);assert.equal(m.dma,128);
 }
});
test('write failure preserves committed save and live state',async()=>{
 const seed=await fresh();seed.command('SAVE');const valid=seed.files.get('HYPERDRV.SAV');
 const m=await fresh({files:{'HYPERDRV.SAV':valid},diskFault:{fn:21,status:1}});const before=snapshot(m);
 m.command('SAVE');assert.match(m.command('Y'),/Save failed/);assert.deepEqual(m.files.get('HYPERDRV.SAV'),valid);assert.deepEqual(snapshot(m),before);assert.equal(m.dma,128);
});
test('CRC-valid zero RNG and over-capacity saves are rejected',async()=>{
 const seed=await fresh();seed.command('SAVE');const valid=seed.files.get('HYPERDRV.SAV');
 for(const mutate of [bytes=>{bytes[19]=bytes[20]=0;},bytes=>bytes.fill(255,28,40)]){
  const bad=Uint8Array.from(valid);mutate(bad);fixcrc(bad);
  const m=await fresh({files:{'BAD.SAV':bad}});const before=snapshot(m);assert.match(m.command('LOAD BAD'),/No valid save/);assert.deepEqual(snapshot(m),before);
 }
});
test('interrupted final rename offers backup recovery without replacing disk files',async()=>{
 const seed=await fresh();seed.command('SAVE');const original=seed.files.get('HYPERDRV.SAV');
 const m=await fresh({files:{'HYPERDRV.SAV':original},diskFault:{fn:23,occurrence:2}});
 m.command('TAKE COMPASS');m.command('SAVE');assert.match(m.command('Y'),/Save failed/);
 assert.deepEqual(m.files.get('HYPERDRV.BAK'),original);assert.ok(m.files.has('HYPERDRV.$$$'));
 assert.match(m.command('LOAD'),/previous backup/);assert.match(m.command('Y'),/loaded/);
 assert.equal(m.memory[m.symbols.OBJS+7],1);assert.deepEqual(m.files.get('HYPERDRV.BAK'),original);assert.equal(m.dma,128);
});
test('first-save temporary candidate can be recovered after rename failure',async()=>{
 const m=await fresh({diskFault:{fn:23}});m.command('TAKE COMPASS');assert.match(m.command('SAVE'),/Save failed/);
 assert.ok(!m.files.has('HYPERDRV.SAV'));assert.ok(m.files.has('HYPERDRV.$$$'));
 m.command('DROP COMPASS');assert.match(m.command('LOAD'),/interrupted save/);assert.match(m.command('Y'),/loaded/);
 assert.equal(m.memory[m.symbols.OBJS+7],255);assert.equal(m.dma,128);
});
test('overflowed confirmation cannot authorize overwriting a save',async()=>{
 const m=await fresh();m.command('SAVE');const before=Uint8Array.from(m.files.get('HYPERDRV.SAV'));
 m.command('TAKE COMPASS');m.command('SAVE');assert.match(m.command('Y'.repeat(80)),/Cancelled/);
 assert.deepEqual(m.files.get('HYPERDRV.SAV'),before);
});
