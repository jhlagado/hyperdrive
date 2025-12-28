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
14 rem poke 36869, 192: poke 36879, 25: print "."
15 print "Énstructions? y/n"
16 input y$: a$ = y$: gosub 900: y$ = a$
17 if mid$(y$, 1, 1) = "y" then gosub 456
18 print ". "
19 f = 0
20 u = 0
21 if r = 1 then 136
22 if a < 18 or can = 1 and (p(21) = a or p(21) = - 1) then 25
23 print "Ùou cant breathe!! Ôhe air is poisoned by fumes."
24 goto 136
25 rem print a
26 g$ = "Ùou are in a corridor junction."
27 if a = 1 then g$ = "Ùou are in your space yacht, which is docked with the giant space wre"
28 if a = 1 then g$ = g$ + "ck. Ôo the north is an air-lock. Ét is open."
29 if a = 2 then g$ = "Ùou have entered the docking bay of the cruiser. Ôhe area is dimly l"
30 if a = 2 then g$ = g$ + "it by light from distant stars. Ôhe air-lock has closed and the el"
31 if a = 2 then g$ = g$ + "ectronic lock has engaged. Á passage leads east."
32 if a = 3 or a = 4 then g$ = "Óeveral corridors intersect here. "
33 if a = 3 then g$ = g$ + "Ótrewn around the floor are pieces of broken machinery. Ôhe corrid"
34 if a = 3 then g$ = g$ + "or is lit by the emergency lamps, forever drawing their power from "
35 if a = 3 then g$ = g$ + "the solar stacks."
36 if a = 4 then g$ = g$ + "Óome cables have been severed and are hanging, dangerously, from "
37 if a = 4 then g$ = g$ + "the ceiling."
38 if a = 5 then g$ = "Ùou are in a small observation port. Ôhe north and west walls are mad"
39 if a = 5 then g$ = g$ + "e of a glass-like material. Ét is showing signs of stress."
40 if a = 6 then g$ = "Ùou are in a service tunnel. Ôhere is a pool of oil on the floor."
41 if a = 8 then g$ = "Ôhis is a main corridor junction."
42 if a = 6 then g$ = "Ùou are in a service tunnel. Óomeone has ripped the cables and equipment"
43 if a = 6 then g$ = g$ + " from the walls and mangled them."
44 if a = 7 then g$ = "Ùou are in a service tunnel. Á pool of oil is on the floor."
45 if a = 9 then g$ = "Ùou are in an observation port. Ôhrough the eastern wall you can see "
46 if a = 9 then g$ = g$ + "the distant emery nebula."
47 if a = 10 then g$ = "Îow you are in an access chamber. Ôo the north is a flimsy ladder "
48 if a = 10 then g$ = g$ + "leading upwards."
49 if a = 11 then g$ = "Ùou are on the ladder in a plexiglass observation tube, which is use"
50 if a = 11 then g$ = g$ + "d to service the stabilizer retros."
51 if a = 12 then g$ = "Ùou are standing at the top of a ladder. Á passage leads south."
52 if a = 13 then g$ = "Åquipment lines the walls. Ôhis room is the relay station between the "
53 if a = 13 then g$ = g$ + "upper and lower decks of the cruiser."
54 if a = 14 then g$ = "Ùou are in a dark room. Ôo the west is a room marked 'Ôransmat'."
55 if a = 15 then g$ = "Ùou are in a long, dimly lit passage. Ôhe air smells of ozone."
56 if a = 16 then g$ = ". Ùou are standing in a small metal bay. Én front of you are several "
57 if a = 16 then g$ = g$ + "computer banks one of them bearing the word . Ôransmat."
58 if a = 17 then g$ = "Ôhis is an escape pod. Ôo activate it you need to know a secret code"
59 if a = 18 then g$ = "Âefore you looms one of the cruiser's warp engines. Ét is undamaged."
60 if a = 19 then g$ = "Ùou are in the maintenance workshop."
61 if a = 20 or a = 34 then g$ = "Ôhe warp engine stretches away to the south."
62 if a > 20 and a < 26 then g$ = "Ùou are in a long, dark corridor."
63 if a = 27 then g$ = "Ùou are in a small room. Ôhere is no way out."
64 if a = 28 then g$ = "Ùou are on a ledge overlooking a deep shaft."
65 if a = 30 then g$ = "Ùou are on the bridge of the cruiser."
66 if a = 31 then g$ = "Ùou are on the bridge. Âefore you is a large chart."
67 if a = 32 then g$ = "Ôhe manual controls of the cruiser line the walls."
68 if a = 33 then g$ = g$ + ". Âefore you is a small computer terminal labelled "
69 if a = 33 then g$ = g$ + ". Ælight computer. Ét seems too small for such a task. Óome of its"
70 if a = 33 then g$ = g$ + " circuit cards are missing."
71 if a = 35 then g$ = "Âefore you looms a warp engine. Ét has been burnt out."
72 if a = 37 then g$ = "Èere the main corridor ends. Ærom it branch three access tunnels."
73 if a = 38 then g$ = ".. Ùou are crawling through a long, dark wiring conduit. Ôhe surfaces "
74 if a = 38 then g$ = g$ + " are covered in sharp rivets that make crawling agonizing."
75 if a = 39 then g$ = "Âefore you looms one of the warp engines. Ét stretches away to the "
76 if a = 39 then g$ = g$ + "north."
77 if a = 40 then g$ = "Ùou are in a long east-west access tunnel."
78 if a = 42 then g$ = g$ + " Ùou are walking in circles."
79 if a = 43 then g$ = "Ùou are at another corridor junction."
80 if a = 45 then g$ = "Ôhe corridors are changing before your very eyes!"
81 if a = 46 then g$ = "Ùou are in an endless passage. Ôhe silence is terrifying..."
82 if a = 47 then g$ = "Ùou are standing in an acoustically sealed room."
83 if a = 47 then gosub 476
84 if a = 48 then g$ = "Âefore you is an electronic mine field... Ïne false step will be fatal."
85 if a = 49 then g$ = "Ùou survived the mine field and have stumbled into a dimensional war"
86 if a = 49 then g$ = g$ + "p. Îothing appears to be where it is. Á passage leads south."
87 if a = 50 then g$ = "Ùou have penetrated the computer complex. "
88 if a = 50 and p(11) = 50 then poke 36878, 15: poke 36876, 210: poke 36877, 254
89 if a = 50 and p(11) = 50 then g$ = g$ + "Ôhe sonic protection system is confusing your thoughts"
90 if a = 50 and p(11) = 50 then tr = tr + 1
91 if tr > 1 then print "Ùour brains have been scrambled by prolonged exposure to sonic"
92 if tr > 1 then print "Öibrations. Ùou almost made it!" : goto 335
93 if a = 51 then g$ = "Ôhere is a heavy iron door to the north."
94 if a = 53 then g$ = ". Ùou are in a small observation bubble. Ærom here you can see your yac"
95 if a = 53 then g$ = g$ + "ht in the docking bay. Ôhe damage to the yacht appears to be minor"
96 if a = 52 or a = 54 then g$ = "Ùou are in a long dimly lit passage. "
97 if a = 54 then g$ = g$ + "Ôhere is a body on the floor. Ét has been shot."
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
109 if a = 10 and c(a, 1) = 0 then print "Ét is too damaged to climb"
110 if a = 12 and c(a, 1) = 0 then print "Ôhe ladder has broken free and collapsed."
111 rem if a = 48 and c(a, 4) = 128 then print "."
112 if u > 200 then print "Ùour oxygen is running out."
113 if u < 230 then 116
114 can = 0
115 print "Én fact you have run out!"
116 v = 0
117 for l = 7 to 24
118 if p(l) = a then v = v + 1
119 next l
120 if v = 0 then 125
121 print "Ùou can also see:"
122 for l = 7 to 24
123 if p(l) = a then gosub 425
124 next l
125 v = 0
126 for l = 1 to 6
127 if p(l) = a then v = v + 1
128 next l
129 if v = 0 then 135
130 print
131 print "Îearby there lurks"
132 for l = 1 to 6
133 if p(l) = a then gosub 425
134 next l
135 r = 1
136 if a <> 50 or p(11) <> 50 then poke 36878, 0: poke 36877, 0: poke 36876, 0
137 print: print "Ïk... ×hat now?"
138 n(1) = 0
139 n(2) = 0
140 input a$: gosub 900
141 if a$ = "n" then n(1) = 1: goto 175
142 if a$ = "s" then n(1) = 2: goto 175
143 if a$ = "w" then n(1) = 3: goto 175
144 if a$ = "e" then n(1) = 4: goto 175
145 if a$ = "up" then n(1) = 1: goto 175
146 if a$ = "down" then n(1) = 1: goto 175
147 a$ = a$ + " "
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
158 read n$
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
172 print "É don't understand that!"
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
192 if n(1) > 16 then print "Èow?"
193 if n(1) < 17 then print "Èow destructive!!"
194 goto 138
195 rem
196 if n(1) < 7 or n(1) > 9 then 211
197 on n(1) - 6 goto 198, 200, 210
198 r = 0
199 goto 21
200 print "Ùou are carrying "
201 v = 0
202 for l = 7 to 24
203 if p(l) = - 1 then v = v + 1
204 next l
205 if v = 0 then print "Îothing." : goto 209
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
221 print "Áuuuugh... Ùou've just been killed by a " : print k$
222 goto 335
223 print "Ôhe rusty drone picked you up and carried you to another place."
224 a = 33
225 r = 0
226 p(5) = p(5) + 7
227 goto 21
228 if n(1) > 4 then 242
229 if p(8) = - 1 or p(8) = a then 232
230 n(1) = int(rnd(1) * 4 + 1)
231 rem
232 b = c(a, n(1))
233 if b = 0 then print "Ùou cant go that way."
234 if b = 128 then print "Ôhe plexiglass cracks then shatters. Ùou are sucked out into space."
235 if b = 129 then print "Ùou fall down the shaft and are killed."
236 if b = 130 then print "Ùou step into the air-lock. Ôhe second air-lock door opens and"
237 if b = 130 then print "Ùou are sucked out into space."
238 if b > 127 then 335
239 if b > 0 then a = b
240 r = 0
241 goto 21
242 if n(1) <> 5 then 257
243 if n(1) <> 5 then 257
244 r = 0
245 if a = 16 and p(17) = - 1 then 250
246 a = 16
247 print "Óuddenly.. Ôhe room vanishes from before you."
248 for de = 1 to 1000: next de
249 goto 21
250 print "Ånter destination code"
251 input co$: a$ = co$: gosub 900: co$ = a$
252 if left$(co$, 1) = "y" then a = 1: goto 247
253 if left$(co$, 1) = "b" then a = 31: goto 247
254 if left$(co$, 1) = "c" then a = 41: goto 247
255 goto 21
256 goto 247
257 if n(1) <> 6 then 260
258 rem
259 goto 21
260 if n(2) < 1 then 172
261 if p(n(2)) = - 1 or p(n(2)) = a then 264
262 print "×here? É can't see it."
263 goto 21
264 on n(1) - 9 goto 265, 274, 276
265 n = 1
266 for x = 1 to 24
267 if p(x) = - 1 then n = n + 1
268 next x
269 if n < 12 then 272
270 print "Ùou are carrying too many objects."
271 goto 21
272 p(n(2)) = - 1
273 goto 136
274 p(n(2)) = a
275 goto 136
276 if n(2) > 17 and n(2) < 23 then 279
277 print "Îothing happens!"
278 goto 136
279 on n(2) - 17 goto 311, 280, 289, 277, 326
280 if a = 2 or a = 27 then 283
281 print "Ét won't open"
282 goto 21
283 print "Ùou opened the door."
284 p(n(2)) = a
285 r = 0
286 if a = 2 then a = 1
287 if a = 27 then a = 54
288 goto 21
289 if z < 7 then 292
290 print "Ôhere's nothing to destroy!"
291 goto 21
292 f = f + 1
293 rem * * * * modificati on was 15
294 if rnd(1) * 7 + 10 > f then 297
295 print "Ùou shoot at it and miss. Ôhe machine deals you a fatal wound."
296 goto 335
297 if rnd(1) < .38 then 306
298 l = int(rnd(1) * 4)
299 if z = 5 then goto 223
300 if l = 0 then print "Ùou fire at the machine but it moves aside."
301 if l = 1 then print "Ôhe machine is damaged but it attacks again."
302 if l = 2 then print "Ôhe shot damages the machine slightly. Ét attacks again."
303 if l = 3 then print "Ùou missed and it fights back with a logical calmness that"
304 if l = 3 then print "Álarms you."
305 goto 21
306 print "Ôhe shot is well aimed and the machine scuttles away, badly damaged."
307 p(n(2)) = - 1
308 if z = 3 or z = 5 then p(z) = p(z) + 10
309 if p(z) = a then p(z) = 0
310 goto 21
311 if p(9) = - 1 or p(9) = a then 315
312 print "Ôhat won't burn, dummy!! Én fact, the match went out."
313 mat = 0
314 goto 21
315 if mat = 1 then 318
316 print "Âut the match is out, stupid!!"
317 goto 21
318 print "Ôhe fuse burnt away and... Âoom!!... Ôhe explosion blew you out of the way!!"
319 r = 0
320 if a = 2 then c(a, 2) = 1
321 if a = 51 then c(a, 1) = 130
322 if a > 1 then a = a - 1
323 if a = 20 then c(20, 3) = 19
324 p(9) = 0
325 goto 21
326 if a = 28 then 329
327 print "Ét's too dangerous!!!"
328 goto 21
329 print "Ùou descend the rope, but it drops 10 feet short of the floor."
330 print "Ùou jump the rest of the way."
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
341 print "Ùou got a score of "
342 print s;
344 print "Én" ;u; " Íoves."
345 if a > 1 or j < 1 then 372
346 print "Ùou spend the next day repairing your yacht with the equipment"
347 print "Ôhat you found on the wreck. "
348 print "Èoping that you have been successful in repairing the yacht "
349 print "Ùou manoeuvre the yacht into space and engage the Èyperdrive... "
350 for de = 1 to 4000: next de
351 if s > 79 then 362
352 if s < 80 then print "Ôhe yacht begins to move forward, then suddenly the drive "
353 if s < 80 then print "Ïverloads and explodes blowing you into cosmic dust"
354 poke 36878, 15
355 for x = 255 to 128 step - 1
356 poke 36877, x
357 for de = 1 to 20: next de
358 poke 36874, x
359 next x
360 for x = 15 to 0 step - 1 : for y = 1 to 20: next y: poke 36878, x: next x
361 goto 372
362 if s < 110 then print "Ôhe Èyperdrive refuses to engage, leaving you to drift in space."
363 if s < 110 then print "Ðerhaps someone will hear your mayday" : goto 372
364 if s < 126 then print "Ôhe Èyperdrive engages and the yacht moves slowly off into space."
365 if s < 126 then print "Ùou find that you are limited to half speed. Ét may take a while"
366 if s < 126 then print "Âut you will get home!! " : goto 372
367 if s = 126 then print "Ôhe alien Èyperdrive is superior to the old Èyperdrive."
368 for x = 1 to 2000: next x
369 if s = 126 then print ". Ùou are able to achieve speeds greater than ever before!!"
370 if s = 126 then print "Éf you sell the drive you will be one of the richest men on earth."
371 if s = 126 then print "Ãongratulations!! Ùou made it."
372 rem
373 print "Ánother adventure? (y/n)"
374 input a$: gosub 900
375 if left$ (a$, 1) = "y" then 3
376 print "Ùes or no - this is your last chance!!"
377 input w$: a$ = w$: gosub 900: w$ = a$
378 if left$ (w$, 1) = "y" then 3
379 print " Ùou have been playing Èyperdrive for"
380 print left$(ti$, 2); " Èours " ;mid$(ti$, 3, 2); " Íinutes!!"
381 for de = 1 to 5000: next de
382 poke 36879, 8
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
400 data "drone", "'droid", "humanoid", "machine", "drone", "robot", "pump"
401 data "compass", "bomb", "memory", "processor", "tape"
402 data "book", "servo", "toolkit", "clock", "bracelet", "matches", "screwdriver"
403 data "blaster", "mask", "rope", "magnet", "fuse", "north"
404 data "south"
405 data "west", "east", "transmat", "ape", "look", "list", "quit", "take"
406 data "drop", "use", "using", "with", "cut", "break", "up"
407 data "unlock", "open", "kill", "shoot", "light", "burn", "down", "jump", "read", "get", "z" , "z" , "z" , "z" , "help"
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
422 print "Èyperdrive"
423 print "Ây Ëen Ótone and Êohn Èardy"
424 return
425 restore
426 for k = 1 to l
427 read h$
428 next k
429 print "Á" ;
430 if l = 5 then print " rusty " ;
431 if l = 7 then print " fuel " ;
432 if l = 24 then print " small " ;
433 if l = 4 then print " security " ;
434 if l = 1 then print " service " ;
435 if l = 3 then print " battered " ;
436 if l = 13 then print "n interesting " ;
437 if l = 14 then print " stabilizer " ;
438 if l = 18 then print " box of " ;
439 if l = 11 then print " computer " ;
440 if l = 17 then print " transmat " ;
441 if l = 19 then print " sonic " ;
442 if l = 22 then print " thin and tatty " ;
443 if l = 16 then print " digital " ;
444 if l = 20 then print " hand-held " ;
445 if l = 2 then print " dilapidated " ;
446 if l = 6 then print "n old " ;
447 if l = 8 then print " " ;
448 if l = 9 then print " " ;
449 if l = 10 then print " computer " ;
450 if l = 12 then print " computer " ;
451 if l = 15 then print " " ;
452 if l = 21 then print " gas " ;
453 if l = 23 then print " small " ;
454 print h$
455 return
456 print "."
457 print "Ùour space yacht has been damaged in a freak space accident."
458 print "Ùou are forced to dock with a deserted wreck in an attempt to find"
459 print "Ôhe equipment needed to repair your yacht."
460 print "Ãontinue?" : input w$: a$ = w$: gosub 900: w$ = a$: print "."
461 print "Ôo get you started here are some commands you may use :-"
462 print "north look list quit"
463 print "Ãontinue?" : input w$: a$ = w$: gosub 900: w$ = a$
464 return
465 print "......................"
466 print ". Åmergency          ."
467 print ". Ãomputer shutdown  ."
468 print ". Ðrocedure          ."
469 print ".                    ."
470 print ". Ôransmat into      ."
471 print ". Ãomputer vault and ."
472 print ". Òemove processor   ."
473 print ". Ánd memory cards.  ."
474 print "......................"
475 return
476 if echo = 1 then return
477 print "Ùou are standing in an acoustically sealed room." : print: print
478 print "Ïk, what now?"
479 input echo$: a$ = echo$: gosub 900: echo$ = a$
480 print: print
481 print echo$
482 print: print
483 if echo$ <> "echo" then 479
484 echo = 1
485 return
486 if a = 31 then gosub 465: goto 136
487 if p(13) = - 1 or p(13) = a then print "Á long time ago in a galaxy far, far away..." : goto 21
488 print "×hat do you want to read, the brand name on your boots, perhaps?"
489 goto 136
900 q = 1
901 if q > len(a$) then return
902 o = asc(mid$(a$, q, 1))
903 if o > 64 and o < 91 then a$ = left$(a$, q - 1) + chr$(o + 32) + mid$(a$, q + 1)
904 if o > 192 and o < 219 then a$ = left$(a$, q - 1) + chr$(o - 96) + mid$(a$, q + 1)
905 q = q + 1: goto 901
