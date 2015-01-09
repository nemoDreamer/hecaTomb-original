' HecaEdit II (.LVL editor)
' =========================
'
' Copyright 1997 Philip Blyth
'
' Licensed under the Apache License, Version 2.0 (the "License");
' you may not use this file except in compliance with the License.
' You may obtain a copy of the License at
'
'   http://www.apache.org/licenses/LICENSE-2.0
'
' Unless required by applicable law or agreed to in writing, software
' distributed under the License is distributed on an "AS IS" BASIS,
' WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
' See the License for the specific language governing permissions and
' limitations under the License.

ON ERROR GOTO fehler

filemain$ = "OWN"
switch$ = "p"

SCREEN 9
WIDTH 80, 25

x1 = 230
y1 = 135
x2 = 390
y2 = 185
sfcol = 0
bcol = 1
fcol = 9
GOSUB frame

LOCATE 12, 35
COLOR 9
PRINT "LOADING..."

xpic = 11
ypic = 11

REDIM blank(xpic, ypic)
REDIM mon3(xpic, ypic)
REDIM mon4(xpic, ypic)
REDIM mon5(xpic, ypic)
REDIM wall(xpic, ypic)
REDIM gate(xpic, ypic)
REDIM gateo(xpic, ypic)
REDIM spear(xpic, ypic)
REDIM goal(xpic, ypic)
REDIM start(xpic, ypic)
REDIM you(xpic, ypic)
REDIM keys(xpic, ypic)
REDIM soil(xpic, ypic)
REDIM blood(xpic, ypic)
REDIM youw(xpic, ypic)
REDIM water(xpic, ypic)
REDIM wblood(xpic, ypic)
REDIM wmonst(xpic, ypic)
REDIM money(xpic, ypic)
REDIM mon6(xpic, ypic)
REDIM dagger(xpic, ypic)
REDIM bones(xpic, ypic)
REDIM zisch(xpic, ypic)
REDIM rock(xpic, ypic)
REDIM rockc(4, 4)
REDIM title(355, 45)

GOSUB loadscript

GOSUB loadpics

GOSUB intro

VIEW PRINT 21 TO 25

KEY 1, "³"
KEY 2, "$"
KEY 3, "œ"
KEY 4, "ù"
KEY 30, "ž"
KEY 31, "%"

big = 11

xmax = 58
ymax = 25

REDIM feld(xmax, ymax)

x = 1
y = 1

anfang:
CLS

'Draw Background
FOR dry = 1 TO ymax
	FOR drx = 1 TO xmax
		what = feld(drx, dry)
		GOSUB drawobjs
	NEXT
NEXT

GOSUB prinfo

drx = x
dry = y
PUT ((drx * big) - big + 1, (dry * big) - big + 1), blank, XOR

startloop:

r$ = INKEY$
IF r$ = "" THEN GOTO startloop
COLOR 9
'----------------------------------------------------------------------------
IF r$ = CHR$(27) THEN END
IF r$ = "³" THEN GOSUB help
IF r$ = "$" THEN GOSUB saving
IF r$ = "œ" THEN GOSUB loading
IF r$ = "ù" THEN GOSUB note
IF r$ = "%" THEN GOSUB code
'continous
IF r$ = " " THEN
	IF conti = 0 THEN
		LOCATE 21, 1
		INPUT "Code of tile to draw: "; tile$
		LOCATE 21, 1
		PRINT "Hit SPACE again to end...                        "
		SELECT CASE tile$
			CASE "w": tile = 55
			CASE "m": tile = 66
			CASE "o": tile = 99
			CASE "d": tile = 88
			CASE "x": tile = 222
			CASE "n": tile = 3.5
			CASE "b": tile = 1.1
			CASE "a": tile = 4.5
			CASE "h": tile = 5.5
			CASE "f": tile = 333
			CASE "v": tile = 1
			CASE "1": tile = 1.5
			CASE "p": tile = 2222
			CASE "g": tile = 3333
			CASE "c": tile = 3.3
			CASE "r": tile = 202
			CASE "i": tile = 600
			CASE ELSE
				tile = VAL(tile$)
				IF tile <> 0 AND tile <> 1 AND tile <> 2 AND tile <> 3 AND tile <> 4 AND tile <> 5 AND tile <> 6 AND tile <> 7 AND tile <> 8 AND tile <> 9 THEN GOSUB prinfo: GOTO startloop
		END SELECT

		conti = 1
	ELSE
		conti = 0
		CLS 2
		GOSUB prinfo
	END IF
