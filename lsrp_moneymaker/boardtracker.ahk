; boardtracker
; (c) 2015 6i7kh, Seedjo
; this script makes it easy to abuse a script vulnerability on LS-RP
; this code keeps track of all the car thief boards you've visited
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

;Coordinates of the boards on the map (that we know of)
global boardPositions := [ [2183.4619,-1516.1774,23.6058,0]
, [2413.3479,-1426.4052,23.6897,0]
, [2600.1912,-1406.1045,35.7142,0]
, [2608.9546,-1392.0594,34.5126,0]
, [2504.0425,-1705.7971,13.2479,0]
, [2499.6772,-1975.3489,14.6093,0]
, [2199.2361,-1973.5842,13.2623,0]
, [2601.5684,-2346.4102,13.4124,0]
, [2629.3789,-2225.8552,13.5469,0]
, [1605.2778,-2156.2234,13.2854,0]
, [290.5304,-1604.0482,17.5636,0]
, [2164.1025,-105.8842,2.4345,0]
, [-1705.2948,0.4792,3.2569,0]
, [-1724.3280,-4.5153,3.2760,0]
, [-1472.5282,366.1645,6.8923,0]
, [-2744.6853,132.6124,4.5832,0]
, [-2739.8242,131.5425,4.5391,0]
, [-2182.9626,-222.0142,36.5156,0]
, [-1827.6444,-1618.3636,22.7213,0]
, [-621.3506,-512.9147,25.5178,0]
, [-620.7587,-523.2788,25.5178,0]
, [-620.8422,-535.3288,25.5234,0] ]


;Some magic numbers
global windowNameOfSAMP := "GTA:SA:MP"
global nameOfSAMPDLL := "samp.dll"
global iconsLoaded := false

/*
    CMarker pool:
    Item size: 0x28 (40 bytes)
    Pool start: 0xBA86F0 
    Pool size: 175 items

    struct RadarMarker {
        DWORD dwColourID;           // 0
        DWORD* pEntity;             // 4
        float fPosX;                // 8
        float fPosY;                // 12
        float fPosZ;                // 16
        short wFlag;                // 20
        short _wAlign;              // 22
        float fUnknown;             // 24 (either 1.0 or 5.0)
        DWORD dwIconSize;           // 28
        DWORD *pEnterExit;          // 32
        BYTE byteIcon;              // 36
        BYTE byteFlags;             // 37
        BYTE byteType;              // 38
        BYTE _bAlign;               // 39
    };
     
    enum eMarkerDisplayFlags // R*'s eMARKER_DISPLAY
    {
        MARKER_DISPLAY_NEITHER=0, 
        MARKER_DISPLAY_MARKERONLY,
        MARKER_DISPLAY_BLIPONLY,  
        MARKER_DISPLAY_BOTH
    };

    enum eByteType
    {
        MARKER_TYPE_UNUSED,
        MARKER_TYPE_CAR, 
        MARKER_TYPE_CHAR, 
        MARKER_TYPE_OBJECT, 
        MARKER_TYPE_COORDS,
        MARKER_TYPE_CONTACT,
        MARKER_TYPE_SEARCHLIGHT,
        MARKER_TYPE_PICKUP,
        MARKER_TYPE_AIRSTRIP
    };
*/

findMapiconGivenCoords(x, y)
{
    IconID := 0
    
    gtaHandle := OpenHandleByName(windowNameOfSAMP) 
    Loop,
    {
        if IconID > 175
        {
            break
        }
        
        mapX := Memory_ReadFloat(gtaHandle, 0xBA86F0 + (IconID * 0x28) + 0x08)  
        mapY := Memory_ReadFloat(gtaHandle, 0xBA86F0 + (IconID * 0x28) + 0x0C)
                
        if( Floor(mapX) == Floor(x) && Floor(mapY) == Floor(y) )
        {
            CloseHandle(gtaHandle)
            return IconID
        }
        
        IconID++        
    }
    
    CloseHandle(gtaHandle)
    return 0
}

