ON ERROR GOTO fehler

user$ = "MARTIN HENKES"

SCREEN 9

'Computer Speed
'+++++++++++++++++++++++++++++++++++++++
elaps = 0
CLS
oldtimer = TIMER
DO UNTIL currtimer >= 1
currtimer = TIMER - oldtimer
elaps = elaps + 1
LOOP

speedfaktor = elaps / 7500
speedsave = speedfaktor
'+++++++++++++++++++++++++++++++++++++++


OPEN "max.lvl" FOR INPUT AS #1
INPUT #1, maxlevel
CLOSE

waittime = 500000
slimerate = 5
endemal = 0
big = 11
xpic = 11
ypic = 11

CLS
picture$ = "dont.phg": dpx = 530: dpy = 331: ex = 1: re = 1: GOSUB showpic
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

REDIM monfor(xpic, ypic)
REDIM mo6ed(xpic, ypic)
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
REDIM mowall(xpic, ypic)
REDIM blood(xpic, ypic)
REDIM youw(xpic, ypic)
REDIM water(xpic, ypic)
REDIM wblood(xpic, ypic)
REDIM wmonst(xpic, ypic)
REDIM money(xpic, ypic)
REDIM dagger(xpic, ypic)
REDIM bones(xpic, ypic)
REDIM soil(xpic, ypic)
REDIM zisch2(xpic, ypic)
REDIM rock(xpic, ypic)
REDIM rockc(4, 4)
REDIM wide(350, 40)
REDIM title(355, 45)

REDIM diffspeed(3, 2)
diffspeed(1, 1) = 15000
diffspeed(2, 1) = 8000
diffspeed(3, 1) = 4000

diffspeed(1, 2) = 8000
diffspeed(2, 2) = 5000
diffspeed(3, 2) = 3000

GOSUB loadpics

OPEN "options.dat" FOR INPUT AS #1
INPUT #1, diff
INPUT #1, megablood
CLOSE


'goto infohelp '* * * * * * *

'UUUU
CLS
GOSUB userid
CLS
GOSUB philbypresents
CLS
intr = 0
GOSUB intro
cls
gosub infocredits '* * * * * * *

KEY 1, "I"
KEY 2, "N"
KEY 3, "G"
KEY 5, "O"

anf:
score = 0
oldscore = 0
t = t + 1
IF t > 1 THEN CLS
GOSUB titlepage


xmax = 58
ymax = 25
xdrs = 0
ydrs = 0


'////////////////////////////////////////////////////////////////////////////
restart:

REDIM feld(xmax, ymax)

loading:

OPEN "own" + filist$ + ".lvl" FOR INPUT AS #1
INPUT #1, remark$
INPUT #1, xmax, ymax
FOR xx = 1 TO xmax
	FOR yy = 1 TO ymax
		INPUT #1, feld(xx, yy)
	NEXT
NEXT
CLOSE

newparams:
x = 0
y = 0
daggers = 0
spears = 0
clef = 0

REDIM visib(xmax, ymax)
FOR vnx = 1 TO xmax
	FOR vny = 1 TO ymax
		IF diff = 3 THEN visib(vnx, vny) = 0 ELSE visib(vnx, vny) = 1
	NEXT
NEXT

params:

score = 0

speedfaktor = speedsave
freeze = 0
s = 0
burst = 0
scr = 1
crumb = 0
wmove = 0
momove = 0
count = 0
badmontim = 10
seedark = 1
bactim = 0
bactimes = 10
killbac = 0
speax = 26.5
clex = 27.5
monspeed = diffspeed(diff, 1)
wspeed = diffspeed(diff, 2)
fishspeed = 10

IF (x = 0) AND (y = 0) THEN
	FOR xx = 1 TO xmax
	FOR yy = 1 TO ymax
		IF feld(xx, yy) = 1.5 THEN x = xx: y = yy: found = 1: GOTO st
	NEXT
	NEXT
ELSE
	found = 1
END IF

st:
CLS
CLS 2
IF found = 0 THEN GOTO anf
'Draw Objects
FOR dry = 1 TO ymax
	FOR drx = 1 TO xmax
		IF feld(drx, dry) = 1.1 THEN what = 0: GOSUB drawobjs
		IF level >= 15 THEN
			IF feld(drx, dry) = 99 THEN
				badmon = INT(RND * badmontim + 1)
				IF badmon = 1 THEN feld(drx, dry) = 5.5
			END IF
		END IF
		what = feld(drx, dry)
		GOSUB drawobjs
	NEXT
NEXT

GOSUB drawdark

drx = x
dry = y
IF feld(x, y) = 55 THEN what = 33 ELSE what = 11
GOSUB drawobjs

'Count monsters
FOR xfi = 1 TO xmax
	FOR yfi = 1 TO ymax
		IF feld(xfi, yfi) > 2 THEN count = count + 1
	NEXT
NEXT

REDIM monst(count, 3)
count = 0

'Locate monsters
FOR xfi = 1 TO xmax
	FOR yfi = 1 TO ymax
		IF (feld(xfi, yfi) > 2 AND feld(xfi, yfi) < 6) OR feld(xfi, yfi) = 66 THEN
			count = count + 1
			monst(count, 1) = xfi
			monst(count, 2) = yfi
			monst(count, 3) = feld(xfi, yfi)
		END IF
	NEXT
NEXT

VIEW PRINT 21 TO 25
COLOR 4
LOCATE 21, 1
PRINT "'"; remark$; "'"
LOCATE 22, 1
PRINT "KNOW A CODE? (NO CODE IS <ENTER>)    Press F2 to save game during play..."
code1$ = "ten throw"
code2$ = "open sesame"
code3$ = "grand finale"
code4$ = "yohoho"
code5$ = "shark soup"
code6$ = "acid snot"
code7$ = "N"
code8$ = "wimpey"
code9$ = "see the dark"
code10$ = "trace the dark"
code11$ = "freeze all"
code12$ = "whizz"

code:
INPUT code$
IF code$ = code1$ THEN PLAY "t150 l50 o2 cdefga l25 b": spears = 10: scr = scr / 2: PRINT "Next Code"; : GOTO code
IF code$ = code2$ THEN PLAY "t150 l50 o2 cdefga l25 b": clef = 10: scr = scr / 2: PRINT "Next Code"; : GOTO code
IF code$ = code3$ THEN PLAY "t150 l50 o2 cdefga l25 b": level = maxlevel - 1: GOSUB startnew
IF code$ = code4$ THEN
	PLAY "t150 l50 o2 cdefga l25 b"
	INPUT "Jump to which level"; level
	IF level = 0 OR level > maxlevel THEN
		PRINT "There is no such level..."
		m$ = INPUT$(1)
		GOSUB cb
		COLOR 4
		GOTO startloop
	ELSE
		level = level - 1
		GOSUB startnew
	END IF
END IF
IF code$ = code5$ THEN PLAY "t150 l50 o2 cdefga l25 b": daggers = 10: scr = scr / 2: PRINT "Next Code"; : GOTO code
IF code$ = code6$ THEN PLAY "t150 l50 o2 cdefga l25 b": killbac = 1: scr = scr / 2: PRINT "Next Code"; : GOTO code
IF code$ = code7$ THEN PLAY "t150 l50 o2 cdefga l25 b": GOSUB savegame: PRINT "Next Code"; : GOTO code
IF code$ = code8$ THEN PLAY "t150 l50 o2 cdefga l25 b": clef = 10: spears = 10: daggers = 10: killbac = 1: seedark = 1: scr = 0: PRINT "Next Code"; : GOTO code
IF code$ = code10$ THEN PLAY "t150 l50 o2 cdefga l25 b": crumb = 1: PRINT "Next Code"; : GOTO code
IF code$ = code9$ THEN
	PLAY "t150 l50 o2 cdefga l25 b"
	'Draw Objects whith invisible walls
	FOR dry = 1 TO ymax
		FOR drx = 1 TO xmax
			IF feld(drx, dry) = 222 THEN what = 22.22: feld(drx, dry)=22.22: GOSUB drawobjs
		NEXT
	NEXT
	drx = x
	dry = y
	what = 11
	GOSUB drawobjs
	scr = scr / 2
	PRINT "Next Code";
	GOTO code
END IF
IF code$ = code11$ THEN PLAY "t150 l50 o2 cdefga l25 b": freeze = 1: PRINT "Next Code"; : GOTO code
IF code$ = code12$ THEN PLAY "t150 l50 o2 cdefga l25 b": speedfaktor = 0: PRINT "Next Code"; : GOTO code

PLAY "t150 l50 o2 bagfed l25 c"
GOTO codecont


codecont:

GOSUB cb
COLOR 4



startloop:

s = s + 1
IF s = 1 THEN GOSUB prspear: GOSUB prdagg: GOSUB prclef: GOSUB prscore

IF freeze <> 1 THEN
	wmove = wmove + 1
	momove = momove + 1
	fishmove = fishmove + 1
END IF


IF fishmove >= fishspeed * speedfaktor THEN
	drx = INT(RND * xmax + 1)
	dry = INT(RND * ymax + 1)
	IF feld(drx, dry) = 600 THEN what = 600: GOSUB drawobjs
	fishmove = 0
END IF


IF wmove >= wspeed * speedfaktor THEN
'UUUU
'print wspeed * speedfaktor,wmove

FOR mo = 1 TO count
IF monst(mo, 3) = 66 THEN
  drx = monst(mo, 1)
  dry = monst(mo, 2)
  oldmox = drx
  oldmoy = dry
  xmo = drx
  ymo = dry
  direc = INT(RND * 2)
  IF direc = 0 AND xmo > 1 AND xmo < xmax THEN
    IF xmo > x AND (feld(xmo - 1, ymo) = 55 OR feld(xmo - 1, ymo) = 77) THEN
      feld(xmo, ymo) = 55
      xmo = xmo - 1
      ymo = ymo
      feld(xmo, ymo) = monst(mo, 3)
    END IF
    IF xmo < x AND (feld(xmo + 1, ymo) = 55 OR feld(xmo + 1, ymo) = 77) THEN
      feld(xmo, ymo) = 55
      xmo = xmo + 1
      ymo = ymo
      feld(xmo, ymo) = monst(mo, 3)
    END IF
  END IF

  IF direc = 1 AND ymo > 1 AND ymo < ymax THEN
    IF ymo > y AND (feld(xmo, ymo - 1) = 55 OR feld(xmo, ymo - 1) = 77) THEN
      feld(xmo, ymo) = 55
      xmo = xmo
      ymo = ymo - 1
      feld(xmo, ymo) = monst(mo, 3)
    END IF
    IF ymo < y AND (feld(xmo, ymo + 1) = 55 OR feld(xmo, ymo + 1) = 77) THEN
      feld(xmo, ymo) = 55
      xmo = xmo
      ymo = ymo + 1
      feld(xmo, ymo) = monst(mo, 3)
    END IF
  END IF

  'new coords
  monst(mo, 1) = xmo
  monst(mo, 2) = ymo

  drx = xmo
  dry = ymo
  IF (drx <> oldmox) OR (dry <> oldmoy) THEN
	what = monst(mo, 3)
	GOSUB drawobjs
	drx = oldmox
	dry = oldmoy
	what = 55
	GOSUB drawobjs
  ELSE
	what = monst(mo, 3)
	GOSUB drawobjs
  END IF
  IF monst(mo, 1) = x AND monst(mo, 2) = y THEN
    IF daggers <> 0 THEN
      monst(mo, 1) = 0
      monst(mo, 2) = 0
      monst(mo, 3) = 0
      daggers = daggers - 1
      GOSUB prdagg
      w = 1
      GOSUB meblood
      GOSUB burst
      PLAY "mbmbmbmb o1 t200 l50 cdecedc"
      score = score + (500 * scr)
      GOSUB prscore
    ELSE
      waterkill=1
      gosub gotkilled
      GOTO anf
  END IF
  END IF