END IF
'======================================= MOVING =============================
'for erase
drx = x
dry = y
IF conti = 0 THEN
	what = 10'************
END IF
IF conti = 1 THEN
	feld(x, y) = tile
	what = tile
END IF
GOSUB drawobjs
'----------------------------------------------------------------------------
'up
IF r$ = CHR$(0) + CHR$(72) AND y > 1 THEN
	y = y - 1
END IF
'----------------------------------------------------------------------------
'down
IF r$ = CHR$(0) + CHR$(80) AND y < ymax THEN
	y = y + 1
END IF
'----------------------------------------------------------------------------
'left
IF r$ = CHR$(0) + CHR$(75) AND x > 1 THEN
	x = x - 1
END IF
'----------------------------------------------------------------------------
'right
IF r$ = CHR$(0) + CHR$(77) AND x < xmax THEN
	x = x + 1
END IF
'============================================================================
'empty
IF r$ = "0" THEN feld(x, y) = 0
'----------------------------------------------------------------------------
'start
IF r$ = "1" THEN feld(x, y) = 1.5
'----------------------------------------------------------------------------
'wall
IF r$ = "2" THEN feld(x, y) = 2
'----------------------------------------------------------------------------
'monster
IF r$ = "3" THEN feld(x, y) = 3
IF r$ = "4" THEN feld(x, y) = 4
IF r$ = "5" THEN feld(x, y) = 5
'----------------------------------------------------------------------------
'end
IF r$ = "9" THEN feld(x, y) = 9
'----------------------------------------------------------------------------
'spear
IF r$ = "8" THEN feld(x, y) = 8
'----------------------------------------------------------------------------
'key
IF r$ = "7" THEN feld(x, y) = 7
'----------------------------------------------------------------------------
'door
IF r$ = "6" THEN feld(x, y) = 6
'----------------------------------------------------------------------------
'water
IF r$ = "w" THEN feld(x, y) = 55
'----------------------------------------------------------------------------
'watermonster
IF r$ = "m" THEN feld(x, y) = 66
'----------------------------------------------------------------------------
'Money
IF r$ = "o" THEN feld(x, y) = 99
'----------------------------------------------------------------------------
'Dagger
IF r$ = "d" THEN feld(x, y) = 88
'----------------------------------------------------------------------------
'Invisible
IF r$ = "x" THEN feld(x, y) = 222
'----------------------------------------------------------------------------
'Move Wall
IF r$ = "n" THEN feld(x, y) = 3.5
'----------------------------------------------------------------------------
'Bones
IF r$ = "b" THEN feld(x, y) = 1.1
'----------------------------------------------------------------------------
'Acid
IF r$ = "a" THEN feld(x, y) = 4.5
'----------------------------------------------------------------------------
'Hidden Acid
IF r$ = "h" THEN feld(x, y) = 5.5
'----------------------------------------------------------------------------
'Forest
IF r$ = "f" THEN feld(x, y) = 333
'----------------------------------------------------------------------------
'Woodway
IF r$ = "v" THEN feld(x, y) = 1
'----------------------------------------------------------------------------
'Forest Monster
IF r$ = "c" THEN feld(x, y) = 3.3
'----------------------------------------------------------------------------
'Thin Forest
IF r$ = "g" THEN feld(x, y) = 3333
'----------------------------------------------------------------------------
'Thin Wall
IF r$ = "p" THEN feld(x, y) = 2222
'----------------------------------------------------------------------------
'Thin Wall
IF r$ = "i" THEN feld(x, y) = 600
'----------------------------------------------------------------------------
'Rock
IF r$ = "r" THEN feld(x, y) = 202
'----------------------------------------------------------------------------
'Cut out
'IF r$ = "ý" THEN gosub cutout'* * * * * * * * * * * * * * *
'----------------------------------------------------------------------------
'----------------------------------------------------------------------------
'Print out level
IF r$ = "ž" THEN GOSUB printlevel
'----------------------------------------------------------------------------
'----------------------------------------------------------------------------
drx = x
dry = y
what = feld(x, y)
GOSUB drawobjs
what = 10
GOSUB drawobjs

GOTO startloop
END

