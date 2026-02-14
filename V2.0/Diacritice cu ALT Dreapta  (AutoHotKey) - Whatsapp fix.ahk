#Requires AutoHotkey v2.0
#SingleInstance Force
#NoTrayIcon

; ==============================================================================
; SETTINGS
; ==============================================================================
SendMode("Input")
ProcessSetPriority("High")

installFolder := EnvGet("APPDATA") "\Diacritice"
installExe := installFolder "\Diacritice.exe"
regKeyPath := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"
regValueName := "Diacritice"

; ==============================================================================
; INSTALL CHECK
; ==============================================================================
if (A_ScriptFullPath != installExe)
{
    choice := MsgBox("Vrei sa-l activezi la start-up?`nYes = Instaleaza`nNo = Dezinstalează și oprește`nCancel = Nimic(nu-i logic)", "Startup Manager", "YesNoCancel")
    if (choice == "Yes")
    {
        InstallAndRun()
    }
    else if (choice == "No")
    {
        RemoveFromStartup()
    }
    else
    {
        ExitApp()
    }
}

; ==============================================================================
; FUNCTIONS
; ==============================================================================
InstallAndRun()
{
    global installFolder, installExe, regKeyPath, regValueName
    try
    {
        if !DirExist(installFolder)
            DirCreate(installFolder)
        
        if (!FileExist(installExe))
            FileCopy(A_ScriptFullPath, installExe, 1)
            
        RegWrite(installExe, "REG_SZ", regKeyPath, regValueName)
        MsgBox("Instalare completă! Diacritice activate.")
    }
    catch Error as err
    {
        MsgBox("Eroare la instalare: " . err.Message)
        return
    }

    try
    {
        Run(installExe)
    }
    catch Error as err
    {
        MsgBox("Eroare la pornirea scriptului instalat: " . err.Message)
    }
    ExitApp()
}

RemoveFromStartup()
{
    global installFolder, installExe, regKeyPath, regValueName
    
    try
    {
        RegDelete(regKeyPath, regValueName)
    }
    catch
    {
        ; Ignore errors if key doesn't exist
    }

    currentPid := DllCall("GetCurrentProcessId")
    while (pid := ProcessExist("Diacritice.exe"))
    {
        try
        {
            if (ProcessGetPath(pid) == installExe && pid != currentPid)
            {
                ProcessClose(pid)
            }
        }
    }

    try
    {
        if FileExist(installExe)
            FileDelete(installExe)
            
        if DirExist(installFolder)
            DirDelete(installFolder, 1)
    }
    catch Error as err
    {
        MsgBox("Eroare la ștergere: " . err.Message)
        return
    }
    
    if (!DirExist(installFolder))
    {
        MsgBox("Diacritice a fost dezinstalat complet!")
    }
    else
    {
        MsgBox("Eroare: Folderul nu a fost șters complet. Poate fi blocat.")
    }
    ExitApp()
}

; ==============================================================================
; HOTKEYS & LOGIC
; ==============================================================================

; 1. Block RAlt entirely to prevent Windows focus menus
RAlt::return

; 2. Define hotkeys checking the PHYSICAL state of RAlt
#HotIf GetKeyState("RAlt", "P")

a::Send("{Text}ă")
+a::Send("{Text}Ă")

q::Send("{Text}â")
+q::Send("{Text}Â")

i::Send("{Text}î")
+i::Send("{Text}Î")

e::Send("{Text}€")

t::Send("{Text}ț")
+t::Send("{Text}Ț")

s::Send("{Text}ș")
+s::Send("{Text}Ș")

c::Send("{Text}©")

#HotIf

; 3. Secondary Layer (RAlt + LCtrl)
#HotIf GetKeyState("RAlt", "P") && GetKeyState("LControl", "P")

s::Send("{Text}$")

#HotIf