END IF
NEXT
wmove = 0
END IF

IF momove >= monspeed * speedfaktor THEN
FOR mo = 1 TO count
IF monst(mo, 3) <> 66 AND monst(mo, 3) <> 5.5 THEN
  trace = INT(RND * slimerate + 1)
  oldmox = monst(mo, 1)
  oldmoy = monst(mo, 2)
  xmo = oldmox
  ymo = oldmoy
  direc = INT(RND * 2)
  IF direc = 0 AND xmo > 1 AND xmo < xmax THEN
    IF xmo > x AND (feld(xmo - 1, ymo) = 0 OR feld(xmo - 1, ymo) = 22 OR feld(xmo - 1, ymo) = 4.5) THEN
      IF trace = 1 AND monst(mo, 3) = 4.5 THEN feld(xmo, ymo) = 4.5 ELSE feld(xmo, ymo) = 0
      xmo = xmo - 1
      ymo = ymo
      feld(xmo, ymo) = monst(mo, 3)
    END IF
    IF xmo < x AND (feld(xmo + 1, ymo) = 0 OR feld(xmo + 1, ymo) = 22 OR feld(xmo + 1, ymo) = 4.5) THEN
      IF trace = 1 AND monst(mo, 3) = 4.5 THEN feld(xmo, ymo) = 4.5 ELSE feld(xmo, ymo) = 0
      xmo = xmo + 1
      ymo = ymo
      feld(xmo, ymo) = monst(mo, 3)
    END IF
  END IF

  IF direc = 1 AND ymo > 1 AND ymo < ymax THEN
    IF ymo > y AND (feld(xmo, ymo - 1) = 0 OR feld(xmo, ymo - 1) = 22) OR feld(xmo, ymo - 1) = 4.5 THEN
      IF trace = 1 AND monst(mo, 3) = 4.5 THEN feld(xmo, ymo) = 4.5 ELSE feld(xmo, ymo) = 0
      xmo = xmo
      ymo = ymo - 1
      feld(xmo, ymo) = monst(mo, 3)
    END IF
    IF ymo < y AND (feld(xmo, ymo + 1) = 0 OR feld(xmo, ymo + 1) = 22 OR feld(xmo, ymo + 1) = 4.5) THEN
      IF trace = 1 AND monst(mo, 3) = 4.5 THEN feld(xmo, ymo) = 4.5 ELSE feld(xmo, ymo) = 0
      xmo = xmo
      ymo = ymo + 1
      feld(xmo, ymo) = monst(mo, 3)
    END IF
  END IF

  'new coords
  monst(mo, 1) = xmo
  monst(mo, 2) = ymo

  IF (xmo = oldmox) AND (ymo = oldmoy) AND monst(mo, 3) = 4.5 THEN
	drx = xmo
	dry = ymo
	what = monst(mo, 3)
	GOSUB drawobjs
  END IF
  IF (xmo <> oldmox) OR (ymo <> oldmoy) THEN
	drx = oldmox
	dry = oldmoy
	IF (trace = 1) AND monst(mo, 3) = 4.5 THEN what = 4.5 ELSE what = 0
	what = 0
	GOSUB drawobjs
	drx = xmo
	dry = ymo
	what = monst(mo, 3)
	GOSUB drawobjs
  END IF

IF monst(mo, 1) = x AND monst(mo, 2) = y THEN
  IF monst(mo, 3) <> 4.5 THEN
	IF spears <> 0 THEN
		monst(mo, 1) = 0
		monst(mo, 2) = 0
		monst(mo, 3) = 0
		spears = spears - 1
		GOSUB prspear
		w = 0
		GOSUB meblood
		GOSUB burst
		PLAY "mbmbmbmb o1 t200 l50 cdecedc"
		score = score + (500 * scr)
		GOSUB prscore
	ELSE
		waterkill=0
		gosub gotkilled
		GOTO anf
	END IF
  ELSE
	IF killbac <> 0 THEN
		score = score - (100 * scr)
		PLAY "mbmbmbmb t200 l50 o3 bagfed l 25 c"
		GOSUB prscore
	ELSE
		score = score - (1000 * scr)
		PLAY "mbmbmbmb t200 l50 o3 bagfed l25 c"
		GOSUB prscore
	END IF
 END IF
END IF
END IF

NEXT
momove = 0
END IF

'play "mb t100 l16 o4 c"

r$ = INKEY$
IF r$ = "" THEN GOTO startloop
'----------------------------------------------------------------------------
'quit
IF r$ = CHR$(27) THEN GOTO anf
'----------------------------------------------------------------------------
'restart level
IF r$ = CHR$(13) THEN IF wholegame = 1 THEN GOTO restartnew ELSE GOTO restart
'----------------------------------------------------------------------------
'save level
IF r$ = "N" THEN GOSUB savegame
'======================================= MOVING =============================
'erase
drx = x
dry = y
IF crumb <> 1 THEN
	what = feld(x, y)
	GOSUB drawobjs
ELSE
	what = feld(x, y)
	GOSUB drawobjs
	what = 12.12
	GOSUB drawobjs
END IF
torock = 0
'----------------------------------------------------------------------------
'up
IF r$ = CHR$(0) + CHR$(72) AND y > 1 THEN
	IF feld(x, y - 1) = 222 AND seedark = 1 THEN touch=1: GOSUB drawdark
	IF (feld(x, y) = 202 OR feld(x, y) = 1) AND feld(x, y - 1) = 202 THEN torock = 1
	IF torock = 1 OR (feld(x, y - 1) <> 202 AND feld(x, y - 1) <> 333 AND feld(x, y - 1) <> 2 AND feld(x, y - 1) <> 1.1 AND feld(x, y - 1) <> 222 AND feld(x, y - 1) <> 22.22) THEN
		IF feld(x, y - 1) = 7 THEN
			IF clef <> 0 THEN clef = clef - 1: feld(x, y - 1) = 75: y = y - 1: GOSUB prclef:  ELSE
		ELSE
			y = y - 1
		END IF
	END IF
END IF
'----------------------------------------------------------------------------
'down
IF r$ = CHR$(0) + CHR$(80) AND y < ymax THEN
	IF feld(x, y + 1) = 222 AND seedark = 1 THEN touch=1: GOSUB drawdark
	IF (feld(x, y) = 202 OR feld(x, y) = 1) AND feld(x, y + 1) = 202 THEN torock = 1
	IF torock = 1 OR (feld(x, y + 1) <> 202 AND feld(x, y + 1) <> 333 AND feld(x, y + 1) <> 2 AND feld(x, y + 1) <> 1.1 AND feld(x, y + 1) <> 222 AND feld(x, y + 1) <> 22.22) THEN
		IF feld(x, y + 1) = 7 THEN
			IF clef <> 0 THEN clef = clef - 1: feld(x, y + 1) = 75: y = y + 1: GOSUB prclef:  ELSE
		ELSE
		y = y + 1
		END IF
	END IF
END IF
'----------------------------------------------------------------------------
'left
IF r$ = CHR$(0) + CHR$(75) AND x > 1 THEN
	IF feld(x - 1, y) = 222 AND seedark = 1 THEN touch=1: GOSUB drawdark
	IF (feld(x, y) = 202 OR feld(x, y) = 1) AND feld(x - 1, y) = 202 THEN torock = 1
	IF torock = 1 OR (feld(x - 1, y) <> 202 AND feld(x - 1, y) <> 333 AND feld(x - 1, y) <> 2 AND feld(x - 1, y) <> 1.1 AND feld(x - 1, y) <> 222 AND feld(x - 1, y) <> 22.22) THEN
		IF feld(x - 1, y) = 7 THEN
			IF clef <> 0 THEN clef = clef - 1: feld(x - 1, y) = 75: x = x - 1: GOSUB prclef:  ELSE
		ELSE
		x = x - 1
		END IF
	END IF
END IF
'----------------------------------------------------------------------------
'right
IF r$ = CHR$(0) + CHR$(77) AND x < xmax THEN
	IF feld(x + 1, y) = 222 AND seedark = 1 THEN touch=1: GOSUB drawdark
	IF (feld(x, y) = 202 OR feld(x, y) = 1) AND feld(x + 1, y) = 202 THEN torock = 1
	IF torock = 1 OR (feld(x + 1, y) <> 202 AND feld(x + 1, y) <> 333 AND feld(x + 1, y) <> 2 AND feld(x + 1, y) <> 1.1 AND feld(x + 1, y) <> 222 AND feld(x + 1, y) <> 22.22) THEN
		IF feld(x + 1, y) = 7 THEN
			IF clef <> 0 THEN clef = clef - 1: feld(x + 1, y) = 75: x = x + 1: GOSUB prclef:  ELSE
		ELSE
		x = x + 1
		END IF
	END IF
END IF
'----------------------------------------------------------------------------
'Only for "see dark" option
IF diff = 1 or diff = 3 THEN GOSUB drawdark

drx = x
dry = y
IF feld(x, y) = 55 OR feld(x, y) = 77 THEN what = 33 ELSE what = 11
GOSUB drawobjs
PLAY "mbmbmbmbmb o0 t200 l50 ec"

IF feld(x, y) = 5.5 THEN
	feld(x, y) = 4.5
	FOR monkill = 1 TO count
		IF monst(monkill, 1) = x AND monst(monkill, 2) = y THEN
			monst(monkill, 3) = 4.5
		END IF
	NEXT
