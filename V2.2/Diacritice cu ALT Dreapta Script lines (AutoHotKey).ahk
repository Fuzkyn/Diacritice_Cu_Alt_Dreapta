#Requires AutoHotkey v2.0
#SingleInstance Force


installFolder := "C:\Program Files\Diacritice"
installExe := installFolder "\Diacritice.exe"
regKeyPath := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"
regValueName := "Diacritice"

if (!A_IsAdmin) {
    try {
        Run("*RunAs " A_ScriptFullPath) 
    } catch {
        MsgBox("Rulează-l ca admin, Bo$$ule.")
    }
    ExitApp()
}

if (A_ScriptFullPath = installExe) {
    return
}

choice := MsgBox("Vrei sa-l activezi la start-up?`nYes = Instaleaza`nNo = Dezinstalează și oprește`nCancel = Nimic(nu-i logic)", "Startup Manager", "YesNoCancel")

if (choice == "Yes") {
    InstallAndRun()
} else if (choice == "No") {
    RemoveFromStartup()
    ExitApp()
} else {
    ExitApp()
}

#NoTrayIcon

InstallAndRun() {
    global installFolder, installExe, regKeyPath, regValueName
    
    if !DirExist(installFolder) {
        RunWait('powershell -Command "New-Item -Path \"' installFolder '\" -ItemType Directory -Force; icacls \"' installFolder '\" /grant Everyone:F /T /C /Q"', , "Hide")
    }

    if (!FileExist(installExe)) {
        copyCmd := 'powershell -Command "Copy-Item -Path \"' A_ScriptFullPath '\" -Destination \"' installExe '\" -Force"'
        RunWait(copyCmd, , "Hide")
    }

    try {
        RegWrite(installExe, "REG_SZ", regKeyPath, regValueName)
        MsgBox("Instalare completă! Diacritice activate.")
    } catch as err {
        MsgBox("Eroare la adăugarea în startup: " . err.Message)
    }
    
    ; Run the installed script and exit installer
    Run(installExe)
    ExitApp()
}

RemoveFromStartup() {
    global installFolder, installExe, regKeyPath, regValueName
    
    ; Remove from Windows startup registry
    try {
        RegDelete(regKeyPath, regValueName)
    } catch as err {
    }

    RunWait('powershell -Command "Stop-Process -Name Diacritice -Force -ErrorAction SilentlyContinue"', , "Hide")

    RunWait('powershell -Command "Remove-Item -Path \"' installFolder '\" -Recurse -Force -ErrorAction SilentlyContinue"', , "Hide")
    
    if (!DirExist(installFolder)) {
        MsgBox("Diacritice a fost dezinstalat complet!")
    } else {
        MsgBox("Eroare: Folderul nu a fost șters. Poate fi blocat de un alt proces.")
    }
}

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