'****************************************************************************
drawobjs:
SELECT CASE what
CASE 10
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), blank, XOR
CASE 55
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), water, PSET
CASE 66
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), wmonst, PSET
CASE 1
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), start, PSET
CASE 1.5
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), start, PSET
	xi = drx * big
	yi = dry * big
	spac = 3
	LINE (xi - spac, yi - big + spac)-(xi - big + spac, yi - spac), 14
	LINE (xi - big + spac, yi - big + spac)-(xi - spac, yi - spac), 14
CASE 0
	LINE ((drx * big) - big + 1, (dry * big) - big + 1)-((drx * big), (dry * big)), 0, BF
CASE 2
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), wall, PSET
CASE 3
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), mon3, PSET
CASE 4
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), mon4, PSET
CASE 5
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), mon5, PSET
CASE 6
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), keys, PSET
CASE 7
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), gate, PSET
CASE 8
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), spear, PSET
CASE 88
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), dagger, PSET
CASE 9
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), goal, PSET
CASE 99
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), money, PSET
CASE 3.5
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), wall, PSET
	xi = drx * big
	yi = dry * big
	spac = 3
	LINE (xi - spac, yi - big + spac)-(xi - big + spac, yi - spac), 14
	LINE (xi - big + spac, yi - big + spac)-(xi - spac, yi - spac), 14
CASE 5.5
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), money, PSET
	PSET ((drx * big) - (big / 2) + 1, (dry * big) - (big / 2) + 2), 0
	PSET ((drx * big) - (big / 2), (dry * big) - (big / 2) + 1), 0
	PSET ((drx * big) - (big / 2) - 1, (dry * big) - (big / 2) + 2), 0

	PSET ((drx * big) - (big / 2) + 1, (dry * big) - (big / 2) + 3), 0
	PSET ((drx * big) - (big / 2), (dry * big) - (big / 2) + 4), 0
	PSET ((drx * big) - (big / 2) - 1, (dry * big) - (big / 2) + 3), 0
CASE 1.1
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), bones, PSET
CASE 3333
	LINE ((drx * big) - big + 1, (dry * big) - big + 1)-((drx * big), (dry * big)), 0, BF
	FOR slime = 1 TO 5
		xslm = INT(RND * 10 + 1)
		yslm = INT(RND * 10 + 1)
		forestcol = INT(RND * 2 + 1)
		IF forestcol = 1 THEN forestcol = 10
		LINE ((drx * big) - big + xslm, (dry * big) - big + yslm)-((drx * big) - big + 1 + xslm, (dry * big) - big + 1 + yslm), forestcol, BF
	NEXT
	FOR slime = 1 TO 5
		xslm = INT(RND * 11)
		yslm = INT(RND * 11)
		PSET ((drx * big) - big + 1 + xslm, (dry * big) - big + 1 + yslm), 6
	NEXT
CASE 333
	LINE ((drx * big) - big + 1, (dry * big) - big + 1)-((drx * big), (dry * big)), 0, BF
	FOR slime = 1 TO 30
		xslm = INT(RND * 10 + 1)
		yslm = INT(RND * 10 + 1)
		forestcol = INT(RND * 2 + 1)
		IF forestcol = 1 THEN forestcol = 10
		LINE ((drx * big) - big + xslm, (dry * big) - big + yslm)-((drx * big) - big + 1 + xslm, (dry * big) - big + 1 + yslm), forestcol, BF
	NEXT
	FOR slime = 1 TO 30
		xslm = INT(RND * 11)
		yslm = INT(RND * 11)
		PSET ((drx * big) - big + 1 + xslm, (dry * big) - big + 1 + yslm), 6
	NEXT
CASE 3.3
	LINE ((drx * big) - big + 1, (dry * big) - big + 1)-((drx * big), (dry * big)), 0, BF
	FOR slime = 1 TO 30
		xslm = INT(RND * 10 + 1)
		yslm = INT(RND * 10 + 1)
		forestcol = INT(RND * 2 + 1)
		IF forestcol = 1 THEN forestcol = 10
		LINE ((drx * big) - big + xslm, (dry * big) - big + yslm)-((drx * big) - big + 1 + xslm, (dry * big) - big + 1 + yslm), forestcol, BF
	NEXT
	FOR slime = 1 TO 20
		xslm = INT(RND * 11)
		yslm = INT(RND * 11)
		PSET ((drx * big) - big + 1 + xslm, (dry * big) - big + 1 + yslm), 6
	NEXT
	FOR dy = -1 TO 1
		FOR dx = -1 TO 1
			xi = drx * big + dx
			yi = dry * big + dy
			spac = 2
			LINE (xi - spac, yi - big + spac)-(xi - big + spac, yi - spac), 6
			LINE (xi - big + spac, yi - big + spac)-(xi - spac, yi - spac), 6
		NEXT
	NEXT