END IF
IF feld(x, y) = 99 THEN feld(x, y) = 0: score = score + (500 * scr): GOSUB prscore: GOSUB prscore
IF feld(x, y) = 88 THEN feld(x, y) = 0: daggers = daggers + 1: score = score + (150 * scr): GOSUB prdagg: GOSUB prclef
IF feld(x, y) = 6 THEN feld(x, y) = 0: clef = clef + 1: score = score + (50 * scr): GOSUB prscore: GOSUB prclef
IF feld(x, y) = 8 THEN feld(x, y) = 0: spears = spears + 1: score = score + (100 * scr): GOSUB prscore: GOSUB prspear
IF feld(x, y) = 9 THEN
	PLAY "mbmbmbmb o1 t100 l16 efgefd l8 c"
	O$ = INPUT$(1)
'        GOSUB highcheck
	IF wholegame = 1 THEN GOTO startnew ELSE GOTO anf
END IF

IF feld(x, y) = 600 THEN
  IF spears >= 5 THEN
      FOR spearsminus = 1 TO 5
	spears = spears - 1
	GOSUB prspear
      NEXT
      feld(x, y) = 601
  ELSE
	waterkill=0
	gosub gotkilled
	goto anf
  END IF
END IF

IF feld(x, y) = 4.5 THEN
		IF killbac <> 0 THEN
			score = score - (100 * scr)
			PLAY "mbmbmbmb t200 l50 o3 bge l 25 c"
			GOSUB prscore
		ELSE
			score = score - (1000 * scr)
			PLAY "mbmbmbmb t200 l50 o3 bge l 25 c"
			GOSUB prscore
		END IF
END IF

IF (feld(x, y) > 2 AND feld(x, y) < 6) THEN
  IF feld(x, y) <> 4.5 THEN
	IF spears <> 0 THEN
		w = 0
		spears = spears - 1
		GOSUB prspear
		GOSUB meblood
		GOSUB burst
		FOR monkill = 1 TO count
			IF monst(monkill, 1) = x AND monst(monkill, 2) = y THEN
				monst(monkill, 1) = 0
				monst(monkill, 2) = 0
				monst(monkill, 3) = 0
			END IF
		NEXT
		feld(x, y) = 22
		PLAY "mbmbmbmb o1 t200 l50 cdecedc"
		score = score + (500 * scr)
		GOSUB prscore
	ELSE
		waterkill=0
		gosub gotkilled
		goto anf
	END IF
  END IF
END IF

  IF feld(x, y) = 66 THEN
    IF daggers <> 0 THEN
      feld(x, y) = 77: w = 1
      daggers = daggers - 1
      GOSUB prdagg
      GOSUB meblood
      GOSUB burst
      FOR monkill = 1 TO count
	IF monst(monkill, 1) = x AND monst(monkill, 2) = y THEN
	  monst(monkill, 1) = 0
	  monst(monkill, 2) = 0
	  monst(monkill, 3) = 0
	END IF
      NEXT
      PLAY "mbmbmbmb o1 t200 l50 cdecedc"
      score = score + (500 * scr)
      GOSUB prscore
    ELSE
      waterkill=1
      gosub gotkilled
      goto anf
    END IF
  END IF


GOTO startloop
END

'****************************************************************************
drawobjs:
'Only if visible
IF visib(drx, dry) = 1 OR mebloodopt = 1 THEN

SELECT CASE what

CASE 0
	IF diff = 3 THEN
		PUT ((drx * big) - big + 1, (dry * big) - big + 1), soil, PSET
	ELSE
		LINE ((drx * big) - big + 1, (dry * big) - big + 1)-((drx * big), (dry * big)), 0, BF
	END IF
	IF mebloodopt = 1 THEN LINE ((drx * big) - big + 1, (dry * big) - big + 1)-((drx * big), (dry * big)), 0, BF
CASE 1
PUT ((drx * big) - big + 1, (dry * big) - big + 1), start, PSET
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
CASE 75
PUT ((drx * big) - big + 1, (dry * big) - big + 1), gateo, PSET
CASE 8
PUT ((drx * big) - big + 1, (dry * big) - big + 1), spear, PSET
CASE 9
PUT ((drx * big) - big + 1, (dry * big) - big + 1), goal, PSET
CASE 11
FOR xxp = 1 TO 11
	FOR yyp = 1 TO 11
		IF you(xxp, yyp) <> 0 THEN PSET ((drx * big) - big + xxp, (dry * big) - big + yyp), you(xxp, yyp)
	NEXT
NEXT
'PUT ((drx * big) - big +1, (dry * big) - big +1), you, pset
CASE 22
PUT ((drx * big) - big + 1, (dry * big) - big + 1), blood, PSET
	FOR slime = 1 TO 20
		xslm = INT(RND * 11)
		yslm = INT(RND * 11)
		xslm = (drx * big) - big + 1 + xslm
		yslm = (dry * big) - big + 1 + yslm
		LINE (xslm,yslm)-(xslm,yslm), 4,BF
	NEXT
CASE 55
PUT ((drx * big) - big + 1, (dry * big) - big + 1), water, PSET
CASE 33
PUT ((drx * big) - big + 1, (dry * big) - big + 1), youw, PSET
CASE 66
PUT ((drx * big) - big + 1, (dry * big) - big + 1), wmonst, PSET
CASE 77
PUT ((drx * big) - big + 1, (dry * big) - big + 1), wblood, PSET
CASE 88
PUT ((drx * big) - big + 1, (dry * big) - big + 1), dagger, PSET
CASE 99
PUT ((drx * big) - big + 1, (dry * big) - big + 1), money, PSET
CASE 222
if diff<>3 then
	LINE ((drx * big) - big + 1, (dry * big) - big + 1)-((drx * big), (dry * big)), 0, BF
else
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), soil, PSET
end if
CASE 3.5
PUT ((drx * big) - big + 1, (dry * big) - big + 1), mowall, PSET
CASE 22.22
PUT ((drx * big) - big + 1, (dry * big) - big + 1), mo6ed, PSET
CASE 12.12
PSET ((drx * big) - big + big / 2, (dry * big) - big + big / 2), 8
CASE 4.5
LINE ((drx * big) - big + 1, (dry * big) - big + 1)-((drx * big), (dry * big)), 0, BF
	FOR slime = 1 TO 5
		xslm = INT(RND * 11)
		yslm = INT(RND * 11)
		PSET ((drx * big) - big + 1 + xslm, (dry * big) - big + 1 + yslm), 10
	NEXT
	FOR slime = 1 TO 5
		xslm = INT(RND * 11)
		yslm = INT(RND * 11)
		PSET ((drx * big) - big + 1 + xslm, (dry * big) - big + 1 + yslm), 9
	NEXT
CASE 1.1
FOR xxp = 1 TO 11
	FOR yyp = 1 TO 11
		IF bones(xxp, yyp) <> 0 THEN PSET ((drx * big) - big + xxp, (dry * big) - big + yyp), bones(xxp, yyp)
	NEXT
NEXT
CASE 5.5
PUT ((drx * big) - big + 1, (dry * big) - big + 1), money, PSET
	PSET ((drx * big) - (big / 2) + 1, (dry * big) - (big / 2) + 2), 6
	PSET ((drx * big) - (big / 2), (dry * big) - (big / 2) + 1), 6
	PSET ((drx * big) - (big / 2) - 1, (dry * big) - (big / 2) + 2), 6
	PSET ((drx * big) - (big / 2) + 1, (dry * big) - (big / 2) + 3), 6
	PSET ((drx * big) - (big / 2), (dry * big) - (big / 2) + 2), 6
	PSET ((drx * big) - (big / 2) - 1, (dry * big) - (big / 2) + 3), 6

	PSET ((drx * big) - (big / 2), (dry * big) - (big / 2) + 2), 14
	PSET ((drx * big) - (big / 2) + 1, (dry * big) - (big / 2) + 3), 14
	PSET ((drx * big) - (big / 2), (dry * big) - (big / 2) + 4), 14
	PSET ((drx * big) - (big / 2), (dry * big) - (big / 2) + 3), 14
	PSET ((drx * big) - (big / 2) - 1, (dry * big) - (big / 2) + 3), 14
CASE 333
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
		PSET ((drx * big) - big + 1 + xslm, (dry * big) - big + 1 + yslm), 4
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
		PSET ((drx * big) - big + 1 + xslm, (dry * big) - big + 1 + yslm), 4
	NEXT
CASE 1.5
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), start, PSET
	xi = drx * big
	yi = dry * big
	spac = 3
	LINE (xi - spac, yi - big + spac)-(xi - big + spac, yi - spac), 14
	LINE (xi - big + spac, yi - big + spac)-(xi - spac, yi - spac), 14
CASE 2222
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), wall, PSET
	FOR slime = 1 TO 20
		xslm = INT(RND * 11)
		yslm = INT(RND * 11)
		PSET ((drx * big) - big + 1 + xslm, (dry * big) - big + 1 + yslm), 0
	NEXT
CASE 3333
	LINE ((drx * big) - big + 1, (dry * big) - big + 1)-((drx * big), (dry * big)), 0, BF
	FOR slime = 1 TO 10
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
CASE 600
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), water, PSET
	FOR slime = 1 TO 10
		xslm = INT(RND * 11)
		yslm = INT(RND * 11)
		PSET ((drx * big) - big + 1 + xslm, (dry * big) - big + 1 + yslm), 12
	NEXT
CASE 601
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), zisch2, PSET
CASE 202
'DrawRock
	PUT ((drx * big) - big + 1, (dry * big) - big + 1), rock, PSET
CASE ELSE
END SELECT

ELSE
	'Draw Dark Color
	'LINE ((drx * big) - big + 1, (dry * big) - big + 1)-((drx * big), (dry * big)), 0, BF
END IF

RETURN

'drawcorners:
'SELECT CASE rd$
'        CASE "tl"
'                rdxs=1: rdxe=2: rdys=1: rdye=2
'        CASE "tr"
'                rdxs=10: rdxe=11: rdys=1: rdye=2
'        CASE "bl"
'                rdxs=1: rdxe=2: rdys=10: rdye=11
'        CASE "br"
'                rdxs=10: rdxe=11: rdys=10: rdye=11
'        CASE ELSE
'END SELECT
'
'line ((drx * big)-big + rdxs,(dry * big)-big + rdys)-((drx * big)-big + rdxe,(dry * big)-big + rdye),0,BF
'
'RETURN

'((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
loadpics:

