#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode("Event")
ProcessSetPriority("High")
installFolder := EnvGet("APPDATA") "\Diacritice"
installExe := installFolder "\Diacritice.exe"
regKeyPath := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"
regValueName := "Diacritice"
if (A_ScriptFullPath != installExe) {
choice := MsgBox("Vrei sa-l activezi la start-up?nYes = InstaleazanNo = Dezinstalează și oprește`nCancel = Nimic(nu-i logic)", "Startup Manager", "YesNoCancel")
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
#HotIf GetKeyState("RAlt", "P")

!a::Send("ă")
!+a::Send("Ă")
!q::Send("â")
!+q::Send("Â")
!i::Send("î")
!+i::Send("Î")
!e::Send("€")
!t::Send("ț")
!+t::Send("Ț")
!s::Send("ș")
!+s::Send("Ș")
!c::Send("©")

#HotIf GetKeyState("RAlt", "P") && GetKeyState("LControl", "P")
s::Send("$")
#HotIf