CASE 4.5
	LINE ((drx * big) - big + 1, (dry * big) - big + 1)-((drx * big), (dry * big)), 0, BF
	FOR slime = 1 TO 10
		xslm = INT(RND * 11)
		yslm = INT(RND * 11)
		PSET ((drx * big) - big + 1 + xslm, (dry * big) - big + 1 + yslm), 10
	NEXT
	FOR slime = 1 TO 10
		xslm = INT(RND * 11)
		yslm = INT(RND * 11)
		PSET ((drx * big) - big + 1 + xslm, (dry * big) - big + 1 + yslm), 9
	NEXT
CASE 222
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), mon6, PSET
CASE 2222
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), wall, PSET
	FOR slime = 1 TO 30
		xslm = INT(RND * 11)
		yslm = INT(RND * 11)
		PSET ((drx * big) - big + 1 + xslm, (dry * big) - big + 1 + yslm), 0
	NEXT
CASE 600
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), water, PSET
	FOR slime = 1 TO 20
		xslm = INT(RND * 11)
		yslm = INT(RND * 11)
		PSET ((drx * big) - big + 1 + xslm, (dry * big) - big + 1 + yslm), 12
	NEXT
CASE 202
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), rock, PSET
CASE ELSE
END SELECT
RETURN

'////////////////////////////////////////////////////////////////////////////
saving:
LOCATE 21, 1
CLS 2
PRINT "SAVE Number of file? (X to abort)"
INPUT fil$
IF fil$ = "x" THEN CLS 2: GOSUB prinfo: RETURN
IF fil$ = "" THEN fil$ = filist$
filist$ = fil$
PRINT "REMARK"
INPUT rem$
IF rem$ = "" THEN rem$ = remark$
remark$ = rem$
OPEN filemain$ + filist$ + ".lvl" FOR OUTPUT AS #1
PRINT "SAVING..."
WRITE #1, remark$
WRITE #1, xmax, ymax
FOR xx = 1 TO xmax
	FOR yy = 1 TO ymax
		WRITE #1, feld(xx, yy)
	NEXT
NEXT
CLOSE
PRINT "OK..."

CLS 2: GOSUB prinfo
RETURN

'////////////////////////////////////////////////////////////////////////////
loading:
LOCATE 21, 1
CLS 2
PRINT "LOAD Number of file? (<ENTER> to abort)"
INPUT filiste$
IF filiste$ = "" THEN CLS 2: GOSUB prinfo: RETURN
filist$ = filiste$
IF filist$ = "0" OR filist$ = "00" OR filist$ = "000" OR filist$ = "0000" OR filist$ = "00000" THEN
	fil$ = filist$ + ".lvl"
ELSE
	fil$ = filemain$ + filist$ + ".lvl"
END IF
OPEN fil$ FOR INPUT AS #1
PRINT "LOADING..."
INPUT #1, remark$
INPUT #1, xmax, ymax
FOR xx = 1 TO xmax
	FOR yy = 1 TO ymax
		INPUT #1, feld(xx, yy)
	NEXT
NEXT
CLOSE
PRINT "OK..."

GOTO anfang

'////////////////////////////////////////////////////////////////////////////
prinfo:
CLS 2
LOCATE 21, 2
COLOR 12
PRINT "LEVEL: "; filist$; " '"; remark$; "'";
COLOR 4
PRINT TAB(53); "³b:Bones    ³v:Woodway"
COLOR 4
LOCATE 22, 2: PRINT "0:Blank³3-5:Monster³8:Spear³o:Money    ³m:Shark    ³n:Mov. Wall³g:Thin Forest"
LOCATE 23, 2: PRINT "1:Start³6:Key      ³9:End  ³d:Dagger   ³w:Water    ³f:Forest   ³p:Thin Wall"
LOCATE 24, 2: PRINT "2:Wall ³7:Gate     ³a:Acid ³h:Bad Money³x:Inv. Wall³c:Mov. For.³"; : COLOR 12: PRINT "F1 More";
COLOR 8
if filemain$="OWN" then PRINT TAB(77); filemain$ else PRINT TAB(77); "HECA"
COLOR 9
RETURN