FOR loapic = 1 TO 27
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
file$ = "mon6.phg"
CASE 13
file$ = "blood.phg"
CASE 14
file$ = "wide.phg"
CASE 15
file$ = "title.phg"
CASE 16
file$ = "youw.phg"
CASE 17
file$ = "water.phg"
CASE 18
file$ = "wbloo.phg"
CASE 19
file$ = "wmons.phg"
CASE 20
file$ = "daggr.phg"
CASE 21
file$ = "money.phg"
CASE 22
file$ = "bones.phg"
CASE 23
file$ = "mo6ed.phg"
CASE 24
file$ = "soil.phg"
CASE 25
file$ = "zi2.phg"
CASE 26
file$ = "wall4.phg"
CASE 27
file$ = "rock_c.phg"
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
			IF loapic = 12 THEN mowall(xxp, yyp) = picdata
			IF loapic = 13 THEN blood(xxp, yyp) = picdata
			IF loapic = 14 THEN wide(xxp, yyp) = picdata
			IF loapic = 15 THEN title(xxp, yyp) = picdata
			IF loapic = 16 THEN youw(xxp, yyp) = picdata
			IF loapic = 17 THEN water(xxp, yyp) = picdata
			IF loapic = 18 THEN wblood(xxp, yyp) = picdata
			IF loapic = 19 THEN wmonst(xxp, yyp) = picdata
			IF loapic = 20 THEN dagger(xxp, yyp) = picdata
			IF loapic = 21 THEN money(xxp, yyp) = picdata
			IF loapic = 22 THEN bones(xxp, yyp) = picdata
			IF loapic = 23 THEN mo6ed(xxp, yyp) = picdata
			IF loapic = 24 THEN soil(xxp, yyp) = picdata
			IF loapic = 25 THEN zisch2(xxp, yyp) = picdata
			IF loapic = 26 THEN rock(xxp, yyp) = picdata
			IF loapic = 27 THEN rockc(xxp, yyp) = picdata
		NEXT yyp
	NEXT xxp
CLOSE
NEXT loapic

'GET objects
CLS
xlp = 315
ylp = 145
FOR show = 2 TO 23
	FOR xxp = 1 TO 11
		FOR yyp = 1 TO 11
'                        IF show = 1 THEN PSET (xxp + xlp, yyp + ylp), you(xxp, yyp)
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
			IF show = 19 THEN PSET (xxp + xlp, yyp + ylp), mowall(xxp, yyp)
			IF show = 20 THEN PSET (xxp + xlp, yyp + ylp), mo6ed(xxp, yyp)
			IF show = 21 THEN PSET (xxp + xlp, yyp + ylp), soil(xxp, yyp)
			IF show = 22 THEN PSET (xxp + xlp, yyp + ylp), zisch2(xxp, yyp)
			IF show = 23 THEN PSET (xxp + xlp, yyp + ylp), rock(xxp, yyp)
		NEXT yyp
	NEXT xxp
't$=input$(1)
'                        IF show = 1 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), you
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
			IF show = 19 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), mowall
			IF show = 20 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), mo6ed
			IF show = 21 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), soil
			IF show = 22 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), zisch2
			IF show = 23 THEN GET (1 + xlp, 1 + ylp)-STEP(11 - 1, 11 - 1), rock
NEXT show
'goto info '* * * * * * *


RETURN
'))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

titlepage:

y = 1
sel = 12

CLS
tinocls:

VIEW PRINT 1 TO 25
wholegame = 0
level = 0
st1 = st1 + 1


IF st1 = 1 THEN
'WIDE
	xdecal = 140
	ydecal = 99
	FOR xxp = 1 TO 350
		FOR yyp = 1 TO 40
			PSET (xxp + xdecal, yyp + ydecal), wide(xxp, yyp)
		NEXT yyp
	NEXT xxp
	GET (xdecal + 1, ydecal + 1)-(xdecal + 350, ydecal + 40), wide
ELSE
	PUT (141, 100), wide, PSET
END IF

REDIM params$(6, 2)

params$(1, 1) = "New Game"
params$(2, 1) = "Restore Game"
params$(3, 1) = "Options"
params$(4, 1) = "Information"
params$(5, 1) = "Play own level"
params$(6, 1) = "Quit Game"

params$(1, 2) = "NEW GAME"
params$(2, 2) = "RESTORE GAME"
params$(3, 2) = "OPTIONS"
params$(4, 2) = "INFORMATION"
params$(5, 2) = "PLAY OWN LEVEL"
params$(6, 2) = "QUIT GAME"

x1 = 240
y1 = 185
x2 = 380
y2 = 320
sfcol = 0
bcol = 4
fcol = 12
GOSUB frame

FOR x = 1 TO 6
text$ = params$(x, 1)
COLOR 4, 0: LOCATE 16 + x, 40 - LEN(text$) / 2 - .5: PRINT text$
NEXT

text$ = "Menu"
COLOR 12: LOCATE 15, 40 - LEN(text$) / 2 - .5: PRINT text$

text$ = params$(y, 2)
COLOR sel: LOCATE 16 + y, 40 - LEN(text$) / 2 - .5: PRINT text$

oi = 0
10 :
DO
	filist$ = INKEY$
	oi = oi + 1
  'TITLE TWINKLE
	box = INT(RND * 3)
	xdecal = 145
	ydecal = 24
	xxp = INT(RND * 355 + 1)
	yyp = INT(RND * 45 + 1)
	LINE (xxp + xdecal, yyp + ydecal)-(xxp + xdecal + box, yyp + ydecal + box), title(xxp, yyp), BF
LOOP WHILE filist$ = ""

'---------------------------------------down menu
IF filist$ = CHR$(0) + CHR$(80) THEN
	COLOR 4, 0
	text$ = params$(y, 1)
	LOCATE 16 + y, 40 - LEN(text$) / 2 - .5: PRINT text$
	y = y + 1
	IF y = 7 THEN y = 1
	COLOR sel, 0
	text$ = params$(y, 2)
	LOCATE 16 + y, 40 - LEN(text$) / 2 - .5: PRINT text$
END IF
'---------------------------------------up menu
IF filist$ = CHR$(0) + CHR$(72) THEN
	COLOR 4, 0
	text$ = params$(y, 1)
	LOCATE 16 + y, 40 - LEN(text$) / 2 - .5: PRINT text$
	y = y - 1
	IF y = 0 THEN y = 6
	COLOR sel, 0
	text$ = params$(y, 2)
	LOCATE 16 + y, 40 - LEN(text$) / 2 - .5: PRINT text$
END IF

IF filist$ = CHR$(13) THEN
	SELECT CASE y
		CASE 1
			GOTO startnew
		CASE 2
			GOTO loadgame
		CASE 3
			GOTO options
		CASE 4
			y = 1: GOTO info
		CASE 5
			x1 = 230
			y1 = 248
			x2 = 390
			y2 = 298
			sfcol = 0
			bcol = 4
			fcol = 14
			GOSUB frame
			text$ = "Number"
			COLOR 12: LOCATE 20, 40 - LEN(text$) / 2 - 1: PRINT text$;
			INPUT filist$
			RETURN
		CASE 6
			GOTO ende
	END SELECT
END IF

GOTO 10
RETURN



cb:
CLS 2
RETURN

prdagg:
mebloodopt = 1
sp = 0
IF daggers = 0 THEN
	drx = 32
	dry = clex
	what = 0
	GOSUB drawobjs
ELSE
	IF daggers < 28 THEN
	FOR sp = 1 TO daggers
	drx = 31 + sp
	dry = clex
	what = 88
	GOSUB drawobjs
	NEXT
	END IF
END IF
	IF daggers < 28 THEN
	sp = sp + 1
	drx = 30 + sp
	dry = clex
	what = 0
	GOSUB drawobjs
	END IF

COLOR 4
LOCATE 22, 36
PRINT "DAGGERS:"
mebloodopt = 0
RETURN

prclef:
mebloodopt = 1
sp = 0
IF clef = 0 THEN
	drx = 6
	dry = clex
	what = 0
	GOSUB drawobjs
ELSE
	IF clef < 20 THEN
	FOR sp = 1 TO clef
	drx = 5 + sp
	dry = clex
	what = 6
	GOSUB drawobjs
	NEXT
	END IF
END IF

	IF clef < 20 THEN
	sp = sp + 1
	drx = 4 + sp
	dry = clex
	what = 0
	GOSUB drawobjs
	END IF

COLOR 4
LOCATE 22, 1
PRINT "  KEYS:"
mebloodopt = 0
RETURN

prscore:
LOCATE 23, 1
PRINT "LEVEL:"; level$; " SCORE:"; score; " TOTAL:"; score + oldscore; " "; remark$
RETURN


prspear:
mebloodopt = 1
sp = 0
IF spears = 0 THEN
	drx = 6
	dry = speax
	what = 0
	GOSUB drawobjs
ELSE
	IF spears < 54 THEN
	FOR sp = 1 TO spears
	drx = 5 + sp
	dry = speax
	what = 8
	GOSUB drawobjs
	NEXT
	END IF
END IF

	IF spears < 54 THEN
	sp = sp + 1
	drx = 4 + sp
	dry = speax
	what = 0
	GOSUB drawobjs
	END IF
COLOR 4
LOCATE 21, 1
PRINT "SPEARS:"
mebloodopt = 0

RETURN

info:

'y = 1
sel = 12

'000000000000000000000000
REDIM params$(5, 2)

params$(1, 1) = "Help"
params$(2, 1) = "Story"
params$(3, 1) = "What's PhilBY?"
params$(4, 1) = "Credits"
params$(5, 1) = "Quit to Main"

params$(1, 2) = "HELP"
params$(2, 2) = "STORY"
params$(3, 2) = "WHAT'S PHILBY?"
params$(4, 2) = "CREDITS"
params$(5, 2) = "QUIT TO MAIN"

	PUT (141, 100), wide, PSET

x1 = 240
y1 = 185
x2 = 380
y2 = 320
sfcol = 0
bcol = 4
fcol = 12
GOSUB frame

FOR x = 1 TO 5
text$ = params$(x, 1)
COLOR 4, 0: LOCATE 16 + x, 40 - LEN(text$) / 2 - .5: PRINT text$
NEXT

text$ = "Menu"
COLOR 12: LOCATE 15, 40 - LEN(text$) / 2 - .5: PRINT text$

text$ = params$(y, 2)
COLOR sel: LOCATE 16 + y, 40 - LEN(text$) / 2 - .5: PRINT text$

oi = 0
100 :
DO
	filist$ = INKEY$
	oi = oi + 1
   'TITLE TWINKLE
	box = 2
	xdecal = 160
	ydecal = 24
	xxp = INT(RND * 355 + 1)
	yyp = INT(RND * 45 + 1)
	LINE (xxp + xdecal, yyp + ydecal)-(xxp + xdecal + box, yyp + ydecal + box), title(xxp, yyp), BF
LOOP WHILE filist$ = ""

'---------------------------------------down menu
IF filist$ = CHR$(0) + CHR$(80) THEN
	COLOR 4, 0
	text$ = params$(y, 1)
	LOCATE 16 + y, 40 - LEN(text$) / 2 - .5: PRINT text$
	y = y + 1
	IF y = 6 THEN y = 1
	COLOR sel, 0
	text$ = params$(y, 2)
	LOCATE 16 + y, 40 - LEN(text$) / 2 - .5: PRINT text$
