' LrgEdit (.PHG editor)
' =====================
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

ON ERROR GOTO Fehlerbehandlung


SCREEN 9
WIDTH 80, 25

KEY 1, "u"'help
KEY 2, "s"'save
KEY 3, "h"'load
KEY 4, "n"'new
KEY 5, "z"'files
KEY 6, "y"'cd

oben$ = CHR$(0) + CHR$(72)
unten$ = CHR$(0) + CHR$(80)
links$ = CHR$(0) + CHR$(75)
rechts$ = CHR$(0) + CHR$(77)
stp = 10
OPEN "lrgsize.num" FOR INPUT AS #1
	INPUT #1, pix, piy'x = 320, y = 175
CLOSE


5
frdr = 0
lidr = 0
mcol = 15
in = 27
sx = 1
sy = 1
wx = CINT(320 - (pix / 2))
wy = 15

'VIEW SCREEN (1, 1)-(635, 475), 0, 0
VIEW SCREEN (1, 1)-(635, 349), 0, 0

REDIM hguide(pix, 1)
REDIM vguide(1, piy)

LINE (1, 1)-(pix, 1), 15
GET (1, 1)-(pix, 1), hguide
CLS
LINE (1, 1)-(1, piy), 15
GET (1, 1)-(1, piy), vguide
CLS

VIEW SCREEN (wx + 1, wy + 1)-(wx + pix, wy + piy), 0, 12

LINE (wx, wy)-(pix + wx + 1, piy + wy + 1), 15, B

PUT (wx + 1, wy + sy), hguide, XOR
PUT (wx + sx, wy + 1), vguide, XOR


10
VIEW PRINT 24 TO 25
COLOR 9
PRINT sx; ","; sy; "   LINE MODE "; lidr; "   FREE-HAND OFF"; frdr; "   MAIN COLOR:"; mcol; "  "
COLOR 12
'r$ = INPUT$(1)
r$ = INKEY$

'-----------------------------------------------------------------
IF r$ = "y" OR r$ = "z" OR r$ = "c" OR r$ = "n" OR r$ = "f" OR r$ = "m" OR r$ = "s" OR r$ = "h" THEN VIEW PRINT 22 TO 23'-----------------------------------------------------------------
IF r$ = CHR$(27) THEN END
'-----------------------------------------------------------------
IF r$ = "c" THEN GOSUB circl
'-----------------------------------------------------------------
IF r$ = "y" THEN
	INPUT "CHANGE DIR "; cd$
	SHELL "cd " + cd$
	GOSUB clbt
END IF
'-----------------------------------------------------------------
IF r$ = "z" THEN
	FILES "*.phg"
	p$ = INPUT$(1)
	GOSUB clbt
	INPUT "Proportion info of a file (y/n)"; propyn$
	IF propyn$ = "y" THEN
		INPUT "Name of file"; propnam$
		OPEN propnam$ + ".phg" FOR INPUT AS #1
			INPUT #1, ppix
			INPUT #1, ppiy
		CLOSE
		PRINT "Proportions: "; ppix; ","; ppiy
		p$ = INPUT$(1)
		GOSUB clbt
	END IF
	GOSUB clbt
END IF
'-----------------------------------------------------------------
IF r$ = "n" THEN
niupic:
	PRINT "NEW"
	PRINT "Proportions of current cursor? (y/n)"
	proask$ = INPUT$(1)
	IF proask$ <> "y" AND proask$ <> "n" THEN GOTO niupic
	IF proask$ = "n" THEN
prodefa:
		PRINT "Default Proportions? (y/n)"
		prodef$ = INPUT$(1)
		IF prodef$ <> "y" AND prodef$ <> "n" THEN GOTO prodefa
		IF prodef$ = "n" THEN
			INPUT "Height:", piy '90
			INPUT "Width:", pix '179
		END IF
		IF prodef$ = "y" THEN
			pix = 179
			piy = 90
		END IF
	END IF
	IF proask$ = "y" THEN
		pix = sx
		piy = sy
	END IF

	GOSUB clbt
	GOTO 5
END IF

'-----------------------------------------------------------------
IF r$ = "f" THEN
	PRINT "FILL"
	INPUT "Fillcolor"; col
	INPUT "Edgecolor"; racol
	PUT (wx + sx, wy + 1), vguide, XOR
	PUT (wx + 1, wy + sy), hguide, XOR
	PAINT (wx + sx, wy + sy), col, racol
	PUT (wx + sx, wy + 1), vguide, XOR
	PUT (wx + 1, wy + sy), hguide, XOR
	GOSUB clbt
