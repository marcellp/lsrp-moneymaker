; gui_handler
; (c) 2015 6i7kh, krook, Seedjo
; this script makes it easy to abuse a script vulnerability on LS-RP
; this file is responsible for handling all GUI events in the program
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

GuiClose:
	ExitApp
return

ButtonSet:
	Gui, Submit, NoHide
	IniWrite, %Sleepy%, MONEY.ini, Main, Wait
	MsgBox, 64, MONEY, Time set.
return

ButtonResetCounter:
	count = 0
	MsgBox, 64, MONEY, The counter has been reset.
return
