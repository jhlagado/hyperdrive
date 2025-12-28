2 rem vic-20 input test
3 print chr$(14)
10 restore
20 read b$
30 print "TYPE ";b$
40 input a$
50 if a$ = b$ then print "MATCH" : goto 80
60 print "NO MATCH"
80 end
90 data "LOOK"