END IF
'-----------------------------------------------------------------
IF r$ = "m" THEN
	INPUT "Main Color (Lines, Squares, Free-hand,...)"; mcol
	GOSUB clbt
END IF
'-----------------------------------------------------------------
IF r$ = "l" THEN
	IF lidr = 1 THEN
		PUT (wx + sx, wy + 1), vguide, XOR
		PUT (wx + 1, wy + sy), hguide, XOR
		LINE (wx + xli, wy + yli)-(wx + sx, wy + sy), mcol
		PUT (wx + sx, wy + 1), vguide, XOR
		PUT (wx + 1, wy + sy), hguide, XOR
		lidr = 0
	ELSE
		xli = sx
		yli = sy
		lidr = 1
	END IF
END IF
'-----------------------------------------------------------------
IF r$ = "d" THEN
	IF frdr = 1 THEN
		frdr = 0
	ELSE
		frdr = 1
	END IF
END IF
'-----------------------------------------------------------------
IF r$ = "s" THEN GOSUB saving
'-----------------------------------------------------------------
IF r$ = "h" THEN GOSUB loading
'-----------------------------------------------------------------
IF r$ = oben$ AND sy > 1 THEN
	PUT (wx + 1, wy + sy), hguide, XOR
	sy = sy - 1
	PUT (wx + 1, wy + sy), hguide, XOR
END IF

IF r$ = unten$ AND sy < piy THEN
	PUT (wx + 1, wy + sy), hguide, XOR
	sy = sy + 1
	PUT (wx + 1, wy + sy), hguide, XOR
END IF

IF r$ = links$ AND sx > 1 THEN
	PUT (wx + sx, wy + 1), vguide, XOR
	sx = sx - 1
	PUT (wx + sx, wy + 1), vguide, XOR
END IF

IF r$ = rechts$ AND sx < pix THEN
	PUT (wx + sx, wy + 1), vguide, XOR
	sx = sx + 1
	PUT (wx + sx, wy + 1), vguide, XOR
END IF
'-----------------------------------------------------------------
IF r$ = "8" AND sy >= 1 + stp THEN
	PUT (wx + 1, wy + sy), hguide, XOR
	sy = sy - stp
	PUT (wx + 1, wy + sy), hguide, XOR
END IF

IF r$ = "2" AND sy <= piy - stp THEN
	PUT (wx + 1, wy + sy), hguide, XOR
	sy = sy + stp
	PUT (wx + 1, wy + sy), hguide, XOR
END IF

IF r$ = "4" AND sx >= 1 + stp THEN
	PUT (wx + sx, wy + 1), vguide, XOR
	sx = sx - stp
	PUT (wx + sx, wy + 1), vguide, XOR
END IF

IF r$ = "6" AND sx <= pix - stp THEN
	PUT (wx + sx, wy + 1), vguide, XOR
	sx = sx + stp
	PUT (wx + sx, wy + 1), vguide, XOR
END IF
'-----------------------------------------------------------------
IF frdr = 1 THEN PSET (wx + sx, wy + sy), mcol
'-----------------------------------------------------------------
GOTO 10
'-----------------------------------------------------------------
END
'-----------------------------------------------------------------

'********************************CLIPBOARD***********************************

'============================================================================
'============================== SUB-PROCEDURES ==============================

clbt:
CLS 2
RETURN
'-----------------------------------------------------------------
saving:
	PUT (wx + sx, wy + 1), vguide, XOR
	PUT (wx + 1, wy + sy), hguide, XOR
sur:
	PRINT "SAVE"
	INPUT "Name of file"; nam$
	PRINT "Are you sure (y/n)": sure$ = INPUT$(1)
	IF sure$ <> "y" AND sure$ <> "n" THEN GOTO sur

	IF sure$ = "n" THEN
		PUT (wx + sx, wy + 1), vguide, XOR
		PUT (wx + 1, wy + sy), hguide, XOR
		GOSUB clbt
		GOTO 10
	END IF

	IF sure$ = "y" THEN
		PRINT "Saving in "; nam$; ".phg..."

		OPEN nam$ + ".phg" FOR OUTPUT AS #1
			WRITE #1, pix
			WRITE #1, piy
			FOR x = 1 TO pix
				FOR y = 1 TO piy
					WRITE #1, POINT(wx + x, wy + y)
				NEXT
			NEXT
		CLOSE
	END IF
	PUT (wx + sx, wy + 1), vguide, XOR
	PUT (wx + 1, wy + sy), hguide, XOR
	GOSUB clbt