'----------------------------------------------------------------------------
loadpics:

FOR loapic = 1 TO 23
SELECT CASE loapic
CASE 1
file$ = "mon3.phg"
CASE 2
file$ = "mon4.phg"
CASE 3
file$ = "wall.phg"
CASE 4
file$ = "gate.phg"
CASE 5
file$ = "gateo.phg"
CASE 6
file$ = "spear.phg"
CASE 7
file$ = "goal.phg"
CASE 8
file$ = "start.phg"
CASE 9
file$ = "you.phg"
CASE 10
file$ = "mon5.phg"
CASE 11
file$ = "keys.phg"
CASE 12
file$ = "blood.phg"
CASE 13
file$ = "youw.phg"
CASE 14
file$ = "water.phg"
CASE 15
file$ = "wbloo.phg"
CASE 16
file$ = "wmons.phg"
CASE 17
file$ = "daggr.phg"
CASE 18
file$ = "money.phg"
CASE 19
file$ = "mo6ed.phg"
CASE 20
file$ = "bones.phg"
CASE 21
file$ = "title.phg"
CASE 22
file$ = "zi.phg"
CASE 23
file$ = "wall4.phg"
END SELECT

OPEN file$ FOR INPUT AS #1
	INPUT #1, xpic
	INPUT #1, ypic
	FOR xxp = 1 TO xpic
		FOR yyp = 1 TO ypic
			INPUT #1, picdata
			IF loapic = 1 THEN mon3(xxp, yyp) = picdata
			IF loapic = 2 THEN mon4(xxp, yyp) = picdata
			IF loapic = 3 THEN wall(xxp, yyp) = picdata
			IF loapic = 4 THEN gate(xxp, yyp) = picdata
			IF loapic = 5 THEN gateo(xxp, yyp) = picdata
			IF loapic = 6 THEN spear(xxp, yyp) = picdata
			IF loapic = 7 THEN goal(xxp, yyp) = picdata
			IF loapic = 8 THEN start(xxp, yyp) = picdata
			IF loapic = 9 THEN you(xxp, yyp) = picdata
			IF loapic = 10 THEN mon5(xxp, yyp) = picdata
			IF loapic = 11 THEN keys(xxp, yyp) = picdata
			IF loapic = 12 THEN blood(xxp, yyp) = picdata
			IF loapic = 13 THEN youw(xxp, yyp) = picdata
			IF loapic = 14 THEN water(xxp, yyp) = picdata
			IF loapic = 15 THEN wblood(xxp, yyp) = picdata
			IF loapic = 16 THEN wmonst(xxp, yyp) = picdata
			IF loapic = 17 THEN dagger(xxp, yyp) = picdata
			IF loapic = 18 THEN money(xxp, yyp) = picdata
			IF loapic = 19 THEN mon6(xxp, yyp) = picdata
			IF loapic = 20 THEN bones(xxp, yyp) = picdata
			IF loapic = 21 THEN title(xxp, yyp) = picdata
			IF loapic = 22 THEN zisch(xxp, yyp) = picdata
			IF loapic = 23 THEN rock(xxp, yyp) = picdata
		NEXT yyp
	NEXT xxp
CLOSE
NEXT loapic

