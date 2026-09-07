import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { ORIGINAL, PROSE, ROOT, sourceAt, extractNumeric, extractRooms, extractObjectNames } from '../tools/extract-world.mjs';
const original = sourceAt(ORIGINAL);
const modern = sourceAt(PROSE);
test('recovered world has unchanged complete numeric data', () => {
  const data = extractNumeric(original);
  assert.deepEqual(data, extractNumeric(modern));
  assert.equal(data.exits.length, 54);
  assert.deepEqual(data.objects, [5,36,42,16,52,25,37,1,26,50,50,33,21,41,19,9,27,2,19,7,12,40,34,17]);
  assert.deepEqual(data.exits[0], [2,0,0,0]);
  assert.deepEqual(data.exits[16], [0,0,0,0]);
  assert.deepEqual(data.exits[27], [129,0,0,0]);
  assert.deepEqual(data.exits[47], [47,49,45,0]);
  assert.deepEqual(data.exits[53], [51,27,0,0]);
});
test('malformed and truncated numeric input is rejected', () => {
  assert.throws(() => extractNumeric(original.replace('408 DATA5', '408 DATA999')), /object location/);
  assert.throws(() => extractNumeric(original.replace('409 DATA2', '409 DATA127')), /exit destination/);
  assert.throws(() => extractNumeric(original.replace('408 DATA5,', '408 DATA')), /240/);
});
test('room assignments preserve concatenation and overriding BASIC order', () => {
  const rooms = extractRooms(modern);
  assert.equal(rooms.length, 54);
  assert.match(rooms[0], /giant space wreck/);
  assert.match(rooms[5], /ripped the cables/);
  assert.doesNotMatch(rooms[5], /pool of oil/);
  assert.match(rooms[6], /pool of oil/);
  assert.match(rooms[10], /used to service/);
  assert.equal(rooms[49], 'You have penetrated the computer complex.');
  assert.match(rooms[53], /body on the floor/);
  assert.equal(rooms[25], 'You are in a corridor junction.');
  assert.ok(rooms.every(value => /^[\x20-\x7e]+$/.test(value)));
});
test('object descriptions retain original useful distinctions', () => {
  const names = extractObjectNames(modern);
  assert.equal(names.length, 24);
  assert.equal(names[0], 'service drone');
  assert.equal(names[4], 'rusty drone');
  assert.equal(names[16], 'transmat bracelet');
  assert.equal(names[18], 'sonic screwdriver');
  assert.equal(names[21], 'thin and tatty rope');
});
test('checked-in native assembly matches extraction and editor size limits', () => {
  const world = readFileSync(`${ROOT}/cpm/world.asm`, 'utf8');
  const text = readFileSync(`${ROOT}/cpm/roomtext.asm`, 'utf8');
  assert.equal((world.match(/DW HR/g) || []).length, 54);
  assert.equal((world.match(/DW HO/g) || []).length, 24);
  for (const file of [world, text]) assert.ok(file.split('\n').length <= 500);
  const blocks = text.split(/HR\d+:\n/).slice(1);
  const actual = blocks.map(block => [...block.matchAll(/DB "([^"]*)"/g)].map(match => match[1]).join(''));
  assert.deepEqual(actual, extractRooms(modern));
});
test('all emitted native locations and exits match the recovered numeric world',async()=>{
 const {createMachine}=await import('./support/machine.mjs');const m=await createMachine();m.run();
 const expected=extractNumeric(original);
 assert.deepEqual(Array.from(m.memory.slice(m.symbols.EXITS,m.symbols.EXITS+216)),expected.exits.flat());
 assert.deepEqual(Array.from(m.memory.slice(m.symbols.OBJS,m.symbols.OBJS+24)),expected.objects);
});
