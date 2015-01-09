SCREEN 9


xvs=250
yvs=100
redim vid1(119,55)
redim vid2(119,55)
redim vid3(119,55)

for num=1 to 3
num$=str$(num)
num$=mid$(num$,2,4)

OPEN "vid" + num$ + ".phg" FOR INPUT AS #1
	input #1,xvid
	input #1,yvid
	for xv=1 to xvid
		for yv=1 to yvid
			input #1,col
			pset (xv+xvs-1,yv+yvs-1),col
		next
	next
close

if num=1 then get (xvs,yvs)-(118+xvs,54+yvs),vid1
if num=2 then get (xvs,yvs)-(118+xvs,54+yvs),vid2
if num=3 then get (xvs,yvs)-(118+xvs,54+yvs),vid3
next

spd=10000
for vi=1 to 6
spd=spd+5000
put(xvs,yvs),vid1,pset:for tim=1 to spd:next
put(xvs,yvs),vid2,pset:for tim=1 to spd:next
put(xvs,yvs),vid3,pset:for tim=1 to spd:next
put(xvs,yvs),vid2,pset:for tim=1 to spd:next
next
put(xvs,yvs),vid1,pset:for tim=1 to spd:next
put(xvs,yvs),vid2,pset:for tim=1 to spd:next
put(xvs,yvs),vid3,pset:for tim=1 to spd:next