'GET objects
CLS
xlp = 315
ylp = 145
FOR show = 1 TO 22
	FOR xxp = 1 TO 11
		FOR yyp = 1 TO 11
			IF show = 1 THEN PSET (xxp + xlp, yyp + ylp), you(xxp, yyp)
			IF show = 2 THEN PSET (xxp + xlp, yyp + ylp), start(xxp, yyp)
			IF show = 3 THEN PSET (xxp + xlp, yyp + ylp), wall(xxp, yyp)
			IF show = 4 THEN PSET (xxp + xlp, yyp + ylp), mon3(xxp, yyp)
			IF show = 5 THEN PSET (xxp + xlp, yyp + ylp), mon4(xxp, yyp)
			IF show = 6 THEN PSET (xxp + xlp, yyp + ylp), mon5(xxp, yyp)
			IF show = 7 THEN PSET (xxp + xlp, yyp + ylp), spear(xxp, yyp)
			IF show = 8 THEN PSET (xxp + xlp, yyp + ylp), goal(xxp, yyp)
			IF show = 9 THEN PSET (xxp + xlp, yyp + ylp), gate(xxp, yyp)
			IF show = 10 THEN PSET (xxp + xlp, yyp + ylp), gateo(xxp, yyp)
			IF show = 11 THEN PSET (xxp + xlp, yyp + ylp), keys(xxp, yyp)
			IF show = 12 THEN PSET (xxp + xlp, yyp + ylp), blood(xxp, yyp)
			IF show = 13 THEN PSET (xxp + xlp, yyp + ylp), youw(xxp, yyp)
			IF show = 14 THEN PSET (xxp + xlp, yyp + ylp), water(xxp, yyp)
			IF show = 15 THEN PSET (xxp + xlp, yyp + ylp), wblood(xxp, yyp)
			IF show = 16 THEN PSET (xxp + xlp, yyp + ylp), wmonst(xxp, yyp)
			IF show = 17 THEN PSET (xxp + xlp, yyp + ylp), dagger(xxp, yyp)
			IF show = 18 THEN PSET (xxp + xlp, yyp + ylp), money(xxp, yyp)
			IF show = 19 THEN PSET (xxp + xlp, yyp + ylp), mon6(xxp, yyp)
			IF show = 20 THEN PSET (xxp + xlp, yyp + ylp), bones(xxp, yyp)
			IF show = 21 THEN PSET (xxp + xlp, yyp + ylp), zisch(xxp, yyp)
			IF show = 22 THEN PSET (xxp + xlp, yyp + ylp), rock(xxp, yyp)
		NEXT yyp
	NEXT xxp
't$=input$(1)
			IF show = 1 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), you
			IF show = 2 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), start
			IF show = 3 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), wall
			IF show = 4 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), mon3
			IF show = 5 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), mon4
			IF show = 6 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), mon5
			IF show = 7 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), spear
			IF show = 8 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), goal
			IF show = 9 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), gate
			IF show = 10 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), gateo
			IF show = 11 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), keys
			IF show = 12 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), blood
			IF show = 13 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), youw
			IF show = 14 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), water
			IF show = 15 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), wblood
			IF show = 16 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), wmonst
			IF show = 17 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), dagger
			IF show = 18 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), money
			IF show = 19 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), mon6
			IF show = 20 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), bones
			IF show = 21 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), zisch
			IF show = 22 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), rock
NEXT show

CLS

LINE (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), 15, BF
GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), blank

RETURN

frame:
LINE (x1, y1)-(x2, y2), bcol, BF
LINE (x1 + 4 + 1, y1 + 3 + 1)-(x2 - 4 + 1, y2 - 3 + 1), sfcol, B
LINE (x1 + 4, y1 + 3)-(x2 - 4, y2 - 3), fcol, B
LINE (x1 + 10, y1 + 8)-(x2 - 10, y2 - 8), 0, BF
RETURN

fehler:
SELECT CASE ERR
CASE 53
	COLOR 12
	PRINT "!!! FILE NOT FOUND !!! (wait, please)"
	RESUME NEXT
CASE 52
	COLOR 12
	PRINT "!!! FILE NOT FOUND !!! (wait, please)"
	RESUME NEXT
CASE 7
	CLS
	BEEP
	COLOR 7
	PRINT "SORRY, you haven't got enough memory to use HECATOMB EDITOR..."
	r$ = INPUT$(1)
	END
CASE 25
	COLOR 12
	PRINT "PRINTER ERROR!!! Device maybe not ready..."
	RESUME NEXT
CASE ELSE
	CLS
	BEEP
	COLOR 7
	PRINT "SORRY, unexpected error "; ERR; " occurred..."
	r$ = INPUT$(1)
	END
END SELECT

help:
CLS 2
COLOR 4
LOCATE 21, 2: PRINT "F2:Save  ³ SPACE: This activates the FlowDraw option, which draws the chosen"
LOCATE 22, 2: PRINT "F3:Load  ³ tile while moving. Press SPACE again to end FlowDraw. REMARK: While"
LOCATE 23, 2: PRINT "ESC:Quit ³ saving, you can enter a remark which will show during the game..."
COLOR 12                                        '";:color 12:print"
LOCATE 24, 2: PRINT "F4:Note  "; : COLOR 4: PRINT "³ Loading: '0' loads a water-world, and '00' loads a wall-border."

