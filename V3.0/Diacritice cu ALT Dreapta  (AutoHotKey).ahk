#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode("Event")
SetKeyDelay(0, 50)
ProcessSetPriority("High")

installFolder := EnvGet("APPDATA") "\Diacritice"
installExe := installFolder "\Diacritice.exe"
regKeyPath := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"
regValueName := "Diacritice"

if (A_ScriptFullPath != installExe) {
	choice := MsgBox("Vrei sa-l activezi la start-up?`nYes = Instaleaza`nNo = Dezinstalează și oprește`nCancel = Nimic(nu-i logic)", "Startup Manager", "YesNoCancel")
	if (choice == "Yes") {
		InstallAndRun()
	} else if (choice == "No") {
		RemoveFromStartup()
	} else {
		ExitApp()
	}
}

#NoTrayIcon

InstallAndRun() {
	global installFolder, installExe, regKeyPath, regValueName
	
	try {
		if !DirExist(installFolder) {
			DirCreate(installFolder)
		}
		if (!FileExist(installExe)) {
			FileCopy(A_ScriptFullPath, installExe, 1)
		}
		RegWrite(installExe, "REG_SZ", regKeyPath, regValueName)
		MsgBox("Instalare completă! Diacritice activate.")
	} catch as err {
		MsgBox("Eroare la instalare: " . err.Message)
		return
	}
	
	try {
		Run(installExe)
	} catch as err {
		MsgBox("Eroare la pornirea scriptului instalat: " . err.Message)
	}
	ExitApp()
}

RemoveFromStartup() {
	global installFolder, installExe, regKeyPath, regValueName
	
	try {
		RegDelete(regKeyPath, regValueName)
	} catch {
	}

	currentPid := DllCall("GetCurrentProcessId")
	while (pid := ProcessExist("Diacritice.exe")) {
		try {
			if (ProcessGetPath(pid) == installExe && pid != currentPid) {
				ProcessClose(pid)
			}
		}
	}

	try {
		if FileExist(installExe) {
			FileDelete(installExe)
		}
		if DirExist(installFolder) {
			DirDelete(installFolder, 1)
		}
	} catch as err {
		MsgBox("Eroare la ștergere: " . err.Message)
		return
	}
	
	if (!DirExist(installFolder)) {
		MsgBox("Diacritice a fost dezinstalat complet!")
	} else {
		MsgBox("Eroare: Folderul nu a fost șters complet. Poate fi blocat.")
	}
	ExitApp()
}

; =========================
; Prevent RAlt-alone from changing focus while keeping RAlt combos working
; Strategy:
;  - On RAlt down: send vk07 (harmless) so Windows sees "a key was pressed" between Alt down/up -> cancels menu/focus behavior
;  - On RAlt up: swallow if no combo occurred
; =========================
raltUsed := false

~RAlt::
{
	global raltUsed
	raltUsed := false
	; Send a dummy key to cancel Windows' Alt menu behavior
	Send("{vk07}")
	return
}

~RAlt up::
{
	global raltUsed
	if (!raltUsed) {
		; Swallow solo Alt release so no menu/focus changes occur
		return
	}
	; If a combo was used, let the Alt-up pass through normally
}

#HotIf GetKeyState("RAlt", "P")
>!a::
{
	global raltUsed
	raltUsed := true
	Send("ă")
}
>!+a::
{
	global raltUsed
	raltUsed := true
	Send("Ă")
}
>!q::
{
	global raltUsed
	raltUsed := true
	Send("â")
}
>!+q::
{
	global raltUsed
	raltUsed := true
	Send("Â")
}
>!i::
{
	global raltUsed
	raltUsed := true
	Send("î")
}
>!+i::
{
	global raltUsed
	raltUsed := true
	Send("Î")
}
>!e::
{
	global raltUsed
	raltUsed := true
	Send("€")
}
>!t::
{
	global raltUsed
	raltUsed := true
	Send("ț")
}
>!+t::
{
	global raltUsed
	raltUsed := true
	Send("Ț")
}
>!s::
{
	global raltUsed
	raltUsed := true
	Send("ș")
}
>!+s::
{
	global raltUsed
	raltUsed := true
	Send("Ș")
}
>!c::
{
	global raltUsed
	raltUsed := true
	Send("©")
}
#HotIf

#HotIf GetKeyState("RAlt", "P") && GetKeyState("LControl", "P")
s::
{
	global raltUsed
	raltUsed := true
	Send("$")
}
#HotIf