// Reachability oracle for recovered BASIC fc90c8e, not an emulator/probability proof.
import assert from 'node:assert/strict';
import { pathToFileURL } from 'node:url';
import { sourceAt, extractNumeric, ORIGINAL } from '../../tools/extract-world.mjs';
export function winningRoute() {
  const { objects, exits } = extractNumeric(sourceAt(ORIGINAL));
  const p = [0, ...objects];
  let room = 1, docked = false, fuseMoved = false, echo = false, exposure = 0, match = true;
  const trace = [];
  const names = ['','drone','droid','humanoid','machine','rusty','robot','pump','compass','bomb','memory','processor','tape','book','servo','toolkit','clock','bracelet','matches','screwdriver','blaster','mask','rope','magnet','fuse'];
  const available = id => p[id] === -1 || p[id] === room;
  function command(text) {
    const before = room;
    if (room === 47 && !echo) { assert.equal(text, 'ECHO'); echo = true; trace.push({ command: text, before, room }); return; }
    if (room === 11) { exits[9][0] = 0; exits[11][0] = 0; }
    if (room === 2) docked = true;
    if (room === 50) { exits[21][0] = 53; exits[44][0] = 31; }
    if (p[24] !== 17) fuseMoved = true;
    if (fuseMoved && p[24] === 17) exits[16][3] = 12;
    if (room === 49) exits[47][3] = 49;
    const [verb, noun] = text.toLowerCase().split(' ');
    const id = names.indexOf(noun);
    const enemy = p.findIndex((position, index) => index >= 1 && index <= 6 && position === room);
    if (enemy > 0) assert.equal(text, 'USE BLASTER', `Encounter ${enemy} at ${room}`);
    let describe = false;
    if (['n','s','w','e'].includes(verb)) {
      assert.ok(available(8), 'Compass required: random navigation deliberately not scripted');
      const next = exits[room - 1][['n','s','w','e'].indexOf(verb)];
      assert.ok(next > 0 && next <= 54, `Illegal/fatal ${room} ${text} -> ${next}`);
      room = next; describe = true;
    } else if (verb === 'take') {
      assert.ok(id >= 7 && available(id), `Cannot take ${noun} in ${room}`);
      assert.ok(p.filter(value => value === -1).length < 11, 'Capacity'); p[id] = -1;
    } else if (verb === 'drop') {
      assert.ok(id >= 7 && available(id)); p[id] = room;
    } else if (verb === 'transmat') {
      if (noun) { assert.equal(room, 16); assert.equal(p[17], -1); room = {y:1,b:31,c:41}[noun]; assert.ok(room); }
      else room = 16;
      describe = true;
    } else if (verb === 'use') {
      assert.ok(id >= 18 && available(id));
      if (id === 20) {
        assert.ok(enemy > 0); p[20] = -1; p[enemy] = [3,5].includes(enemy) ? p[enemy] + 10 : 0;
        // Successful hit selected at BASIC 297. No claim about arbitrary seeds.
      } else if (id === 22) { assert.equal(room, 28); p[22] = room; room = 27; describe = true; }
      else if (id === 19) { assert.ok([2,27].includes(room)); p[19] = room; room = room === 2 ? 1 : 54; describe = true; }
      else if (id === 18) {
        assert.ok(match && available(9));
        if (room === 2) exits[1][1] = 1;
        if (room === 51) exits[50][0] = 130;
        if (room > 1) room--;
        if (room === 20) exits[19][2] = 19;
        p[9] = 0; describe = true;
      } else throw Error('Unsupported tool');
    } else if (verb === 'quit') {
      assert.equal(room, 1); assert.ok(docked);
      const score = p.slice(7,18).reduce((sum, location, index) => sum + (location === 1 ? 2 : location === -1 ? 1 : 0) * (index + 1), 0);
      assert.equal(score, 126); trace.push({command:text,before,room,score}); return;
    } else throw Error(`Unsupported ${text}`);
    if (describe && room >= 18) assert.ok(available(21), 'Route never relies on broken oxygen suppression');
    if (describe && room === 50 && p[11] === 50) assert.ok(++exposure <= 1, 'Sonic death');
    trace.push({ command: text, before, room, carrying: p.filter(value => value === -1).length });
  }
  function run(list) { for (const text of list.split(';').map(value => value.trim()).filter(Boolean)) command(text); }
  run('TAKE COMPASS; N; TAKE MATCHES; E; S; E; TAKE BLASTER; N; N; TAKE CLOCK; N; N; N; TAKE MASK; S; USE BLASTER; N; TAKE PUMP; N; E; E; USE BLASTER; W; W; N; S; S; W; TAKE ROPE; E; N; N; E; E; N');
  // Rope lies beyond wiring conduit: return from ledge, collect it, then return.
  run('USE ROPE; TAKE BRACELET; TRANSMAT; USE BLASTER; TRANSMAT Y; DROP PUMP; DROP CLOCK');
  run('TRANSMAT; N; TAKE BOMB; USE MATCHES; W; W; W; W; S; TAKE BOOK; W; N; W; TAKE TOOLKIT; TAKE SCREWDRIVER');
  run('TRANSMAT; TRANSMAT Y; DROP BOOK; DROP TOOLKIT; DROP SCREWDRIVER');
  run('TRANSMAT; TRANSMAT B; E; S; TAKE TAPE; TRANSMAT; TRANSMAT Y; DROP TAPE');
  run('TRANSMAT; TRANSMAT C; TAKE SERVO; S; USE BLASTER; W; S; N; E; ECHO; S; S; N; TAKE PROCESSOR; TAKE MEMORY');
  run('TRANSMAT; TRANSMAT Y; DROP SERVO; DROP PROCESSOR; DROP MEMORY; DROP BRACELET; DROP COMPASS; QUIT');
  assert.equal(p[9], 0);
  assert.equal(exits[9][0], 0);
  assert.equal(exits[11][0], 0);
  assert.equal(exits[44][0], 31);
  assert.equal(exits[47][3], 49);
  return { trace, objects: p.slice(1), exits, docked, echo, exposure, scriptedCombat: 'Every shot succeeds; reachability only, not probability qualification.' };
}
if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) console.log(JSON.stringify(winningRoute(), null, 2));
