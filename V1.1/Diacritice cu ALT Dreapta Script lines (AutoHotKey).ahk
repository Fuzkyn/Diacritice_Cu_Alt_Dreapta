#Requires AutoHotkey v2.0
#SingleInstance Off

; Get the current script's process ID
currentPID := DllCall("GetCurrentProcessId", "UInt")

; Check if the script is already running and get the existing PID (no instance checks)
existingPID := ProcessExist(A_ScriptName)

; Check if running as admin, else terminate
if (!A_IsAdmin) {
    MsgBox("Ăsta trebuie să ruleze ca ADMIN, Bo$$ulikă.")
    ProcessClose(currentPID)
    ExitApp()
}

; Store the initial process PID before running
initialPID := currentPID

; Show options to the user with Yes, No, and Cancel (3 options)
choice := MsgBox("Vrei sa-l activezi la start-up? `nYes=Activat(Si pornit) No=Dezactivat(Si oprit)", "Startup Manager", "YesNoCancel")

; Compare the choice using strings
if (choice == "Yes") {
    ; Enable script normally
    RunAtStartup()
} else if (choice == "No") {
    ; Disable script and remove from startup
    RemoveFromStartup()
    MsgBox("Auto start dezactivat `nDiacriticele au fost dezactivate.")

    ; Kill the current script's process and exit
    if (existingPID && existingPID != currentPID) {
        ProcessClose(existingPID)
    }

    ProcessClose(currentPID)
    ExitApp()
} else if (choice == "Cancel") {
    ; If Cancel was pressed, check if the script was previously running
    if (existingPID && existingPID != currentPID) {
        ProcessClose(existingPID)
    } else {
        ProcessClose(currentPID)
    }
} else {
    ; If no recognized value, show it
    MsgBox("Unexpected result from MsgBox. Value: " . choice)
}

#NoTrayIcon  ; Hide tray icon

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

return

RunAtStartup() {
    regKeyPath := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"
    regValueName := "Diacritice"
    scriptFullPath := A_ScriptFullPath

    ; Ensure the path exists for the script
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

    if (currentValue != scriptFullPath) {
        try {
            RegWrite(scriptFullPath, "REG_SZ", regKeyPath, regValueName)
            MsgBox("L-AM BAGAT LA WINDOWS START-UP, Vere!")
        }
        catch as err {
            MsgBox("Nu merge scris în registru deoarece și pentru că: " . err.Message)
        }
    } else {
        MsgBox("Script-ul deja rulează la start-up, Faraoane.")
    }
}

RemoveFromStartup() {
    regKeyPath := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"
    regValueName := "Diacritice"
    try {
        RegDelete(regKeyPath, regValueName)
    }
    catch as err {
        MsgBox("Eroare la ștergerea din registru: " . err.Message)
    }
}