END IF
'---------------------------------------up menu
IF filist$ = CHR$(0) + CHR$(72) THEN
	COLOR 4, 0
	text$ = params$(y, 1)
	LOCATE 16 + y, 40 - LEN(text$) / 2 - .5: PRINT text$
	y = y - 1
	IF y = 0 THEN y = 5
	COLOR sel, 0
	text$ = params$(y, 2)
	LOCATE 16 + y, 40 - LEN(text$) / 2 - .5: PRINT text$
END IF

IF filist$ = CHR$(13) THEN
	SELECT CASE y
		CASE 1
			GOTO infohelp
		CASE 2
			GOTO infostory
		CASE 3
			GOTO infophilby
		CASE 4
			GOsub infocredits
			GOTO info
		CASE 5
			y = y - 1: GOTO tinocls
	END SELECT
END IF

'000000000000000000000000

GOTO 100

infohelp:
CLS
PUT (145, 1), wide, PSET '* * * * * * * * * *
text$ = "HECATOMB": COLOR 14: LOCATE 5, 40 - LEN(text$) / 2: PRINT text$
text$ = "Full Version by PhilBY": COLOR 4: LOCATE 6, 40 - LEN(text$) / 2: PRINT text$
text$ = "H..H..HEEEELP File": COLOR 12: LOCATE 8, 40 - LEN(text$) / 2: PRINT text$
LOCATE 10
PRINT TAB(22); "YOU: this is you, an explorer out to find"
PRINT TAB(22); "     the big mazuma."
PRINT TAB(22); "START: you start your adventure here."
PRINT TAB(22); "FINISH: if you get here alive, this brings"
PRINT TAB(22); "        you to the next level."
PRINT TAB(22); "WALL: solid stone, can't be destroyed."
PRINT TAB(22); "DOOR: can only be opened with a key."
PRINT TAB(22); "KEY: collect these to open doors."
PRINT TAB(22); "WATER: you can wade through this."
PRINT TAB(22); "SPEAR: this can be very useful to kill"
PRINT TAB(22); "       monsters."
PRINT TAB(22); "MONSTERS: you don't want to mess with them,"
PRINT TAB(22); "          unless you've got spears!"

drx = 14.5

dry = 12.4: what = 11: GOSUB drawobjs
dry = 14.9: what = 1.5: GOSUB drawobjs
dry = 16.2: what = 9: GOSUB drawobjs
dry = 18.7: what = 2: GOSUB drawobjs
dry = 20: what = 7: GOSUB drawobjs
dry = 21.3: what = 6: GOSUB drawobjs
dry = 22.6: what = 55: GOSUB drawobjs
dry = 23.9: what = 8: GOSUB drawobjs
dry = 26.4: what = 4: GOSUB drawobjs
dry = 27.7: what = 5: GOSUB drawobjs
drx = 13
dry = 26.4: what = 3: GOSUB drawobjs
dry = 27.7: what = 66: GOSUB drawobjs

O$ = INPUT$(1)
FOR clbottom = 10 TO 22
	LOCATE clbottom
	PRINT TAB(79); " "
NEXT

LOCATE 10
COLOR 4
PRINT TAB(20); "NEW in the Full Version"
COLOR 12
PRINT
PRINT TAB(22); "FOREST: You can't walk through this,"
PRINT TAB(22); "        except in some places..."
PRINT TAB(22); "INVISIBLE WALLS: Alltough you can't"
PRINT TAB(22); "           see them, they're solid."
PRINT TAB(22); "BONES: This fella won't hurt you!"
PRINT TAB(22); "BACTERIA: These are deadly if touched"
PRINT TAB(22); "          too often."

drx = 14.5
dry = 14.9: what = 333: GOSUB drawobjs
dry = 20: what = 1.1: GOSUB drawobjs
dry = 21.3: what = 4.5: GOSUB drawobjs

O$ = INPUT$(1)
FOR clbottom = 10 TO 22
	LOCATE clbottom
	PRINT TAB(79); " "
NEXT

LOCATE 10
COLOR 4
PRINT TAB(20); "Hints"
PRINT
COLOR 12
PRINT TAB(20); "Some WALLS aren't as solid as they seem..."
PRINT
PRINT TAB(20); "Watch out for MOVING WALLS, they squash"
PRINT TAB(20); "you if you stay in their way !"
PRINT
PRINT TAB(20); "There is no weapon against BACTERIA, so"
PRINT TAB(20); "if you step in them 10 times, you die!"
PRINT
PRINT TAB(20); "Mistrust MONEYBAGS, there are sometimes"
PRINT TAB(20); "bacteria hidden in them! (there is a way"
PRINT TAB(20); "to recognise infected bags, thought)"
PRINT

O$ = INPUT$(1)
FOR clbottom = 12 TO 22
	LOCATE clbottom
	PRINT TAB(79); " "
NEXT

LOCATE 12
PRINT TAB(20); "SAVING a game only saves the score you"
PRINT TAB(20); "had at the start of the level, so that"
PRINT TAB(20); "you lose points..."

O$ = INPUT$(1)
CLS

'end '* * * * * * *
GOTO info

infostory:
'CLS
'
'text$ = "HECATOMB": COLOR 14: LOCATE 2, 40 - LEN(text$) / 2: PRINT text$
'text$ = "Full Version by PhilBY": COLOR 4: LOCATE 3, 40 - LEN(text$) / 2: PRINT text$
'text$ = "The Story": COLOR 12: LOCATE 5, 40 - LEN(text$) / 2: PRINT text$
'
'LOCATE 9
'PRINT TAB(9); "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
'PRINT TAB(9); "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
'PRINT TAB(9); "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
'PRINT TAB(9); "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
'PRINT TAB(9); "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                       "
'PRINT TAB(9); "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                       "
'PRINT TAB(9); "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                       "
'PRINT TAB(9); "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                       "
'PRINT TAB(9); "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                       "
'PRINT TAB(9); "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                       "
'PRINT TAB(9); "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                       "
'PRINT TAB(9); "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
'PRINT TAB(9); "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
'PRINT TAB(9); "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
'picture$ = "isl_wide.phg": dpx = 700: dpy = 75: ex = 0: re = 0: GOSUB showpic
'picture$ = "horns2.phg": dpx = 390: dpy = 170: ex = 0: re = 0: GOSUB showpic
'
'
'O$ = INPUT$(1)
'CLS
GOTO info

infophilby:
CLS

PUT (145, 1), wide, PSET '* * * * * * * * * *
text$ = "HECATOMB": COLOR 14: LOCATE 5, 40 - LEN(text$) / 2: PRINT text$
text$ = "Full Version by PhilBY": COLOR 4: LOCATE 6, 40 - LEN(text$) / 2: PRINT text$
text$ = "What is PhilBY Productions?": COLOR 12: LOCATE 8, 40 - LEN(text$) / 2: PRINT text$
text$ = "It's me, Philip Blyth. I'm an artist,": COLOR 12: LOCATE 10, 40 - LEN(text$) / 2: PRINT text$
text$ = "game-head and computer programmer. I live": COLOR 12: LOCATE 11, 40 - LEN(text$) / 2: PRINT text$
text$ = "in Eupen, Belgium, and am 16 years old.": COLOR 12: LOCATE 12, 40 - LEN(text$) / 2: PRINT text$
text$ = "I hope you enjoy playing this game and the": COLOR 12: LOCATE 13, 40 - LEN(text$) / 2: PRINT text$
text$ = "others of my creation. Most of you will": COLOR 12: LOCATE 14, 40 - LEN(text$) / 2: PRINT text$
text$ = "have seen the demo version before playing": COLOR 12: LOCATE 15, 40 - LEN(text$) / 2: PRINT text$
text$ = "this one, and will be pleased to": COLOR 12: LOCATE 16, 40 - LEN(text$) / 2: PRINT text$
text$ = "discover the changes I made.": COLOR 12: LOCATE 17, 40 - LEN(text$) / 2: PRINT text$
picture$ = "me.phg": dpx = 700: dpy = 250: ex = 1: re = 1: GOSUB showpic

O$ = INPUT$(1)
CLS
GOTO info

infocredits:
CLS
tecol = 15
tecol2 = 4
tpx = 25 * 8
tpy = 14
stepcred = -14
jumpstep = 0
t=0
PALETTE 15, 0

REDIM textpic(tpx, tpy)
REDIM texttext$(6)

RESTORE
FOR t = 1 TO 6
	READ texttext$(t)
NEXT

FOR t = 1 TO 6
	LOCATE 1, 1
	COLOR tecol
	PRINT texttext$(t)
	FOR xf = 0 TO tpx
		FOR yf = 0 TO tpy
			textpic(xf, yf) = POINT(xf, yf)
		NEXT
	NEXT
	LOCATE 1, 1
	PRINT "                         "
	jumpcred = jumpcred + 1
	IF jumpcred / 2 <> INT(jumpcred / 2) THEN stepcred = stepcred + 14: tecol2 = 4 ELSE tecol2 = 12
	xausr = (660 / 2) - (tpx)
	yausr = 70
	stretch = 2
	square = 15
	i = 1
	DO WHILE INKEY$ = "" AND square > 0
		square = square - 1
		i = i + 2
		FOR splat = 1 TO 60 * i
			xf = INT(RND * tpx)
			yf = INT(RND * tpy)
			IF textpic(xf, yf) = 15 THEN
				col = INT(RND * 2 + 1)
				IF col = 1 THEN textpic(xf, yf) = 4
				IF col = 2 THEN textpic(xf, yf) = 12
				'textpic(xf, yf)=tecol2
			END IF
			LINE (xf * stretch + xausr, yf * stretch + yausr + stepcred)-(xf * stretch + xausr + square, yf * stretch + yausr + square + stepcred), textpic(xf, yf), BF
		NEXT
		if inkey$<>"" then t=6:goto endcredits
	LOOP
	stepcred = stepcred + 14 * 2
NEXT

DATA"  Artist & Programmer","     Philip Blyth"," Ideas & Ameliorations","Hugh Featherstone Blyth","    Calm & Patience","     Martine Blyth"


IO$ = INPUT$(1)

endcredits:
tpx = 25 * 8
tpy = 14
stepcred = -14
jumpstep = 0
t=0
PALETTE 15, 63
CLS
return


'000000000000000000000000

boarderwater:

IF dry = 1 THEN
	LINE ((drx * big) - big, (dry * big) - big + 1)-((drx * big), (dry * big) - big + 1), 8
ELSE
	IF feld(drx, dry - 1) <> 55 AND feld(drx, dry - 1) <> 66 THEN
	LINE ((drx * big) - big, (dry * big) - big + 1)-((drx * big), (dry * big) - big + 1), 8
	END IF