destroyBlip(blipID)
{
    gtaHandle := OpenHandleByName(windowNameOfSAMP)
    
    Memory_WriteFloat(gtaHandle, 0xBA86F0 + (blipID * 0x28) + 8, 0.0 ) ;fPosZ
    Memory_WriteFloat(gtaHandle, 0xBA86F0 + (blipID * 0x28) + 12, 0.0 ) ;fPosZ
    Memory_WriteFloat(gtaHandle, 0xBA86F0 + (blipID * 0x28) + 16, 0.0 ) ;fPosZ
    
    Memory_Write(gtaHandle, 0xBA86F0 + (blipID * 0x28) + 28, 0 ) ;dwIconSize
    Memory_Write(gtaHandle, 0xBA86F0 + (blipID * 0x28) + 0, 0 ) ;dwColorID
    
    Memory_WriteByte(gtaHandle, 0xBA86F0 + (blipID * 0x28) + 38, 0 ) ;MARKER_TYPE_UNUSED
    Memory_WriteByte(gtaHandle, 0xBA86F0 + (blipID * 0x28) + 37, 0 ) ;MARKER_DISPLAY_NEITHER
    Memory_WriteByte(gtaHandle, 0xBA86F0 + (blipID * 0x28) + 36, 0 ) ;MARKER_SPRITE_NONE
    
    CloseHandle(gtaHandle)
}

^4::
    if(isInChat())
    {
        SendInput, ^4
        return
    }
     
    if( iconsLoaded == true )
    {
        addMessageToChatWindow("{D3212D}* (( The icons have already been loaded. ))")
        return
    }
    gtaHandle := OpenHandleByName(windowNameOfSAMP)
    
    ;for some reason, you need to call this once for this thing to work the first time
    ;type = 3 (MARKER_DISPLAY_BOTH)
    ;callWithParams(gtaHandle, 0x583820, [["i", 4], ["i", 0], ["i", 0], ["i", 0], ["i", 0], ["i", 3], ["i", 8] ], true)
	
    For row, subArray in boardPositions
    {
        callWithParams(gtaHandle, 0x583820, [["i", 4], ["i", FloatToHex(subArray[1])], ["i", FloatToHex(subArray[2])], ["i", subArray[3]], ["i", 0], ["i", 3], ["i", 8] ], true)
         
        ;this sleep is needed so that the mapicon can be initialized properly before the rest of the loop runs
        ;it didn't work with ahk's Sleep and I have no idea why
        showGameText("~y~Loading...", 1000, 4)
        
        ;this is a pretty shitty way to solve the problem but callWithParams doesn't handle function returns :(
        subArray[4] := findMapiconGivenCoords(subArray[1], subArray[2])
                
        ;the default function doesn't handle the z coordinate properly
        Memory_WriteFloat(gtaHandle, 0xBA86F0 + (subArray[4] * 0x28) + 16, subArray[3] ) ;fPosZ
        
        ;make it the right size and the right color
        Memory_Write(gtaHandle, 0xBA86F0 + (subArray[4] * 0x28) + 28, 3 ) ;dwIconSize
        Memory_Write(gtaHandle, 0xBA86F0 + (subArray[4] * 0x28) + 0, 0xFFFF00FF ) ;dwColorID
    }
	
    iconsLoaded := true
    showGameText("~g~Loaded", 3000, 4)

    CloseHandle(gtaHandle)  
return

^5::
    if(isInChat())
    {
        SendInput, ^5
        return
    }
    
    pPos := getCoordinates()
    
    nearBoard := 0
    
    For row, subArray in boardPositions
    {
        distance := sqrt((pPos[1]-subArray[1])**2+(pPos[2]-subArray[2])**2)
        
        if( distance <= 20.0 && subArray[4] != 0  )
        {
            nearBoard := row
        }
    }
    

    if( nearBoard == 0 )
    {
        addMessageToChatWindow("{D3212D}* (( You are not near any of the boards. ))")
        return
    }
        
    ;destroy the blip & the reference to the blip
    destroyBlip(boardPositions[nearBoard][4])
    boardPositions[nearBoard][4] := 0
    addMessageToChatWindow("{00FF00}* (( Position marked as visited. ))")
    
    CloseHandle(gtaHandle)
    
return

^6::
    if(isInChat())
    {
        SendInput, ^6
        return
    }
    
    if( iconsLoaded == false )
    {
        addMessageToChatWindow("{D3212D}* (( The icons haven't been loaded yet. ))")
        return
    }
    
    gtaHandle := OpenHandleByName(windowNameOfSAMP)
    
    For row, subArray in boardPositions
    {
        if( subArray[4] != 0 )
        {
            ;destroy the blip & the refernece to the blip
            destroyBlip(subArray[4])
            subArray[4] := 0
        }
    }
    
    CloseHandle(gtaHandle)
    
    addMessageToChatWindow("{00FF00}* (( All blips have been successfully destroyed. ))")
    iconsLoaded := false
return