e$ = INPUT$(1)
CLS 2
GOSUB prinfo
RETURN

note:
CLS 2
COLOR 4: LOCATE 21, 2: PRINT "Hi, dear user!                                     ³"
COLOR 4: LOCATE 22, 2: PRINT "Hecatomb should be a continually evolving game, so ³"; : COLOR 12: PRINT "  PhilBY Productions "
COLOR 4: LOCATE 23, 2: PRINT "if you've created some really wicked levels, print ³"; : COLOR 12: PRINT "     Schilsweg 83    "
COLOR 4: LOCATE 24, 2: PRINT "them out with F11 and send them to "; : COLOR 12: PRINT ">>>ÄÄÄÄÄÄÄÄÄÄÄÄ>"; : COLOR 4: PRINT "³"; : COLOR 12: PRINT " 4700 Eupen   BELGIUM"

COLOR 12                                        '";:color 12:print"

e$ = INPUT$(1)
CLS 2
GOSUB prinfo
RETURN

code:
CLS 2
LOCATE 21, 2: PRINT "If you CRACK the code, you'll be able to save and load levels as HECAn%.LVL"
LOCATE 22, 2: PRINT "instead of OWNn%.LVL... (but you'll never find it!)"
LOCATE 23, 2
INPUT "ENTER CODE: "; code$
IF code$ = switch$ THEN
	PLAY "o3 t200 l16 cdefgab"
	IF filemain$ = "HECA2" THEN
		filemain$ = "OWN"
	ELSE
		filemain$ = "HECA2"
	END IF
ELSE
	PLAY "o3 t200 l16 bagfedc"
END IF
GOSUB prinfo
RETURN

loadscript:
DIM lines$(35)
OPEN "sleek.fnt" FOR INPUT AS #1
    FOR f = 1 TO 35
	INPUT #1, letter$, lines$(f)
    NEXT
CLOSE
RETURN

intro:
	CLS

	speedfak = 4


	text$ = "PhilBY Productions"
	faty = 1: fatx = 1: xt = 235: yt = 70: col$ = "4": stretch$ = "4": GOSUB typetext
	text$ = "level editor"
	faty = 4: fatx = 4: xt = 210: yt = 260: col$ = "4": stretch$ = "8": GOSUB typetext
	text$ = "level editor"
	faty = 2: fatx = 2: xt = 210: yt = 260: col$ = "12": stretch$ = "8": GOSUB typetext

	xausr = 10
	yausr = 80
	stretch = 1.75
	square = 50
	i = 1
	DO WHILE INKEY$ = "" AND square <> 0
		square = square - 1
		i = i + .3
		FOR t = 1 TO 50 * i
			x = INT(RND * 355 + 1)
			y = INT(RND * 45 + 1)
			LINE (x * stretch + xausr, y * stretch + yausr)-(x * stretch + xausr + square, y * stretch + yausr + square), title(x, y), BF
		NEXT
	LOOP
	IF square = 0 THEN r$ = INPUT$(1)
	CLS
RETURN

typetext:
FOR xtf = 1 TO fatx
FOR ytf = 1 TO faty
PSET (xt - 1 + xtf, yt - 1 + ytf), 0
DRAW "ta" + angle$ + "s" + stretch$ + "c" + col$
FOR tt = 1 TO LEN(text$)
	IF ASC(MID$(text$, tt, 1)) >= 65 AND ASC(MID$(text$, tt, 1)) <= 90 THEN MID$(text$, tt, 1) = CHR$(ASC(MID$(text$, tt, 1)) + 32)
	SELECT CASE MID$(text$, tt, 1)
		CASE " "
			DRAW lines$(27)
		CASE ","
			DRAW lines$(28)
		CASE "."
			DRAW lines$(29)
		CASE "?"
			DRAW lines$(30)
		CASE "!"
			DRAW lines$(31)
		CASE "'"
			DRAW lines$(32)
		CASE "-"
			DRAW lines$(33)
		CASE "("
			DRAW lines$(34)
		CASE ")"
			DRAW lines$(35)
		CASE ELSE
			DRAW lines$(ASC(MID$(text$, tt, 1)) - 96)
	END SELECT