END IF
IF dry = ymax THEN
	LINE ((drx * big) - big, (dry * big - 1))-((drx * big), (dry * big - 1)), 7
ELSE
	IF feld(drx, dry + 1) <> 55 AND feld(drx, dry + 1) <> 66 THEN
	LINE ((drx * big) - big, (dry * big - 1))-((drx * big), (dry * big - 1)), 7
	END IF
END IF
IF drx = 1 THEN
	LINE ((drx * big) - big + 1, (dry * big) - big)-((drx * big) - big + 1, (dry * big)), 8
ELSE
	IF feld(drx - 1, dry) <> 55 AND feld(drx - 1, dry) <> 66 THEN
	LINE ((drx * big) - big + 1, (dry * big) - big)-((drx * big) - big + 1, (dry * big)), 8
	END IF
END IF
IF drx = xmax THEN
	LINE ((drx * big) - 1, (dry * big) - big)-((drx * big) - 1, (dry * big)), 7
ELSE
	IF feld(drx + 1, dry) <> 55 AND feld(drx + 1, dry) <> 66 THEN
	LINE ((drx * big) - 1, (dry * big) - big)-((drx * big) - 1, (dry * big)), 7
	END IF
END IF
RETURN


ende:
'CLS
x1 = 200
y1 = 135
x2 = 420
y2 = 185
sfcol = 0
bcol = 4
fcol = 14
GOSUB frame
text$ = "Are you SURE ??? (y/n)"
COLOR 12: LOCATE 12, 40 - LEN(text$) / 2: PRINT text$

60 su$ = INPUT$(1)
IF su$ <> "y" AND su$ <> "n" THEN GOTO 60
IF su$ = "y" THEN END ELSE CLS : GOTO titlepage
END


fehler:
SELECT CASE ERR
CASE 75
	LOCATE 24, 1
	PRINT "FILE NOT FOUND, wait..."
	LOCATE 24, 1
	PRINT "                       "
	RESUME NEXT
CASE 52
	LOCATE 24, 1
	PRINT "FILE NOT FOUND, wait..."
	LOCATE 24, 1
	PRINT "                       "
	RESUME NEXT
CASE 53
	LOCATE 24, 1
	PRINT "FILE NOT FOUND, wait..."
	LOCATE 24, 1
	PRINT "                       "
	RESUME NEXT
CASE 76
	LOCATE 24, 1
	PRINT "PATH NOT FOUND, wait..."
	LOCATE 24, 1
	PRINT "                       "
	RESUME NEXT
CASE 7
	CLS
	BEEP
	COLOR 7
	PRINT "SORRY, you haven't got enough memory to play HECATOMB..."
	r$ = INPUT$(1)
	END
CASE ELSE
	CLS
	BEEP
	COLOR 7
	PRINT "SORRY, unexpected error occured... ERROR:"; ERR
	r$ = INPUT$(1)
	END
END SELECT


meblood:
IF w = 1 THEN
	feld(x, y) = 77: drx = x: dry = y: what = 77: GOSUB drawobjs
	IF megablood = 1 THEN
		IF x > 1 THEN IF feld(x - 1, y) = 55 THEN feld(x - 1, y) = 77: drx = x - 1: dry = y: what = 77: GOSUB drawobjs
		IF x < xmax THEN IF feld(x + 1, y) = 55 THEN feld(x + 1, y) = 77: drx = x + 1: dry = y: what = 77: GOSUB drawobjs
		IF y > 1 THEN IF feld(x, y - 1) = 55 THEN feld(x, y - 1) = 77: drx = x: dry = y - 1: what = 77: GOSUB drawobjs
		IF y < ymax THEN IF feld(x, y + 1) = 55 THEN feld(x, y + 1) = 77: drx = x: dry = y + 1: what = 77: GOSUB drawobjs
	END IF
ELSE
	feld(x, y) = 22: drx = x: dry = y: what = 22: GOSUB drawobjs
	IF megablood = 1 THEN
		IF x > 1 THEN IF feld(x - 1, y) = 0 THEN feld(x - 1, y) = 22: drx = x - 1: dry = y: what = 22: GOSUB drawobjs
		IF x < xmax THEN IF feld(x + 1, y) = 0 THEN feld(x + 1, y) = 22: drx = x + 1: dry = y: what = 22: GOSUB drawobjs
		IF y > 1 THEN IF feld(x, y - 1) = 0 THEN feld(x, y - 1) = 22: drx = x: dry = y - 1: what = 22: GOSUB drawobjs
		IF y < ymax THEN IF feld(x, y + 1) = 0 THEN feld(x, y + 1) = 22: drx = x: dry = y + 1: what = 22: GOSUB drawobjs
	END IF
END IF
RETURN

burst:
IF w = 1 THEN
	feld(x, y) = 77: drx = x: dry = y: what = 77: GOSUB drawobjs
	IF burst = 1 THEN
		IF x > 1 THEN feld(x - 1, y) = 77: drx = x - 1: dry = y: what = 77: GOSUB drawobjs
		IF x < xmax THEN feld(x + 1, y) = 77: drx = x + 1: dry = y: what = 77: GOSUB drawobjs
		IF y > 1 THEN feld(x, y - 1) = 77: drx = x: dry = y - 1: what = 77: GOSUB drawobjs
		IF y < ymax THEN feld(x, y + 1) = 77: drx = x: dry = y + 1: what = 77: GOSUB drawobjs
	END IF
ELSE
	feld(x, y) = 22: drx = x: dry = y: what = 22: GOSUB drawobjs
	IF burst = 1 THEN
		IF x > 1 THEN feld(x - 1, y) = 22: drx = x - 1: dry = y: what = 22: GOSUB drawobjs
		IF x < xmax THEN feld(x + 1, y) = 22: drx = x + 1: dry = y: what = 22: GOSUB drawobjs
		IF y > 1 THEN feld(x, y - 1) = 22: drx = x: dry = y - 1: what = 22: GOSUB drawobjs
		IF y < ymax THEN feld(x, y + 1) = 22: drx = x: dry = y + 1: what = 22: GOSUB drawobjs
	END IF
END IF
RETURN


loadgame:
OPEN "savegame.lvl" FOR INPUT AS #1
INPUT #1, x
INPUT #1, y
INPUT #1, oldscore
INPUT #1, spears
INPUT #1, daggers
INPUT #1, clef
INPUT #1, level$
INPUT #1, remark$
INPUT #1, xmax, ymax
REDIM feld(xmax, ymax)
FOR xx = 1 TO xmax
	FOR yy = 1 TO ymax
		INPUT #1, feld(xx, yy)
	NEXT
NEXT
FOR xx = 1 TO xmax
	FOR yy = 1 TO ymax
		INPUT #1, visib(xx, yy)
	NEXT
NEXT
CLOSE

score = 0
wholegame = 1
level = VAL(level$)

GOTO params

savegame:
OPEN "savegame.lvl" FOR OUTPUT AS #1
WRITE #1, x
WRITE #1, y
WRITE #1, oldscore
WRITE #1, spears
WRITE #1, daggers
WRITE #1, clef
WRITE #1, level$
WRITE #1, remark$
WRITE #1, xmax, ymax
FOR xx = 1 TO xmax
	FOR yy = 1 TO ymax
		WRITE #1, feld(xx, yy)
	NEXT
NEXT
FOR xx = 1 TO xmax
	FOR yy = 1 TO ymax
		WRITE #1, visib(xx, yy)
	NEXT
NEXT
CLOSE
RETURN

startnew:
wholegame = 1
level = level + 1
IF level > maxlevel THEN GOTO endgame 'video*video*video*video*video*video*video*
level$ = STR$(level)
level$ = MID$(level$, 2, LEN(level$) - 1)

restartnew:
oldscore = oldscore + score
OPEN "heca2" + level$ + ".lvl" FOR INPUT AS #1
INPUT #1, remark$
INPUT #1, xmax, ymax
REDIM feld(xmax, ymax)
FOR xx = 1 TO xmax
	FOR yy = 1 TO ymax
		INPUT #1, feld(xx, yy)
	NEXT
NEXT
CLOSE

GOTO newparams


'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
philbypresents:
picture$ = "dont.phg": dpx = 530: dpy = 331: ex = 1: re = 1: GOSUB showpic

FOR x = 2 TO 21

s$ = "s" + STR$(x)
DRAW s$

DRAW "ta-5"
DRAW "c9 bm120,180 bm-6,+5r78u23l78d23"
DRAW "c0 bm120,180 bm+2,+2   u10r8f2d2m-2,+2l5d4 bm+10,+0u10r3d5r4u5r3d10 bm+3,+0u5nr3bu2u3r3d3nl3bd2d5 bm+3,-10d10r8u3nl5 bm+3,+3u10r8f2d1m-2,+2nl5f2d1m-2,+2nl5 bm+8,0m+5,-10l4m-2,+5m-5,-10l3"
DRAW "c0 bm121,180 bm+2,+2   u10r8f2d2m-2,+2l5d4 bm+10,+0u10r3d5r4u5r3d10 bm+3,+0u5nr3bu2u3r3d3nl3bd2d5 bm+3,-10d10r8u3nl5 bm+3,+3u10r8f2d1m-2,+2nl5f2d1m-2,+2nl5 bm+8,0m+5,-10l4m-2,+5m-5,-10l3"
DRAW "c14 bm120,180   u10r8f2d2m-2,+2l5d4 bm+10,+0u10r3d5r4u5r3d10 bm+3,+0u5nr3bu2u3r3d3nl3bd2d5 bm+3,-10d10r8u3nl5 bm+3,+3u10r8f2d1m-2,+2nl5f2d1m-2,+2nl5 bm+8,0m+5,-10l4m-2,+5m-5,-10l3"
DRAW "c14 bm121,180   u10r8f2d2m-2,+2l5d4 bm+10,+0u10r3d5r4u5r3d10 bm+3,+0u5nr3bu2u3r3d3nl3bd2d5 bm+3,-10d10r8u3nl5 bm+3,+3u10r8f2d1m-2,+2nl5f2d1m-2,+2nl5 bm+8,0m+5,-10l4m-2,+5m-5,-10l3"

FOR tim = 1 TO 2500 * speedfaktor
NEXT

DRAW "ta-5"
DRAW "c0 bm120,180 bm-6,+5r78u23l78d23"
DRAW "c0 bm120,180   u10r8f2d2m-2,+2l5d4 bm+10,+0u10r3d5r4u5r3d10 bm+3,+0u5nr3bu2u3r3d3nl3bd2d5 bm+3,-10d10r8u3nl5 bm+3,+3u10r8f2d1m-2,+2nl5f2d1m-2,+2nl5 bm+8,0m+5,-10l4m-2,+5m-5,-10l3"
DRAW "c0 bm121,180   u10r8f2d2m-2,+2l5d4 bm+10,+0u10r3d5r4u5r3d10 bm+3,+0u5nr3bu2u3r3d3nl3bd2d5 bm+3,-10d10r8u3nl5 bm+3,+3u10r8f2d1m-2,+2nl5f2d1m-2,+2nl5 bm+8,0m+5,-10l4m-2,+5m-5,-10l3"

