SCREEN 9

10
locate 11,5
input "Picture without extention ";pic$
if pic$="" then end
locate 13,5
input "Zoom in ";stretch
cls

OPEN pic$ + ".phg" FOR INPUT AS #1
        INPUT #1, xpic
        INPUT #1, ypic
        FOR x = 1 TO xpic
                FOR y = 1 TO ypic
                        INPUT #1, col
			LINE (x * stretch-stretch, y * stretch-stretch)-STEP(stretch - 1, stretch - 1), col, BF
                NEXT
        NEXT
CLOSE

r$=input$(1)
goto 10