NEXT
NEXT ytf
NEXT xtf

RETURN

cutout:
	pix = 319
	piy = 143
	PRINT "SAVE"
	INPUT "Name of file"; nam$
	PRINT "Are you sure (y/n)": sure$ = INPUT$(1)
	IF sure$ <> "y" AND sure$ <> "n" THEN GOTO cutout

	IF sure$ = "n" THEN RETURN

	IF sure$ = "y" THEN
		PRINT "Saving in "; nam$; ".phg..."

		OPEN nam$ + ".phg" FOR OUTPUT AS #1
			WRITE #1, pix
			WRITE #1, piy
			FOR cx = 1 TO pix
				FOR cy = 1 TO piy
					WRITE #1, POINT(cx, cy)
				NEXT
			NEXT
		CLOSE
	END IF
RETURN

printlevel:
	'pcopy 0,1
	SCREEN 9, 0, 1
	VIEW PRINT 1 TO 25
	CLS
	text$ = "Is your Printer ready?"
	xpready = 110
	ypready = 100
	faty = 9: fatx = 9: xt = xpready: yt = ypready: col$ = "4": stretch$ = "8": GOSUB typetext
	faty = 5: fatx = 5: xt = xpready + 2: yt = ypready + 2: col$ = "12": stretch$ = "8": GOSUB typetext
	faty = 1: fatx = 1: xt = xpready + 4: yt = ypready + 4: col$ = "15": stretch$ = "8": GOSUB typetext
	text$ = " (y-n)"
	xpready = 245
	ypready = 150
	faty = 9: fatx = 9: xt = xpready: yt = ypready: col$ = "4": stretch$ = "8": GOSUB typetext
	faty = 5: fatx = 5: xt = xpready + 2: yt = ypready + 2: col$ = "12": stretch$ = "8": GOSUB typetext
	faty = 1: fatx = 1: xt = xpready + 4: yt = ypready + 4: col$ = "15": stretch$ = "8": GOSUB typetext
	DO
		pready$ = INPUT$(1)
	LOOP UNTIL pready$ = "y" OR pready$ = "n"
	IF pready$ = "n" THEN GOTO exitnoprint
'        locate 12
'        PRINT "   ÚÄÄÄÄÄ¿"
'        PRINT "  Ú´--- -Ã¿"
'        PRINT "ÚÄÁ´- ---ÃÁÄ¿"
'        PRINT "³  ÁÄÄÄÄÄÁ  ³"
'        PRINT "ÃÄÄÄÄÄÄÄÄÄÄÄ´"
'        PRINT "³ ÚÄÄÄÄÄÄÄ¿ ³"
'        PRINT "³ ÀÄÄÄÄÄÄÄÙ ³"
'        PRINT "ÀÄÄÄÄÄÄÄÄÄÄÄÙ"
	r$ = INPUT$(1)
	FOR yprint = 1 TO ymax
		text$ = ""
		FOR xprint = 1 TO xmax
			chara$ = STR$(feld(xprint, yprint))
			SELECT CASE chara$
				CASE " 55": chara$ = "°"
				CASE " 66": chara$ = "^"
				CASE " 99": chara$ = "$"
				CASE " 88": chara$ = "!"
				CASE " 222": chara$ = "."
				CASE " 3.5": chara$ = "N"
				CASE " 1.1": chara$ = "&"
				CASE " 4.5": chara$ = "*"
				CASE " 5.5": chara$ = "œ"
				CASE " 333": chara$ = "²"
				CASE " 1.5": chara$ = "X"
				CASE " 2222": chara$ = "P"
				CASE " 3333": chara$ = "±"
				CASE " 3.3": chara$ = "“"
				CASE " 600": chara$ = "I"

				CASE " 2": chara$ = "Û"
				CASE " 0": chara$ = " "
				CASE " 9": chara$ = CHR$(15)
				CASE " 6": chara$ = "¸"
				CASE " 7": chara$ = "#"
				CASE " 8": chara$ = CHR$(24)
				CASE " 1": chara$ = "ð"

				CASE ELSE: chara$ = MID$(chara$, 2, 1)
			END SELECT
			text$ = text$ + chara$
		NEXT
		LPRINT text$
	NEXT
exitnoprint:
	PCOPY 0, 1
	SCREEN 9, 1, 0
	VIEW PRINT 21 TO 25
RETURN