NEXT

DRAW "ta-5"
DRAW "c9 bm120,180 bm-6,+5r78u23l78d23"
PAINT (120, 182), 4, 9
DRAW "c0 bm120,180 bm+2,+2   u10r8f2d2m-2,+2l5d4 bm+10,+0u10r3d5r4u5r3d10 bm+3,+0u5nr3bu2u3r3d3nl3bd2d5 bm+3,-10d10r8u3nl5 bm+3,+3u10r8f2d1m-2,+2nl5f2d1m-2,+2nl5 bm+8,0m+5,-10l4m-2,+5m-5,-10l3"
DRAW "c0 bm121,180 bm+2,+2   u10r8f2d2m-2,+2l5d4 bm+10,+0u10r3d5r4u5r3d10 bm+3,+0u5nr3bu2u3r3d3nl3bd2d5 bm+3,-10d10r8u3nl5 bm+3,+3u10r8f2d1m-2,+2nl5f2d1m-2,+2nl5 bm+8,0m+5,-10l4m-2,+5m-5,-10l3"
DRAW "c0 bm120,181 bm+2,+2   u10r8f2d2m-2,+2l5d4 bm+10,+0u10r3d5r4u5r3d10 bm+3,+0u5nr3bu2u3r3d3nl3bd2d5 bm+3,-10d10r8u3nl5 bm+3,+3u10r8f2d1m-2,+2nl5f2d1m-2,+2nl5 bm+8,0m+5,-10l4m-2,+5m-5,-10l3"
DRAW "c0 bm121,181 bm+2,+2   u10r8f2d2m-2,+2l5d4 bm+10,+0u10r3d5r4u5r3d10 bm+3,+0u5nr3bu2u3r3d3nl3bd2d5 bm+3,-10d10r8u3nl5 bm+3,+3u10r8f2d1m-2,+2nl5f2d1m-2,+2nl5 bm+8,0m+5,-10l4m-2,+5m-5,-10l3"
DRAW "c0 bm120,182 bm+2,+2   u10r8f2d2m-2,+2l5d4 bm+10,+0u10r3d5r4u5r3d10 bm+3,+0u5nr3bu2u3r3d3nl3bd2d5 bm+3,-10d10r8u3nl5 bm+3,+3u10r8f2d1m-2,+2nl5f2d1m-2,+2nl5 bm+8,0m+5,-10l4m-2,+5m-5,-10l3"
DRAW "c0 bm121,182 bm+2,+2   u10r8f2d2m-2,+2l5d4 bm+10,+0u10r3d5r4u5r3d10 bm+3,+0u5nr3bu2u3r3d3nl3bd2d5 bm+3,-10d10r8u3nl5 bm+3,+3u10r8f2d1m-2,+2nl5f2d1m-2,+2nl5 bm+8,0m+5,-10l4m-2,+5m-5,-10l3"
DRAW "c14 bm120,180   u10r8f2d2m-2,+2l5d4 bm+10,+0u10r3d5r4u5r3d10 bm+3,+0u5nr3bu2u3r3d3nl3bd2d5 bm+3,-10d10r8u3nl5 bm+3,+3u10r8f2d1m-2,+2nl5f2d1m-2,+2nl5 bm+8,0m+5,-10l4m-2,+5m-5,-10l3"
DRAW "c14 bm121,180   u10r8f2d2m-2,+2l5d4 bm+10,+0u10r3d5r4u5r3d10 bm+3,+0u5nr3bu2u3r3d3nl3bd2d5 bm+3,-10d10r8u3nl5 bm+3,+3u10r8f2d1m-2,+2nl5f2d1m-2,+2nl5 bm+8,0m+5,-10l4m-2,+5m-5,-10l3"
DRAW "c14 bm120,181   u10r8f2d2m-2,+2l5d4 bm+10,+0u10r3d5r4u5r3d10 bm+3,+0u5nr3bu2u3r3d3nl3bd2d5 bm+3,-10d10r8u3nl5 bm+3,+3u10r8f2d1m-2,+2nl5f2d1m-2,+2nl5 bm+8,0m+5,-10l4m-2,+5m-5,-10l3"
DRAW "c14 bm121,181   u10r8f2d2m-2,+2l5d4 bm+10,+0u10r3d5r4u5r3d10 bm+3,+0u5nr3bu2u3r3d3nl3bd2d5 bm+3,-10d10r8u3nl5 bm+3,+3u10r8f2d1m-2,+2nl5f2d1m-2,+2nl5 bm+8,0m+5,-10l4m-2,+5m-5,-10l3"
DRAW "c14 bm120,182   u10r8f2d2m-2,+2l5d4 bm+10,+0u10r3d5r4u5r3d10 bm+3,+0u5nr3bu2u3r3d3nl3bd2d5 bm+3,-10d10r8u3nl5 bm+3,+3u10r8f2d1m-2,+2nl5f2d1m-2,+2nl5 bm+8,0m+5,-10l4m-2,+5m-5,-10l3"
DRAW "c14 bm121,182   u10r8f2d2m-2,+2l5d4 bm+10,+0u10r3d5r4u5r3d10 bm+3,+0u5nr3bu2u3r3d3nl3bd2d5 bm+3,-10d10r8u3nl5 bm+3,+3u10r8f2d1m-2,+2nl5f2d1m-2,+2nl5 bm+8,0m+5,-10l4m-2,+5m-5,-10l3"

FOR tim = 1 TO 50000 * speedfaktor
NEXT

dela = 7000
DRAW "ta44 s20"

FOR thick = 1 TO 5
PSET (119 + thick, 310), 0
DRAW "c0 bm+5,+5 u10r8f2d2m-2,+2l5d4 bm+10,+0u10r8f2d2m-2,+2l5"
DRAW "m+7,+4 bm+3,+0u10r10d3l7d1r5d3l5d1r7 bm+3,+0nr5d2r10e2u1"
DRAW "m-2,-2l8m-2,-2u1e2r8d2l5 bm+10,+8u10r10d3l7d1r5d3l5d1r7"
DRAW "bm+3,+2r3nu5l3u10r3m+5,+10r3u10l3d5   bm+8,+5r3nu3l3u7l3u3r9"
DRAW "bm+3,+8nr5d2r10e2u1m-2,-2l8m-2,-2u1e2r8d2l5 "
FOR tim = 1 TO dela * speedfaktor
NEXT
NEXT

FOR thick = 1 TO 5
PSET (119 + thick, 310), 0
DRAW "c15 u10r8f2d2m-2,+2l5d4 bm+10,+0u10r8f2d2m-2,+2l5"
DRAW "m+7,+4 bm+3,+0u10r10d3l7d1r5d3l5d1r7 bm+3,+0nr5d2r10e2u1"
DRAW "m-2,-2l8m-2,-2u1e2r8d2l5 bm+10,+8u10r10d3l7d1r5d3l5d1r7"
DRAW "bm+3,+2r3nu5l3u10r3m+5,+10r3u10l3d5   bm+8,+5r3nu3l3u7l3u3r9"
DRAW "bm+3,+8nr5d2r10e2u1m-2,-2l8m-2,-2u1e2r8d2l5 "
FOR tim = 1 TO dela * speedfaktor
NEXT
NEXT


FOR tim = 1 TO 60000 * speedfaktor
NEXT

FOR x = 1 TO 24
LOCATE 24
PRINT ""
FOR tim = 1 TO 6000 * speedfaktor
NEXT
NEXT

DRAW "ta0s4"

endlogo:

RETURN


'+++++++++++++++++++++++++++++++++++++++++++++
'+++++++++++++++++++++++++++++++++++++++++++++
'+++++++++++++++++++++++++++++++++++++++++++++
endgame:
'endemal = endemal + 1
CLS

VIEW PRINT 1 TO 25
score$ = STR$(score + oldscore)
PLAY "mbmbmbmbmbmb t100 o1 l16 efgefd l8 c"
text$ = "CONGRATULATIONS!"
COLOR 12: LOCATE 15, 40 - LEN(text$) / 2: PRINT text$
text$ = "You won with a total score of" + score$ + "!!!"
COLOR 12: LOCATE 16, 40 - LEN(text$) / 2: PRINT text$

'xvs = 250
'yvs = 100
'
'IF endemal = 1 THEN
'REDIM vid1(119, 55)
'REDIM vid2(119, 55)
'REDIM vid3(119, 55)
'
'FOR num = 1 TO 3
'num$ = STR$(num)
'num$ = MID$(num$, 2, 4)
'
'OPEN "vid" + num$ + ".phg" FOR INPUT AS #1
'        INPUT #1, xvid
'        INPUT #1, yvid
'        FOR xv = 1 TO xvid
'                FOR yv = 1 TO yvid
'                        INPUT #1, col
'                        PSET (xv + xvs - 1, yv + yvs - 1), col
'                NEXT
'        NEXT
'CLOSE
'
'IF num = 1 THEN GET (xvs, yvs)-(118 + xvs, 54 + yvs), vid1
'IF num = 2 THEN GET (xvs, yvs)-(118 + xvs, 54 + yvs), vid2
'IF num = 3 THEN GET (xvs, yvs)-(118 + xvs, 54 + yvs), vid3
'NEXT
'END IF
'
'spd = 5000
'FOR vi = 1 TO 8
'spd = spd + 5000
'PUT (xvs, yvs), vid1, PSET: FOR tim = 1 TO spd * speedfaktor: NEXT
'PUT (xvs, yvs), vid2, PSET: FOR tim = 1 TO spd * speedfaktor: NEXT
'PUT (xvs, yvs), vid3, PSET: FOR tim = 1 TO spd * speedfaktor: NEXT
'PUT (xvs, yvs), vid2, PSET: FOR tim = 1 TO spd * speedfaktor: NEXT
'NEXT
'PUT (xvs, yvs), vid3, PSET
'
r$ = INPUT$(1)

GOTO anf

options:


CLS

PUT (145, 1), wide, PSET '* * * * * * * * * *
text$ = "HECATOMB": COLOR 14: LOCATE 5, 40 - LEN(text$) / 2: PRINT text$
text$ = "Full Version by PhilBY": COLOR 4: LOCATE 6, 40 - LEN(text$) / 2: PRINT text$
text$ = "Options": COLOR 12: LOCATE 8, 40 - LEN(text$) / 2: PRINT text$
dd = 0

