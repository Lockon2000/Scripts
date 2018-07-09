#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; ---------------------------------------------------------------------

; +----------------------------------------------------------------------+
; | ** Daily Hotkeys **                                                  |
; | F4: Hotkey to suspend the script                                     |
; | Alt+W: Pin the active window on top of any other window              |
; | Ctrl+Alt+P: Launch PowerShell in Admin mode                          |
; | Ctrl+Alt+S: Launch Sublime Text                                      |
; | Ctrl+Alt+N: Create a new file and run it with the associated program |
; | Ctrl+Shift+S: Open Clipboard with Sublime Text                       |
; |----------------------------------------------------------------------|
; | ** Debungging Hotkeys **                                             |
; | Ctrl+Alt+1                                                           |
; | Ctrl+Alt+2                                                           |
; +----------------------------------------------------------------------+


; Hotkey to suspend the script
F4:: Suspend


; Alt+W: Pin the active window on top of any other window
!w:: Winset, Alwaysontop, TOGGLE, A


; Ctrl+Alt+P: Hotkey to launch PowerShell in Admin mode
; Only run when Windows Explorer or Desktop is active
#IfWinActive ahk_class CabinetWClass
^!p::
#IfWinActive ahk_class ExploreWClass
^!p::
    ; Begin (get current path) -------------
    ; Get full path from open Explorer window
    WinGetText, FullPath, A

    ; Split up result (it returns paths seperated by newlines)
    StringSplit, PathArray, FullPath, `n
    
    ; Find line with backslash which is the path
    Loop, %PathArray0%
    {
        StringGetPos, pos, PathArray%a_index%, \
        if (pos > 0) {
            FullPath:= PathArray%a_index%
            break
        }
    }
    
    ; Clean up result
    FullPath := RegExReplace(FullPath, "(^.+?: )", "")
    StringReplace, FullPath, FullPath, `r, , all
    ; End (get current paht) -------------

    ; Change working directory
    SetWorkingDir, %FullPath%

    ; An error occurred with the SetWorkingDir directive
    if ErrorLevel
        Return

    ; Open the file in the appropriate editor
    Run *RunAs C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe -NoExit -Command "Set-Location '%FullPath%'"

    Return

#IfWinActive ahk_class Progman
^!p::
#IfWinActive ahk_class WorkerW
^!p::
    ; Open the file in the appropriate editor
    Run *RunAs C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe -NoExit -Command "Set-Location 'C:\Users\%A_UserName%\Desktop'"

    Return

#IfWinActive


; Ctrl+Alt+S: Launch Sublime Text
^!s:: Run, "C:\Program Files\Sublime Text 3\sublime_text.exe"


; Ctrl+Alt+N: Create a new file and run it with the associated program
; Only run when Windows Explorer or Desktop is active
; Options:
; -s    to open the created file with sublime text regardless of its associated program
; -c    to just create a file without interacting with it any further
#IfWinActive ahk_class CabinetWClass
^!n::
#IfWinActive ahk_class ExploreWClass
^!n::
    ; Begin (get current path) -------------
    ; Get full path from open Explorer window
    WinGetText, FullPath, A

    ; Split up result (it returns paths seperated by newlines)
    StringSplit, PathArray, FullPath, `n
    
    ; Find line with backslash which is the path
    Loop, %PathArray0%
    {
        StringGetPos, pos, PathArray%a_index%, \
        if (pos > 0) {
            FullPath:= PathArray%a_index%
            break
        }
    }
    
    ; Clean up result
    FullPath := RegExReplace(FullPath, "(^.+?: )", "")
    StringReplace, FullPath, FullPath, `r, , all
    ; End (get current paht) -------------

    ; Change working directory
    SetWorkingDir, %FullPath%

    ; An error occurred with the SetWorkingDir directive
    if ErrorLevel
        Return

    ; Display input box for filename
    InputBox, UserInput, New File, , , 400, 100, , , , ,

    ; User pressed cancel
    if ErrorLevel
        Return

    if InStr(UserInput, " -s") {
        ; Strip UserInput of the -s option
        UserInput := StrReplace(UserInput, " -s", "")

        ; Create file
        FileAppend, , %UserInput%

        ; Open the file in Sublime Text
        Run, "C:\Program Files\Sublime Text 3\sublime_text.exe" %UserInput%
    } else if InStr(UserInput, " -c") {
        ; Strip UserInput of the -s option
        UserInput := StrReplace(UserInput, " -c", "")

        ; Create file
        FileAppend, , %UserInput%
    } else {
        ; Create file
        FileAppend, , %UserInput%

        ; Open the file in the associated program
        Run, %UserInput%
    }

    Return

#IfWinActive ahk_class Progman
^!n::
#IfWinActive ahk_class WorkerW
^!n::
    ; Change working directory
    SetWorkingDir, C:\Users\%A_UserName%\Desktop

    ; An error occurred with the SetWorkingDir directive
    If ErrorLevel
        Return

    ; Display input box for filename
    InputBox, UserInput, New File, , , 400, 100, , , , ,

    ; User pressed cancel
    If ErrorLevel
        Return

    if InStr(UserInput, " -s") {
        ; Strip UserInput of the -s option
        UserInput := StrReplace(UserInput, " -s", "")

        ; Create file
        FileAppend, , %UserInput%

        ; Open the file in Sublime Text
        Run, "C:\Program Files\Sublime Text 3\sublime_text.exe" %UserInput%
    } else if InStr(UserInput, " -c") {
        ; Strip UserInput of the -s option
        UserInput := StrReplace(UserInput, " -c", "")

        ; Create file
        FileAppend, , %UserInput%
    } else {
        ; Create file
        FileAppend, , %UserInput%

        ; Open the file in the associated program
        Run, %UserInput%
    }

    Return

#IfWinActive


; Ctrl+Shift+S: Open Clipboard with Sublime Text
; The Clipboard is restored after the operation
; Only run when Windows Explorer or Desktop is active
#IfWinActive ahk_class CabinetWClass
^+s::
#IfWinActive ahk_class ExploreWClass
^+s::
#IfWinActive ahk_class Progman
^+s::
#IfWinActive ahk_class WorkerW
^+s::
    temp := Clipboard
    Clipboard =     ; Empty the clipboard
    Send, ^c        ; Populate the clipboard with the focused files name
    ClipWait, 0.5   ; Wait up to 0.5 seconds for the clipboard to have content

    if ErrorLevel
    {
        MsgBox, The attempt to copy text onto the Clipboard failed.
        Clipboard := temp
        
        return
    }

    argument =       ; Epmty argument so it doesn't accumulate names over multiple uses
    StringSplit, files, Clipboard, `n
    Loop, %files0%
    {
        argument := argument """" files%a_index% """" A_Space
    }
    argument := StrReplace(argument, "`r", "")

    Run, "C:\Program Files\Sublime Text 3\sublime_text.exe" %argument%

    Clipboard := temp

    return

#IfWinActive



;------------------------------------------------------------------
; Tools for developing
; Only uncomment when needed

; ^!r::Reload  ; Assign Ctrl-Alt-R as a hotkey to restart the script.

; ^!1::


; ^!2::


; ^!3::
