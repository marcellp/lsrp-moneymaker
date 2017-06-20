; cmd_flooder
; (c) 2015 krook, Seedjo
; this script makes it easy to abuse a script vulnerability on LS-RP
; this code repeatedly sends the command that can be used to abuse the vulnerability
; it also keeps track of the money you've earned in the process
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

#IfWinActive ahk_exe gta_sa.exe

SetWorkingDir %A_ScriptDir%

global terminate = 0
global count = 0
global started := false

start()
{
	started := true
	count ++
	sendChatMessage("/delivercar")
}

stop(dropoff = 0)
{
	started := false
	terminate = 1
	if(dropoff = 1)
	{
		sendChatMessage("/dropoff")
		addMessageToChatWindow("{DFF3FF}* (( Money making has been stopped, /dropoff used. ))")
	}
	else
	{
		addMessageToChatWindow("{DFF3FF}* (( Money making has been paused. ))")
	}
	terminate = 1
}

^1::
	if(!isInChat())
	{
		terminate = 0
		Loop
		{
			if terminate = 1
			{
				break
			}
			else
			{
				if(isPlayerInAnyVehicle() && isPlayerDriver())
				{
					start()
					if(getVehicleModelName() = "Sultan")
					{
						addMessageToChatWindow("{DFF3FF}* (( Count: " count " - Sultan: $" count*5800 " ))")
					}
					else
					{
						addMessageToChatWindow("{DFF3FF}* (( Count: " count " - Cheetah: $" count*6800 " ))")
					}
					
					IniRead, Sleep2, MONEY.ini, Main, Wait
					Sleep := Sleep2*1000
					Sleep, %Sleep%
				}
				else
					return
			}
		}
	}
return

^2::
	if(!isInChat() && started)
	{
		stop()
	}
return

^3::
	if(!isInChat())
	{
		count := 0
		stop(1)
	}
return
