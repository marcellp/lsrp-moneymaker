; gui
; (c) 2015 6i7kh, krook, Seedjo
; this script makes it easy to abuse a script vulnerability on LS-RP
; this code contains the graphical user interface of the utility
;
; This file is part of Moneymaker (lsrp-moneymaker).
; Moneymaker is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License along
; with this program; if not, write to the Free Software Foundation, Inc.,
; 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

#UseHook
#NoEnv
#SingleInstance force

SetWorkingDir %A_ScriptDir%

Gui, Font, S16 CDefault, Verdana
Gui, Font, S16 CDefault, Verdana
Gui, Font, S25 CDefault, Verdana
Gui, Font, S25, Verdana
Gui, Font, S25, Verdana
Gui, Add, Text, x102 y9 w240 h40 +Center, Moneymaker
Gui, Font, S12, Verdana
Gui, Font, S10, Verdana
Gui, Add, Text, x102 y49 w240 h20 +Center, Copyright 2015-16 © Seedjo
Gui, Font, S6, Verdana
Gui, Font, S8, Verdana
Gui, Add, Text, x102 y69 w240 h70 +Center, This software comes with ABSOLUTELY NO WARRANTY. This is free software`, and you are welcome to redistribute it under certain conditions (see the attached LICENSE file for more details).
Gui, Add, Text, x72 y149 w30 h20 , Wait
IniRead, Sleep2, MONEY.ini, Main, Wait
Gui, Add, Edit, vSleepy x112 y149 w60 h20 , %Sleep2%
Gui, Add, Text, x182 y149 w200 h20 , seconds between two commands.
Gui, Add, Text, x67 y209 w310 h20 +Center, CTRL+1: start sending the command
Gui, Add, Text, x67 y239 w310 h20 +Center, CTRL+2: pause command flood
Gui, Add, Text, x67 y269 w310 h20 +Center, CTRL+3: send /delivercar and reset the counter
Gui, Add, Text, x67 y299 w310 h20 +Center, CTRL+4: show all boards on the map
Gui, Add, Text, x67 y329 w310 h20 +Center, CTRL+5: mark board as visited
Gui, Add, Text, x67 y359 w310 h20 +Center, CTRL+6: remove all board positions
Gui, Add, Button, x72 y179 w80 h20 , Set
Gui, Add, Button, x292 y179 w90 h20 , Reset Counter
Gui, Show, x363 y248 h400 w449, Moneymaker