decx = 297
decy = 162

'diffs came here ??????????????????????????????????????
REDIM diffspeed$(3, 2)
diffspeed$(1, 1) = "fa_baby.phg"
diffspeed$(2, 1) = "fa_norm.phg"
diffspeed$(3, 1) = "fa_diff.phg"

diffspeed$(1, 2) = "WWWhaaaaa!"
diffspeed$(2, 2) = "Normal"
diffspeed$(3, 2) = "D... d... difficult!"


text$ = "UP and DOWN to choose difficulty level,"
COLOR 4: LOCATE 10, 40 - LEN(text$) / 2: PRINT text$
text$ = "ENTER to accept"
COLOR 4: LOCATE 11, 40 - LEN(text$) / 2: PRINT text$

LOCATE 16, 1
PRINT TAB(80); ""
text$ = diffspeed$(diff, 2)
COLOR 12: LOCATE 16, 40.5 - LEN(text$) / 2: PRINT text$

OPEN diffspeed$(diff, 1) FOR INPUT AS #1
	INPUT #1, xp
	INPUT #1, yp
	REDIM face(xp, yp)
	FOR sxp = 1 TO xp
		FOR syp = 1 TO yp
			INPUT #1, col
			face(sxp, syp) = col
		NEXT
	NEXT
CLOSE

40
sxp = INT(RND * xp + 1)
syp = INT(RND * yp + 1)
PSET (decx + sxp, decy + syp), face(sxp, syp)

ink$ = INKEY$
IF ink$ <> CHR$(0) + CHR$(72) AND ink$ <> CHR$(0) + CHR$(80) AND ink$ <> CHR$(13) THEN GOTO 40

IF ink$ = CHR$(0) + CHR$(72) THEN
	diff = diff - 1
	IF diff = 0 THEN diff = 3
END IF
IF ink$ = CHR$(0) + CHR$(80) THEN
	diff = diff + 1
	IF diff = 4 THEN diff = 1
END IF
IF ink$ = CHR$(13) THEN dd = 1

OPEN diffspeed$(diff, 1) FOR INPUT AS #1
	INPUT #1, xp
	INPUT #1, yp
	FOR sxp = 1 TO xp
		FOR syp = 1 TO yp
			INPUT #1, col
			face(sxp, syp) = col
		NEXT
	NEXT
CLOSE
LOCATE 16, 1
PRINT TAB(80); ""
text$ = diffspeed$(diff, 2)
COLOR 12: LOCATE 16, 40.5 - LEN(text$) / 2: PRINT text$

IF dd <> 1 THEN GOTO 40

monspeed = diffspeed(diff, 1)
wspeed = diffspeed(diff, 2)

	mebloodopt = 1
	text$ = "  Blood"
	COLOR 4: LOCATE 18, 40 - LEN(text$) / 2: PRINT text$

	bloodx = 29.5
	bloody = 25.5

	IF megablood = 0 THEN
		dry = bloody
		FOR drx = bloodx - 1 TO bloodx + 1
			what = 0
			GOSUB drawobjs
		NEXT
		drx = bloodx
		FOR dry = bloody - 1 TO bloody + 1
			what = 0
			GOSUB drawobjs
		NEXT
		dry = bloody
		what = 22
		GOSUB drawobjs
	ELSE
		dry = bloody
		FOR drx = bloodx - 1 TO bloodx + 1
			what = 22
			GOSUB drawobjs
		NEXT
		drx = bloodx
		FOR dry = bloody - 1 TO bloody + 1
			what = 22
			GOSUB drawobjs
		NEXT
	END IF

30 :
	speed$ = INPUT$(1)
	IF speed$ = CHR$(13) THEN
		CLS

		mebloodopt = 0
		OPEN "options.dat" FOR OUTPUT AS #1
		WRITE #1, diff
		WRITE #1, megablood
		CLOSE

		GOTO titlepage
	ELSE
		IF megablood = 0 THEN megablood = 1 ELSE megablood = 0
	END IF

	IF megablood = 1 THEN
		dry = bloody
		FOR drx = bloodx - 1 TO bloodx + 1
			what = 22
			GOSUB drawobjs
		NEXT
		drx = bloodx
		FOR dry = bloody - 1 TO bloody + 1
			what = 22
			GOSUB drawobjs
		NEXT
	ELSE
		dry = bloody
		FOR drx = bloodx - 1 TO bloodx + 1
			what = 0
			GOSUB drawobjs
		NEXT
		drx = bloodx
		FOR dry = bloody - 1 TO bloody + 1
			what = 0
			GOSUB drawobjs
		NEXT
		dry = bloody
		what = 22
		GOSUB drawobjs
	END IF
GOTO 30

CLS

BEEP

GOTO titlepage


userid:
picture$ = "dont.phg": dpx = 530: dpy = 331: ex = 1: re = 1: GOSUB showpic
x1 = 100: y1 = 50: x2 = 540: y2 = 300: sfcol = 0: bcol = 12: fcol = 14
GOSUB frame

text$ = "I M P O R T A N T": COLOR 14: LOCATE 6, 40 - LEN(text$) / 2: PRINT text$
text$ = "THIS IS NO SHAREWARE!": COLOR 12: LOCATE 8, 40 - LEN(text$) / 2: PRINT text$
text$ = "Any copying of this game is against the LAW!": COLOR 4: LOCATE 9, 40 - LEN(text$) / 2: PRINT text$
text$ = "This copy has been licensed for": COLOR 4: LOCATE 10, 40 - LEN(text$) / 2: PRINT text$
text$ = user$: COLOR 12: LOCATE 11, 40 - LEN(text$) / 2: PRINT text$
text$ = "Please abide by the rules of shareware": COLOR 4: LOCATE 13, 40 - LEN(text$) / 2: PRINT text$
text$ = "and order your own copy of HECATOMB...": COLOR 4: LOCATE 14, 40 - LEN(text$) / 2: PRINT text$
text$ = "This will enable me to program even better": COLOR 4: LOCATE 15, 40 - LEN(text$) / 2: PRINT text$
text$ = "software for you.": COLOR 4: LOCATE 16, 40 - LEN(text$) / 2: PRINT text$
text$ = "Thankyou": COLOR 4: LOCATE 18, 40 - LEN(text$) / 2: PRINT text$
text$ = "(More info in ORDER.WRI)": COLOR 12: LOCATE 20, 40 - LEN(text$) / 2: PRINT text$

DO
wttm = wttm + 1
LOOP UNTIL (wttm >= waittime * speedfaktor) OR (INKEY$ <> "")

RETURN

frame:
LINE (x1 + 3, y1 + 2)-(x2 + 3, y2 + 2), 0, BF
LINE (x1 + 3, y1 + 2)-(x2 + 3, y2 + 2), 8, B
LINE (x1, y1)-(x2, y2), bcol, BF
LINE (x1 + 4 + 1, y1 + 3 + 1)-(x2 - 4 + 1, y2 - 3 + 1), sfcol, B
LINE (x1 + 4, y1 + 3)-(x2 - 4, y2 - 3), fcol, B
LINE (x1 + 10, y1 + 8)-(x2 - 10, y2 - 8), 0, BF
RETURN

showpic:
OPEN picture$ FOR INPUT AS #1
	INPUT #1, xpi
	INPUT #1, ypi
	IF dpx > 630 THEN dpx = (630 / 2) - (xpi / 2)
	IF dpy > 350 THEN dpy = (350 / 2) - (ypi / 2)
	FOR sxp = 1 TO xpi
		FOR syp = 1 TO ypi
			INPUT #1, colpic
			IF colpic = ex THEN colpic = re
			PSET (dpx + sxp, dpy + syp), colpic
		NEXT
	NEXT
CLOSE
RETURN


intro:
picture$ = "dont.phg": dpx = 530: dpy = 331: ex = 1: re = 1: GOSUB showpic
IF intr = 0 THEN
	xausr = 10
	yausr = 80
	stretch = 1.75
	square = 50
	i = 1
	disolve = 0
	disyes = 0
	disam = 100 * speedfaktor / 4
	DO WHILE INKEY$ = "" AND square > 0
		IF disyes = 0 THEN square = square - 1
		i = i + .3
		FOR t = 1 TO 50 * i
			x = INT(RND * 355 + 1)
			y = INT(RND * 45 + 1)
			LINE (x * stretch + xausr, y * stretch + yausr)-(x * stretch + xausr + square, y * stretch + yausr + square), title(x, y), BF
		NEXT
		IF square = 1 OR disyes = 1 THEN
			disyes = 1
			disolve = disolve + 1
			'square must be >0 to loop
			square = INT(RND * 2) + 2
			IF disolve >= disam THEN square = -1
		END IF
	LOOP
	IF square = 0 THEN oi$ = INPUT$(1)
END IF
RETURN


drawdark:
'xmax = 58
'ymax = 25

IF diff = 3 and touch=0 THEN darc = 3 ELSE darc = 1

darxs = 1 - x
darys = 1 - y

darxe = xmax - x
darye = ymax - y

IF darxs < -darc THEN darxs = -darc
IF darys < -darc THEN darys = -darc

IF darxe > darc THEN darxe = darc
IF darye > darc THEN darye = darc

FOR darx = darxs TO darxe
	FOR dary = darys TO darye
	'Draw Invisible Walls
	if diff<>3 or touch=1 then
	IF feld(x + darx, y + dary) = 222 THEN
		drx = x + darx
		dry = y + dary
		what = 22.22
		feld(x + darx, y + dary) = 22.22
		GOSUB drawobjs
	END IF
	end if

	'Draw everything if diff=3
	IF diff = 3 and touch=0 THEN
		drx = x + darx
		dry = y + dary
		IF visib(x + darx, y + dary) = 0 then
			visib(x + darx, y + dary) = 1
			if feld(x + darx, y + dary) <> 222 and feld(x + darx, y + dary) <> 22.22 THEN
				what = feld(x + darx, y + dary)
				GOSUB drawobjs
			end if
		END IF
	END IF
	NEXT
NEXT
touch=0

RETURN

gotkilled:
      drx = x
      dry = y
      if waterkill=1 then what = 77 else what=22
      GOSUB drawobjs
	drx = x
	dry = y
	what = 1.1
	GOSUB drawobjs
      GOSUB cb
      LOCATE 21, 1
      PLAY "mbmbmbmb o2 t150 l50 bagfed l25 c"
      PRINT "You got killed!!!"
      PRINT "Retry Level? (y/n)"
1 :   O$ = INPUT$(1)
      IF O$ <> "y" AND O$ <> "n" AND O$ <> chr$(13) THEN GOTO 1
      IF (O$ = "y" or O$ = CHR$(13)) THEN IF wholegame = 1 THEN GOTO restartnew ELSE GOTO restart

return

