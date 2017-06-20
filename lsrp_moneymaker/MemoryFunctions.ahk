writeByteCode(handle, address, byteCodeAsString) {
	StringReplace, byteCodeAsString, byteCodeAsString, %A_SPACE%, , All
	StringReplace, byteCodeAsString, byteCodeAsString, x, , All
	StringReplace, byteCodeAsString, byteCodeAsString, \, , All
	byteCodeLen := StrLen(byteCodeAsString)/2
	VarSetCapacity(injectInstruction, byteCodeLen, 0)
	Loop %byteCodeLen% {
		oneByte := SubStr(byteCodeAsString, ((A_INDEX-1)*2)+1, 2)
		oneByte := "0x" oneByte
		NumPut(oneByte, injectInstruction, A_INDEX-1, "UChar")

	}
	writeRaw(handle, address, &injectInstruction, byteCodeLen)
}

GetAdressOfDLLByWindowName(windowName, DllName) {
	WinGet, pid, pid, %windowName%
	Return GetAdressByProcessID(pid, DllName)
}

GetAdressByProcessID(pid, DllName) {
	VarSetCapacity(me32, 548, 0)
	NumPut(548, me32)
	snapMod := DllCall("CreateToolhelp32Snapshot", "Uint", 0x00000008, "Uint", pid)

	if (snapMod = -1) {
		return 0
	}

	if (DllCall("Module32First", "Uint", snapMod, "Uint", &me32)) {
		Loop {
			if (!DllCall("lstrcmpi", "Str", DllName, "UInt", &me32 + 32)) {
				DllCall("CloseHandle", "UInt", snapMod)
				return NumGet(&me32 + 20)
			}
		}
		Until !DllCall("Module32Next", "Uint", snapMod, "UInt", &me32)
	}
	DllCall("CloseHandle", "Uint", snapMod)
	return 0
}

OpenHandleByName(windowName , dwDesiredAccess = 0x1F0FFF) {
	WinGet, pid, pid, %windowName%
	handle := DllCall("OpenProcess", "Uint", dwDesiredAccess, "int", 0, "int", pid)
	return handle
}

CloseHandle(handle) {
	DllCall("CloseHandle", "UInt", handle)
}

; some of the following functions are provided by sodcheats@github
; https://github.com/sodcheats/autohotkey/blob/master/Lib/Memory.ahk

Memory_Read(process_handle, address) {
	VarSetCapacity(value, 4, 0)
	DllCall("ReadProcessMemory", "UInt", process_handle, "UInt", address, "Str", value, "UInt", 4, "UInt *", 0)
	return, NumGet(value, 0, "Int")
}
Memory_ReadByte(process_handle, address) {
	VarSetCapacity(value, 1, 0)
	DllCall("ReadProcessMemory", "UInt", process_handle, "UInt", address, "Str", value, "UInt", 1, "UInt *", 0)
	return, NumGet(value, 0, "Byte")
}
Memory_ReadWord(process_handle, address) {
	VarSetCapacity(value, 2, 0)
	DllCall("ReadProcessMemory", "UInt", process_handle, "UInt", address, "Str", value, "UInt", 2, "UInt *", 0)
	return, NumGet(value, 0, "Byte")
}
Memory_ReadFloat(process_handle, address) {
	VarSetCapacity(value, 4, 0)
	DllCall("ReadProcessMemory", "UInt", process_handle, "UInt", address, "Str", value, "UInt", 4, "UInt *", 0)
	return, NumGet(value, 0, "Float")
}

Memory_Write(process_handle, address, value) {
	DllCall("VirtualProtectEx", "UInt", process_handle, "UInt", address, "UInt", 4, "UInt", 0x04, "UInt *", 0) ; PAGE_READWRITE
	DllCall("WriteProcessMemory", "UInt", process_handle, "UInt", address, "UInt *", value, "UInt", 4, "UInt *", 0)
}

Memory_WriteEx(process_handle, address, value, size) {
	DllCall("VirtualProtectEx", "UInt", process_handle, "UInt", address, "UInt", size, "UInt", 0x04, "UInt *", 0) ; PAGE_READWRITE
	DllCall("WriteProcessMemory", "UInt", process_handle, "UInt", address, "UInt *", value, "UInt", size, "UInt *", 0)
}

Memory_WriteByte(process_handle, address, value) {
	DllCall("VirtualProtectEx", "UInt", process_handle, "UInt", address, "UInt", 1, "UInt", 0x04, "UInt *", 0) ; PAGE_READWRITE
	DllCall("WriteProcessMemory", "UInt", process_handle, "UInt", address, "UInt *", value, "UInt", 1, "UInt *", 0)
}

Memory_WriteWord(process_handle, address, value) {
	DllCall("VirtualProtectEx", "UInt", process_handle, "UInt", address, "UInt", 2, "UInt", 0x04, "UInt *", 0) ; PAGE_READWRITE
	DllCall("WriteProcessMemory", "UInt", process_handle, "UInt", address, "UInt *", value, "UInt", 2, "UInt *", 0)
}

Memory_WriteFloat(process_handle, address, value) {
    value := FloatToHex(value)
    DllCall("VirtualProtectEx", "UInt", process_handle, "UInt", address, "UInt", 4, "UInt", 0x04, "UInt *", 0)
    DllCall("WriteProcessMemory", "UInt", process_handle, "UInt", address, "UInt *", value, "UInt", 4, "UInt *", 0)
}

Memory_ReadString(process_handle, address, size) {
	VarSetCapacity(value, size, 0)
	DllCall("ReadProcessMemory", "UInt", process_handle, "UInt", address, "Str", value, "UInt", size, "UInt *", 0)
	Loop, %size%
	{
		current_value := NumGet(value, A_Index - 1, "UChar")
		if (current_value = 0) {
			break
		}
		result .= Chr(current_value)
	}
	return result
}

FloatToHex(value) {
   format := A_FormatInteger
   SetFormat, Integer, H
   result := DllCall("MulDiv", Float, value, Int, 1, Int, 1, UInt)
   SetFormat, Integer, %format%
   return, result
}
IntToHex(int)
{
	CurrentFormat := A_FormatInteger
	SetFormat, integer, hex
	int += 0
	SetFormat, integer, %CurrentFormat%
	return int
}