RETURN
'-----------------------------------------------------------------
loading:
	PUT (wx + sx, wy + 1), vguide, XOR
	PUT (wx + 1, wy + sy), hguide, XOR
demix:
	PRINT "LOAD"
	PRINT "Delete current, or mix (d/m)": delmix$ = INPUT$(1)
	IF delmix$ <> "d" AND delmix$ <> "m" THEN GOTO demix
	IF delmix$ = "m" THEN INPUT "Transparent color: "; tracol
	INPUT "Name of file"; nam$
surs:
	PRINT "Are you sure (y/n)": sure$ = INPUT$(1)
	IF sure$ <> "y" AND sure$ <> "n" THEN GOTO surs

	IF sure$ = "n" THEN
		PUT (wx + sx, wy + 1), vguide, XOR
		PUT (wx + 1, wy + sy), hguide, XOR
		GOSUB clbt
		GOTO 10
	END IF

	IF sure$ = "y" THEN
		PRINT "Loading "; nam$; ".phg..."

		OPEN nam$ + ".phg" FOR INPUT AS #1
			INPUT #1, lpix
			INPUT #1, lpiy
			IF lpix > pix OR lpiy > piy THEN
				PRINT "!!! FILE BIGGER THAN DISPLAY-AREA !!!"
				PRINT "(Press F5 for Proportion-information)"
				p$ = INPUT$(1)
				CLOSE
				GOTO endno
			END IF
			FOR x = 1 TO lpix
				FOR y = 1 TO lpiy
					INPUT #1, picol
					IF delmix$ = "m" THEN
						IF picol = tracol THEN
							GOTO nex
						END IF
						PSET (wx + x, wy + y), picol
						ELSE
						PSET (wx + x, wy + y), picol
					END IF
nex:
				NEXT
			NEXT
		CLOSE
	END IF
endno:  PUT (wx + sx, wy + 1), vguide, XOR
	PUT (wx + 1, wy + sy), hguide, XOR
	GOSUB clbt
RETURN
'-----------------------------------------------------------------
Fehlerbehandlung:
SELECT CASE ERR
	CASE 53
		BEEP
		PRINT "!!! File not found !!!"
		r$ = INPUT$(1)
		GOSUB clbt
		GOTO 10
	CASE ELSE
		BEEP
		PRINT "!!! Unexpected error occurred !!!"
		r$ = INPUT$(1)
		GOSUB clbt
		END'GOTO 10
END SELECT
END

'-----------------------------------------------------------------
circl:
spe:
	PRINT "CIRCLE"
	INPUT "Diameter"; r
	INPUT "Color"; col
	PRINT "Special: Arc, Stretch,... (y/n)": spe$ = INPUT$(1)
	IF spe$ <> "y" AND spe$ <> "n" THEN GOTO spe
	IF spe$ = "y" THEN
		PRINT "Arc (y/n)": bow$ = INPUT$(1)
		IF bow$ = "y" THEN
			INPUT "   Start in degrees"; bows
			INPUT "   End in degrees"; bowe
		ELSE
			bowe = 359
			bows = 0
		END IF
		PRINT "Stretch (y/n)": stre$ = INPUT$(1)
		IF stre$ = "y" THEN
			INPUT "   Y=X*"; verh
		END IF
	END IF
	bows = bows * (3.1416 / 180)
	bowe = bowe * (3.1416 / 180)
	PUT (wx + sx, wy + 1), vguide, XOR
	PUT (wx + 1, wy + sy), hguide, XOR
	IF spe$ = "y" THEN
		IF stre$ = "y" THEN CIRCLE (wx + sx, wy + sy), r, col, bows, bowe, verh
		IF stre$ = "n" THEN CIRCLE (wx + sx, wy + sy), r, col, bows, bowe
	END IF
	IF spe$ = "n" THEN CIRCLE (wx + sx, wy + sy), r, col
	PUT (wx + sx, wy + 1), vguide, XOR
	PUT (wx + 1, wy + sy), hguide, XOR
	GOSUB clbt
RETURN
'-----------------------------------------------------------------
'THAT'S ALL, FOLKS !!!

'VIEW [[SCREEN] (x1!,y1!)-(x2!,y2!) [,[Farbe%] [,Rand%]]]

