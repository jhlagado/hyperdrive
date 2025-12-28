1 rem copy right micro parts, 1982
2 print chr$(14): rem dist 10
3 clr
4 ti$ = "000000"
5 fu = 0
6 j = 0
7 gosub 419
8 x = rnd( - ti)
9 r = 0
10 a = 1
11 can = 1
12 mat = 1
13 gosub 385
14 print ".": rem poke 36879, 25: poke 36869, 192
15 print "INSTRUCTIONS? Y/N"
16 input y$: a$ = y$: gosub 900: y$ = a$
17 if mid$(y$, 1, 1) = "Y" then gosub 456
18 print ". "
19 f = 0
20 u = 0
21 if r = 1 then 136
22 if a < 18 or can = 1 and (p(21) = a or p(21) = - 1) then 25
23 print "YOU CANT BREATHE!! THE AIR IS POISONED BY FUMES."
24 goto 136
25 rem print a
26 g$ = "YOU ARE IN A CORRIDOR JUNCTION."
27 if a = 1 then g$ = "YOU ARE IN YOUR SPACE YACHT, WHICH IS DOCKED WITH THE GIANT SPACE WRE"
28 if a = 1 then g$ = g$ + "CK. TO THE NORTH IS AN AIR-LOCK. IT IS OPEN."
29 if a = 2 then g$ = "YOU HAVE ENTERED THE DOCKING BAY OF THE CRUISER. THE AREA IS DIMLY L"
30 if a = 2 then g$ = g$ + "IT BY LIGHT FROM DISTANT STARS. THE AIR-LOCK HAS CLOSED AND THE EL"
31 if a = 2 then g$ = g$ + "ECTRONIC LOCK HAS ENGAGED. A PASSAGE LEADS EAST."
32 if a = 3 or a = 4 then g$ = "SEVERAL CORRIDORS INTERSECT HERE. "
33 if a = 3 then g$ = g$ + "STREWN AROUND THE FLOOR ARE PIECES OF BROKEN MACHINERY. THE CORRID"
34 if a = 3 then g$ = g$ + "OR IS LIT BY THE EMERGENCY LAMPS, FOREVER DRAWING THEIR POWER FROM "
35 if a = 3 then g$ = g$ + "THE SOLAR STACKS."
36 if a = 4 then g$ = g$ + "SOME CABLES HAVE BEEN SEVERED AND ARE HANGING, DANGEROUSLY, FROM "
37 if a = 4 then g$ = g$ + "THE CEILING."
38 if a = 5 then g$ = "YOU ARE IN A SMALL OBSERVATION PORT. THE NORTH AND WEST WALLS ARE MAD"
39 if a = 5 then g$ = g$ + "E OF A GLASS-LIKE MATERIAL. IT IS SHOWING SIGNS OF STRESS."
40 if a = 6 then g$ = "YOU ARE IN A SERVICE TUNNEL. THERE IS A POOL OF OIL ON THE FLOOR."
41 if a = 8 then g$ = "THIS IS A MAIN CORRIDOR JUNCTION."
42 if a = 6 then g$ = "YOU ARE IN A SERVICE TUNNEL. SOMEONE HAS RIPPED THE CABLES AND EQUIPMENT"
43 if a = 6 then g$ = g$ + " FROM THE WALLS AND MANGLED THEM."
44 if a = 7 then g$ = "YOU ARE IN A SERVICE TUNNEL. A POOL OF OIL IS ON THE FLOOR."
45 if a = 9 then g$ = "YOU ARE IN AN OBSERVATION PORT. THROUGH THE EASTERN WALL YOU CAN SEE "
46 if a = 9 then g$ = g$ + "THE DISTANT EMERY NEBULA."
47 if a = 10 then g$ = "NOW YOU ARE IN AN ACCESS CHAMBER. TO THE NORTH IS A FLIMSY LADDER "
48 if a = 10 then g$ = g$ + "LEADING UPWARDS."
49 if a = 11 then g$ = "YOU ARE ON THE LADDER IN A PLEXIGLASS OBSERVATION TUBE, WHICH IS USE"
50 if a = 11 then g$ = g$ + "D TO SERVICE THE STABILIZER RETROS."
51 if a = 12 then g$ = "YOU ARE STANDING AT THE TOP OF A LADDER. A PASSAGE LEADS SOUTH."
52 if a = 13 then g$ = "EQUIPMENT LINES THE WALLS. THIS ROOM IS THE RELAY STATION BETWEEN THE "
53 if a = 13 then g$ = g$ + "UPPER AND LOWER DECKS OF THE CRUISER."
54 if a = 14 then g$ = "YOU ARE IN A DARK ROOM. TO THE WEST IS A ROOM MARKED 'TRANSMAT'."
55 if a = 15 then g$ = "YOU ARE IN A LONG, DIMLY LIT PASSAGE. THE AIR SMELLS OF OZONE."
56 if a = 16 then g$ = ". YOU ARE STANDING IN A SMALL METAL BAY. IN FRONT OF YOU ARE SEVERAL "
57 if a = 16 then g$ = g$ + "COMPUTER BANKS ONE OF THEM BEARING THE WORD . TRANSMAT."
58 if a = 17 then g$ = "THIS IS AN ESCAPE POD. TO ACTIVATE IT YOU NEED TO KNOW A SECRET CODE"
59 if a = 18 then g$ = "BEFORE YOU LOOMS ONE OF THE CRUISER'S WARP ENGINES. IT IS UNDAMAGED."
60 if a = 19 then g$ = "YOU ARE IN THE MAINTENANCE WORKSHOP."
61 if a = 20 or a = 34 then g$ = "THE WARP ENGINE STRETCHES AWAY TO THE SOUTH."
62 if a > 20 and a < 26 then g$ = "YOU ARE IN A LONG, DARK CORRIDOR."
63 if a = 27 then g$ = "YOU ARE IN A SMALL ROOM. THERE IS NO WAY OUT."
64 if a = 28 then g$ = "YOU ARE ON A LEDGE OVERLOOKING A DEEP SHAFT."
65 if a = 30 then g$ = "YOU ARE ON THE BRIDGE OF THE CRUISER."
66 if a = 31 then g$ = "YOU ARE ON THE BRIDGE. BEFORE YOU IS A LARGE CHART."
67 if a = 32 then g$ = "THE MANUAL CONTROLS OF THE CRUISER LINE THE WALLS."
68 if a = 33 then g$ = g$ + ". BEFORE YOU IS A SMALL COMPUTER TERMINAL LABELLED "
69 if a = 33 then g$ = g$ + ". FLIGHT COMPUTER. IT SEEMS TOO SMALL FOR SUCH A TASK. SOME OF ITS"
70 if a = 33 then g$ = g$ + " CIRCUIT CARDS ARE MISSING."
71 if a = 35 then g$ = "BEFORE YOU LOOMS A WARP ENGINE. IT HAS BEEN BURNT OUT."
72 if a = 37 then g$ = "HERE THE MAIN CORRIDOR ENDS. FROM IT BRANCH THREE ACCESS TUNNELS."
73 if a = 38 then g$ = ".. YOU ARE CRAWLING THROUGH A LONG, DARK WIRING CONDUIT. THE SURFACES "
74 if a = 38 then g$ = g$ + " ARE COVERED IN SHARP RIVETS THAT MAKE CRAWLING AGONIZING."
75 if a = 39 then g$ = "BEFORE YOU LOOMS ONE OF THE WARP ENGINES. IT STRETCHES AWAY TO THE "
76 if a = 39 then g$ = g$ + "NORTH."
77 if a = 40 then g$ = "YOU ARE IN A LONG EAST-WEST ACCESS TUNNEL."
78 if a = 42 then g$ = g$ + " YOU ARE WALKING IN CIRCLES."
79 if a = 43 then g$ = "YOU ARE AT ANOTHER CORRIDOR JUNCTION."
80 if a = 45 then g$ = "THE CORRIDORS ARE CHANGING BEFORE YOUR VERY EYES!"
81 if a = 46 then g$ = "YOU ARE IN AN ENDLESS PASSAGE. THE SILENCE IS TERRIFYING..."
82 if a = 47 then g$ = "YOU ARE STANDING IN AN ACOUSTICALLY SEALED ROOM."
83 if a = 47 then gosub 476
84 if a = 48 then g$ = "BEFORE YOU IS AN ELECTRONIC MINE FIELD... ONE FALSE STEP WILL BE FATAL."
85 if a = 49 then g$ = "YOU SURVIVED THE MINE FIELD AND HAVE STUMBLED INTO A DIMENSIONAL WAR"
86 if a = 49 then g$ = g$ + "P. NOTHING APPEARS TO BE WHERE IT IS. A PASSAGE LEADS SOUTH."
87 if a = 50 then g$ = "YOU HAVE PENETRATED THE COMPUTER COMPLEX. "
88 if a = 50 and p(11) = 50 then rem poke 36878, 15: poke 36876, 210: poke 36877, 254
89 if a = 50 and p(11) = 50 then g$ = g$ + "THE SONIC PROTECTION SYSTEM IS CONFUSING YOUR THOUGHTS"
90 if a = 50 and p(11) = 50 then tr = tr + 1
91 if tr > 1 then print "YOUR BRAINS HAVE BEEN SCRAMBLED BY PROLONGED EXPOSURE TO SONIC"
92 if tr > 1 then print "VIBRATIONS. YOU ALMOST MADE IT!" : goto 335
93 if a = 51 then g$ = "THERE IS A HEAVY IRON DOOR TO THE NORTH."
94 if a = 53 then g$ = ". YOU ARE IN A SMALL OBSERVATION BUBBLE. FROM HERE YOU CAN SEE YOUR YAC"
95 if a = 53 then g$ = g$ + "HT IN THE DOCKING BAY. THE DAMAGE TO THE YACHT APPEARS TO BE MINOR"
96 if a = 52 or a = 54 then g$ = "YOU ARE IN A LONG DIMLY LIT PASSAGE. "
97 if a = 54 then g$ = g$ + "THERE IS A BODY ON THE FLOOR. IT HAS BEEN SHOT."
98 x = 1
99 if g$ = "" then g$ = " "
100 h = x + 20
101 if h > len(g$) then h = len(g$)
102 if mid$(g$, h, 1) = " " or h = len(g$) then 105
103 h = h - 1
104 goto 102
105 print mid$(g$, x, h - x + 1)
106 if h = len(g$) then 109
107 x = h + 1
108 goto 100
109 if a = 10 and c(a, 1) = 0 then print "IT IS TOO DAMAGED TO CLIMB"
110 if a = 12 and c(a, 1) = 0 then print "THE LADDER HAS BROKEN FREE AND COLLAPSED."
111 rem if a = 48 and c(a, 4) = 128 then print "."
112 if u > 200 then print "YOUR OXYGEN IS RUNNING OUT."
113 if u < 230 then 116
114 can = 0
115 print "IN FACT YOU HAVE RUN OUT!"
116 v = 0
117 for l = 7 to 24
118 if p(l) = a then v = v + 1
119 next l
120 if v = 0 then 125
121 print "YOU CAN ALSO SEE:"
122 for l = 7 to 24
123 if p(l) = a then gosub 425
124 next l
125 v = 0
126 for l = 1 to 6
127 if p(l) = a then v = v + 1
128 next l
129 if v = 0 then 135
130 print
131 print "NEARBY THERE LURKS"
132 for l = 1 to 6
133 if p(l) = a then gosub 425
134 next l
135 r = 1
136 if a <> 50 or p(11) <> 50 then rem poke 36878, 0: poke 36877, 0: poke 36876, 0
137 print: print "OK... WHAT NOW?"
138 n(1) = 0
139 n(2) = 0
140 input a$: gosub 900
141 if a$ = "N" then n(1) = 1: goto 175
142 if a$ = "S" then n(1) = 2: goto 175
143 if a$ = "W" then n(1) = 3: goto 175
144 if a$ = "E" then n(1) = 4: goto 175
145 if a$ = "UP" then n(1) = 1: goto 175
146 if a$ = "DOWN" then n(1) = 1: goto 175
147 a$ = a$ + " ": gosub 850: gosub 870
148 rem n(1) = 0
149 rem n(2) = 0
150 print: print: print
151 print
152 u = u + 1
153 t = 1
154 m = 0
155 m = m + 1
156 restore
157 for x = 1 to 55
158 read n$: gosub 880: if x = 31 then gosub 860
159 if m + len(n$) > len(a$) then 171
160 if mid$(a$, m, len(n$)) = n$ then 163
161 next x
162 goto 155
163 n(t) = x
164 for z = m to len(a$)
165 if mid$(a$, z, 1) = " " then 167
166 next z
167 t = t + 1
168 m = z
169 if t > 2 then 171
170 goto 155
171 if t <> 1 then 174
172 print "I DON'T UNDERSTAND THAT!"
173 goto 21
174 n(1) = n(1) - 24
175 rem print n(1);n(2)
176 if n(1) = 14 or n(1) = 13 then n(1) = 12
177 if n(1) < 1 then 172
178 if a = 11 then c(10, 1) = 0
179 if a = 11 then c(12, 1) = 0
180 rem closesecret rooms
181 if a = 2 then j = 1
182 if a = 50 then c(22, 1) = 53
183 if a = 50 then c(45, 1) = 31
184 if p(24) <> 17 then fu = 1
185 if fu = 1 and p(24) = 17 then c(17, 4) = 12
186 if a = 49 then c(48, 4) = 49
187 if n(1) = 27 then n(1) = 10
188 if n(1) = 26 then 486
189 if n(1) = 15 then n(1) = 16
190 if n(1) > 27 then n(1) = n(1) - 27
191 if n(1) < 15 then 195
192 if n(1) > 16 then print "HOW?"
193 if n(1) < 17 then print "HOW DESTRUCTIVE!!"
194 goto 138
195 rem
196 if n(1) < 7 or n(1) > 9 then 211
197 on n(1) - 6 goto 198, 200, 210
198 r = 0
199 goto 21
200 print "YOU ARE CARRYING "
201 v = 0
202 for l = 7 to 24
203 if p(l) = - 1 then v = v + 1
204 next l
205 if v = 0 then print "NOTHING." : goto 209
206 for l = 7 to 24
207 if p(l) = - 1 then gosub 425
208 next l
209 goto 21
210 goto 335
211 for z = 1 to 6
212 if p(z) = a then 215
213 next z
214 goto 228
215 if n(2) = 20 then 228
216 if z = 5 then goto 223
217 restore
218 for mo = 1 to z
219 read k$
220 next mo
221 print "AUUUUGH... YOU'VE JUST BEEN KILLED BY A " : print k$
222 goto 335
223 print "THE RUSTY DRONE PICKED YOU UP AND CARRIED YOU TO ANOTHER PLACE."
224 a = 33
225 r = 0
226 p(5) = p(5) + 7
227 goto 21
228 if n(1) > 4 then 242
229 if p(8) = - 1 or p(8) = a then 232
230 n(1) = int(rnd(1) * 4 + 1)
231 rem
232 b = c(a, n(1))
233 if b = 0 then print "YOU CANT GO THAT WAY."
234 if b = 128 then print "THE PLEXIGLASS CRACKS THEN SHATTERS. YOU ARE SUCKED OUT INTO SPACE."
235 if b = 129 then print "YOU FALL DOWN THE SHAFT AND ARE KILLED."
236 if b = 130 then print "YOU STEP INTO THE AIR-LOCK. THE SECOND AIR-LOCK DOOR OPENS AND"
237 if b = 130 then print "YOU ARE SUCKED OUT INTO SPACE."
238 if b > 127 then 335
239 if b > 0 then a = b
240 r = 0
241 goto 21
242 if n(1) <> 5 then 257
243 if n(1) <> 5 then 257
244 r = 0
245 if a = 16 and p(17) = - 1 then 250
246 a = 16
247 print "SUDDENLY.. THE ROOM VANISHES FROM BEFORE YOU."
248 for de = 1 to 1000: next de
249 goto 21
250 print "ENTER DESTINATION CODE"
251 input co$: a$ = co$: gosub 900: co$ = a$
252 if left$(co$, 1) = "Y" then a = 1: goto 247
253 if left$(co$, 1) = "B" then a = 31: goto 247
254 if left$(co$, 1) = "C" then a = 41: goto 247
255 goto 21
256 goto 247
257 if n(1) <> 6 then 260
258 rem
259 goto 21
260 if n(2) < 1 then 172
261 if p(n(2)) = - 1 or p(n(2)) = a then 264
262 print "WHERE? I CAN'T SEE IT."
263 goto 21
264 on n(1) - 9 goto 265, 274, 276
265 n = 1
266 for x = 1 to 24
267 if p(x) = - 1 then n = n + 1
268 next x
269 if n < 12 then 272
270 print "YOU ARE CARRYING TOO MANY OBJECTS."
271 goto 21
272 p(n(2)) = - 1
273 goto 136
274 p(n(2)) = a
275 goto 136
276 if n(2) > 17 and n(2) < 23 then 279
277 print "NOTHING HAPPENS!"
278 goto 136
279 on n(2) - 17 goto 311, 280, 289, 277, 326
280 if a = 2 or a = 27 then 283
281 print "IT WON'T OPEN"
282 goto 21
283 print "YOU OPENED THE DOOR."
284 p(n(2)) = a
285 r = 0
286 if a = 2 then a = 1
287 if a = 27 then a = 54
288 goto 21
289 if z < 7 then 292
290 print "THERE'S NOTHING TO DESTROY!"
291 goto 21
292 f = f + 1
293 rem * * * * modificati on was 15
294 if rnd(1) * 7 + 10 > f then 297
295 print "YOU SHOOT AT IT AND MISS. THE MACHINE DEALS YOU A FATAL WOUND."
296 goto 335
297 if rnd(1) < .38 then 306
298 l = int(rnd(1) * 4)
299 if z = 5 then goto 223
300 if l = 0 then print "YOU FIRE AT THE MACHINE BUT IT MOVES ASIDE."
301 if l = 1 then print "THE MACHINE IS DAMAGED BUT IT ATTACKS AGAIN."
302 if l = 2 then print "THE SHOT DAMAGES THE MACHINE SLIGHTLY. IT ATTACKS AGAIN."
303 if l = 3 then print "YOU MISSED AND IT FIGHTS BACK WITH A LOGICAL CALMNESS THAT"
304 if l = 3 then print "ALARMS YOU."
305 goto 21
306 print "THE SHOT IS WELL AIMED AND THE MACHINE SCUTTLES AWAY, BADLY DAMAGED."
307 p(n(2)) = - 1
308 if z = 3 or z = 5 then p(z) = p(z) + 10
309 if p(z) = a then p(z) = 0
310 goto 21
311 if p(9) = - 1 or p(9) = a then 315
312 print "THAT WON'T BURN, DUMMY!! IN FACT, THE MATCH WENT OUT."
313 mat = 0
314 goto 21
315 if mat = 1 then 318
316 print "BUT THE MATCH IS OUT, STUPID!!"
317 goto 21
318 print "THE FUSE BURNT AWAY AND... BOOM!!... THE EXPLOSION BLEW YOU OUT OF THE WAY!!"
319 r = 0
320 if a = 2 then c(a, 2) = 1
321 if a = 51 then c(a, 1) = 130
322 if a > 1 then a = a - 1
323 if a = 20 then c(20, 3) = 19
324 p(9) = 0
325 goto 21
326 if a = 28 then 329
327 print "IT'S TOO DANGEROUS!!!"
328 goto 21
329 print "YOU DESCEND THE ROPE, BUT IT DROPS 10 FEET SHORT OF THE FLOOR."
330 print "YOU JUMP THE REST OF THE WAY."
331 r = 0
332 p(n(2)) = a
333 a = 27
334 goto 21
335 s = 0
336 for x = 7 to 17
337 if p(x) = - 1 then s = s + x - 6
338 if p(x) = 1 then s = s + (x - 6) * 2
339 next x
340 print: print: print: print
341 print "YOU GOT A SCORE OF "
342 print s;
344 print "IN" ;u; " MOVES."
345 if a > 1 or j < 1 then 372
346 print "YOU SPEND THE NEXT DAY REPAIRING YOUR YACHT WITH THE EQUIPMENT"
347 print "THAT YOU FOUND ON THE WRECK. "
348 print "HOPING THAT YOU HAVE BEEN SUCCESSFUL IN REPAIRING THE YACHT "
349 print "YOU MANOEUVRE THE YACHT INTO SPACE AND ENGAGE THE HYPERDRIVE... "
350 for de = 1 to 4000: next de
351 if s > 79 then 362
352 if s < 80 then print "THE YACHT BEGINS TO MOVE FORWARD, THEN SUDDENLY THE DRIVE "
353 if s < 80 then print "OVERLOADS AND EXPLODES BLOWING YOU INTO COSMIC DUST"
354 rem poke 36878, 15
355 for x = 255 to 128 step - 1
356 rem poke 36877, x
357 for de = 1 to 20: next de
358 rem poke 36874, x
359 next x
360 for x = 15 to 0 step - 1 : for y = 1 to 20: next y: next x: rem poke 36878, x
361 goto 372
362 if s < 110 then print "THE HYPERDRIVE REFUSES TO ENGAGE, LEAVING YOU TO DRIFT IN SPACE."
363 if s < 110 then print "PERHAPS SOMEONE WILL HEAR YOUR MAYDAY" : goto 372
364 if s < 126 then print "THE HYPERDRIVE ENGAGES AND THE YACHT MOVES SLOWLY OFF INTO SPACE."
365 if s < 126 then print "YOU FIND THAT YOU ARE LIMITED TO HALF SPEED. IT MAY TAKE A WHILE"
366 if s < 126 then print "BUT YOU WILL GET HOME!! " : goto 372
367 if s = 126 then print "THE ALIEN HYPERDRIVE IS SUPERIOR TO THE OLD HYPERDRIVE."
368 for x = 1 to 2000: next x
369 if s = 126 then print ". YOU ARE ABLE TO ACHIEVE SPEEDS GREATER THAN EVER BEFORE!!"
370 if s = 126 then print "IF YOU SELL THE DRIVE YOU WILL BE ONE OF THE RICHEST MEN ON EARTH."
371 if s = 126 then print "CONGRATULATIONS!! YOU MADE IT."
372 rem
373 print "ANOTHER ADVENTURE?"
374 input a$: gosub 900
375 if left$ (a$, 1) = "Y" then 3
376 print "YES OR NO - THIS IS YOUR LAST CHANCE!!"
377 input w$: a$ = w$: gosub 900: w$ = a$
378 if left$ (w$, 1) = "Y" then 3
379 print " YOU HAVE BEEN PLAYING HYPERDRIVE FOR"
380 print left$(ti$, 2); " HOURS " ;mid$(ti$, 3, 2); " MINUTES!!"
381 for de = 1 to 5000: next de
382 rem poke 36879, 8
383 end
384 rem
385 restore
386 for x = 1 to 56
387 read b$
388 next x
389 dim p(24)
390 for x = 1 to 24
391 read p(x)
392 next x
393 dim c(54, 4)
394 for x = 1 to 54
395 for y = 1 to 4
396 read c(x, y)
397 next y
398 next x
399 return
400 data DRONE, 'DROID, HUMANOID, MACHINE, DRONE, ROBOT, PUMP
401 data COMPASS, BOMB, MEMORY, PROCESSOR, TAPE
402 data BOOK, SERVO, TOOL KIT, CLOCK, BRACELET, MATCHES, SCREWDRIVER
403 data BLASTER, MASK, ROPE, MAGNET, FUSE, NORTH
404 data SOUTH
405 data WEST, EAST, TRANSMAT, APE, LOOK, LIST, QUIT, TAKE
406 data DROP, USE, USING, WITH, CUT, BREAK, UP
407 data UNLOCK, OPEN, KILL, SHOOT, LIGHT, BURN, DOWN, JUMP, READ, GET, Z , Z , Z , Z , HELP
408 data 5, 36, 42, 16, 52, 25, 37, 1, 26, 50, 50, 33, 21, 41, 19, 9, 27, 2, 19, 7, 12, 40, 34, 17
409 data 2, 0, 0, 0, 128, 0, 128, 3, 5, 6, 2, 4, 3, 0, 3, 8
410 data 128, 4, 128, 9, 0, 0, 3, 7, 8, 0, 6, 0, 9, 7, 10, 9, 10, 8, 5, 128, 11
411 data 0, 5, 9, 12, 10, 128, 128, 11, 36, 17, 17, 15, 14, 0, 0, 13, 0, 16, 51, 13, 31, 26, 26, 26, 0, 29, 14, 0
412 data 0, 0, 0, 0, 20, 19, 0, 0, 0, 0, 18, 18, 39, 0, 21, 22, 0, 20, 0, 53, 21, 0, 23, 0, 0, 22, 36, 0, 0, 36
413 data 25, 28, 0, 24, 35, 0, 26, 15, 15, 0, 0, 0, 0, 129, 0, 0, 0, 0, 52, 0, 16, 0, 0, 128, 31, 0, 15, 30, 32
414 data 0, 33, 0, 31, 32, 0, 0, 128, 35, 39, 0, 0, 0, 34, 25, 0, 37, 12, 23, 24, 36, 38, 38, 38
415 data 37, 39, 39, 39, 37, 0, 40, 40
416 data 0, 0, 39, 39, 46, 42, 41, 41, 41, 41, 43, 43, 41, 44, 42, 42, 45, 42, 46, 46, 46, 44, 46, 47
417 data 41, 41, 42, 42, 0, 48, 45, 0, 47, 49, 45, 0, 50, 0, 0, 48, 49, 0, 0, 0, 0, 54, 14, 0, 29, 53, 0, 0
418 data 0, 22, 0, 0, 51, 27, 0, 0
419 rem poke 36879, 78
420 rem poke 36869, 194
421 print "."
422 print "HYPERDRIVE"
423 print "BY KEN STONE AND JOHN HARDY"
424 return
425 restore
426 for k = 1 to l
427 read h$
428 next k
429 print "A" ;
430 if l = 5 then print " RUSTY " ;
431 if l = 7 then print " FUEL " ;
432 if l = 24 then print " SMALL " ;
433 if l = 4 then print " SECURITY " ;
434 if l = 1 then print " SERVICE " ;
435 if l = 3 then print " BATTERED " ;
436 if l = 13 then print "N INTERESTING " ;
437 if l = 14 then print " STABILIZER " ;
438 if l = 18 then print " BOX OF " ;
439 if l = 11 then print " COMPUTER " ;
440 if l = 17 then print " TRANSMAT " ;
441 if l = 19 then print " SONIC " ;
442 if l = 22 then print " THIN AND TATTY " ;
443 if l = 16 then print " DIGITAL " ;
444 if l = 20 then print " HAND-HELD " ;
445 if l = 2 then print " DILAPIDATED " ;
446 if l = 6 then print "N OLD " ;
447 if l = 8 then print " " ;
448 if l = 9 then print " " ;
449 if l = 10 then print " COMPUTER " ;
450 if l = 12 then print " COMPUTER " ;
451 if l = 15 then print " " ;
452 if l = 21 then print " GAS " ;
453 if l = 23 then print " SMALL " ;
454 print h$
455 return
456 print "."
457 print "YOUR SPACE YACHT HAS BEEN DAMAGED IN A FREAK SPACE ACCIDENT."
458 print "YOU ARE FORCED TO DOCK WITH A DESERTED WRECK IN AN ATTEMPT TO FIND"
459 print "THE EQUIPMENT NEEDED TO REPAIR YOUR YACHT."
460 print "CONTINUE?" : input w$: a$ = w$: gosub 900: w$ = a$: print "."
461 print "TO GET YOU STARTED HERE ARE SOME COMMANDS YOU MAY USE :-"
462 print "NORTH LOOK LIST QUIT"
463 print "CONTINUE?" : input w$: a$ = w$: gosub 900: w$ = a$
464 return
465 print "....................."
466 print " EMERGENCY "
467 print " COMPUTER SHUTDOWN "
468 print " PROCEDURE "
469 print ""
470 print " TRANSMAT INTO "
471 print " COMPUTER VAULT AND"
472 print " REMOVE PROCESSOR "
473 print " AND MEMORY CARDS. "
474 print "....................."
475 return
476 if echo = 1 then return
477 print "YOU ARE STANDING IN AN ACOUSTICALLY SEALED ROOM." : print: print
478 print "OK, WHAT NOW?"
479 input echo$: a$ = echo$: gosub 900: echo$ = a$
480 print: print
481 print echo$
482 print: print
483 if echo$ <> "ECHO" then 479
484 echo = 1
485 return
486 if a = 31 then gosub 465: goto 136
487 if p(13) = - 1 or p(13) = a then print "A LONG TIME AGO IN A GALAXY FAR, FAR AWAY.." : goto 21
488 print "WHAT DO YOU WANT TO READ, THE BRAND NAME ON YOUR BOOTS, PERHAPS?"
489 goto 136
850 print "DBG A$=";a$
851 for dq = 1 to len(a$)
852 print asc(mid$(a$, dq, 1));
853 next dq
854 print
855 return
860 print "DBG N$=";n$
861 for dq = 1 to len(n$)
862 print asc(mid$(n$, dq, 1));
863 next dq
864 print
865 return
870 restore
871 for dq = 1 to 31: read n$: next dq
872 print "DBG LOOK N$=";n$
873 for dq = 1 to len(n$)
874 print asc(mid$(n$, dq, 1));
875 next dq
876 print
877 restore
878 return
880 q = 1
881 if q > len(n$) then return
882 o = asc(mid$(n$, q, 1))
883 if o > 192 and o < 219 then n$ = left$(n$, q - 1) + chr$(o - 128) + mid$(n$, q + 1)
884 q = q + 1: goto 881
900 q = 1
901 if q > len(a$) then return
902 o = asc(mid$(a$, q, 1))
903 if o > 96 and o < 123 then mid$(a$, q, 1) = chr$(o - 32)
904 q = q + 1: goto 901
