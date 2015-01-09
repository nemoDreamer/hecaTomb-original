' LrgShow (.PHG displayer)
' ========================
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

