#Requires AutoHotkey v2.0
#SingleInstance Force

; Get the current script's process ID
currentPID := DllCall("GetCurrentProcessId", "UInt")

; Check if the script is already running and terminate it
existingPID := ProcessExist(A_ScriptName)
if (existingPID && existingPID != currentPID) {
    ProcessClose(existingPID)
}
; Hotkeys for Right Alt combinations
#HotIf GetKeyState("RAlt", "P")
>!a::Send("ă")
>!+a::Send("Ă")
>!q::Send("â")
>!+q::Send("Â")
>!i::Send("î")
>!+i::Send("Î")
>!e::Send("€")
>!t::Send("ț")
>!+t::Send("Ț")
>!s::Send("ș")
>!+s::Send("Ș")
>!c::Send("©")

#HotIf GetKeyState("RAlt", "P") && GetKeyState("LControl", "P")
s::Send("$")

#HotIf

; Verificare ca ruleaza ca admin, Bo$$ulikă.
if (A_IsAdmin) {
    RunAtStartup()
} else {
    MsgBox("Ăsta trebuie să ruleze ca ADMIN, Bo$$ulikă.")
}
return

RunAtStartup() {
    regKeyPath := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"
    regValueName := "Diacritice"
    scriptFullPath := A_ScriptFullPath

    ; Arată Script path
    MsgBox("Script path: " . scriptFullPath)

    ; Asigurare ca Path-ul exista către script
    if (!FileExist(scriptFullPath)) {
        MsgBox("Error: Script file not found at: " . scriptFullPath)
        return
    }

    try {
        currentValue := RegRead(regKeyPath, regValueName)
    }
    catch {
        currentValue := ""
    }

    ; Mesaj să-ți zică care-i treaba...
    MsgBox("Scriptul asta nu ruleaza la start-up, Faraoane.: " . (currentValue = "" ? "era Path-ul vechi." : currentValue))

    if (currentValue != scriptFullPath) {
        try {
            RegWrite(scriptFullPath, "REG_SZ", regKeyPath, regValueName)
            MsgBox("Am băgat path-ul nou la start-up, Faraoane!")
        }
        catch as err {
            MsgBox("Nu merge scris în registru deoarece și pentru că: " . err.Message)
        }
    } else {
        MsgBox("Script-ul deja rulează la start-up, Faraoane. acum nu tre sa NU ștergi fișieru ăsta, daca-l ștergi, n-are ce sa mai ruleze automat la start-up, nu?")
    }
}
