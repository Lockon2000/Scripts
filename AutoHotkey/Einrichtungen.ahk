#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; ---------------------------------------------------------------------

; +----------------------------------------------------------------------+
; | ** Daily Hotkeys **                                                  |
; | F4: Hotkey to suspend the script                                     |
; | Alt+W: Pin the active window on top of any other window              |
; | Ctrl+Alt+P: Hotkey to launch PowerShell in Admin mode                |
; | Ctrl+Alt+N: Create a new file and run it with the associated program |
; | Ctrl+Alt+S: Open clipboard with Sublime Text                         |
; |----------------------------------------------------------------------|
; | ** Debungging Hotkeys **                                             |
; | Ctrl+Alt+1                                                           |
; | Ctrl+Alt+2                                                           |
; +----------------------------------------------------------------------+


; Hotkey to suspend the script
F4:: Suspend


; Pin the active window on top of any other window
!w:: Winset, Alwaysontop, TOGGLE, A


; Hotkey to launch PowerShell in Admin mode
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
    If ErrorLevel
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


; Create a new file and run it with the associated program
; Only run when Windows Explorer or Desktop is active
; Options:
; -s    to open the created file with sublime text regardless of its associated program
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
    If ErrorLevel
        Return

    ; Display input box for filename
    InputBox, UserInput, New File, , , 400, 100, , , , ,

    ; User pressed cancel
    If ErrorLevel
        Return

    If InStr(UserInput, " -s") {
        ; Strip UserInput of the -s option
        UserInput := StrReplace(UserInput, " -s", "")

        ; Create file
        FileAppend, , %UserInput%

        ; Open the file in Sublime Text
        Run, "C:\Program Files\Sublime Text 3\sublime_text.exe" %UserInput%
    } Else {
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

    If InStr(UserInput, " -s") {
        ; Strip UserInput of the -s option
        UserInput := StrReplace(UserInput, " -s", "")

        ; Create file
        FileAppend, , %UserInput%

        ; Open the file in Sublime Text
        Run, "C:\Program Files\Sublime Text 3\sublime_text.exe" %UserInput%
    } Else {
        ; Create file
        FileAppend, , %UserInput%

        ; Open the file in the associated program
        Run, %UserInput%
    }

    Return

#IfWinActive


; Ctrl+Alt+S: Open clipboard with Sublime Text
; Only run when Windows Explorer or Desktop is active
#IfWinActive ahk_class CabinetWClass
^!s::
#IfWinActive ahk_class ExploreWClass
^!s::
#IfWinActive ahk_class Progman
^!s::
#IfWinActive ahk_class WorkerW
^!s::
    clipboard =     ; Empty the clipboard
    Send, ^c        ; Populate the clipboard with the focused files name
    ClipWait, 0.5   ; Wait up to 0.5 seconds for the clipboard to have content
    if ErrorLevel
    {
        MsgBox, The attempt to copy text onto the clipboard failed.
        return
    }
    clipboard := StrReplace(clipboard, "`r`n", A_space)     ; For the case of multiselection
    Run, "C:\Program Files\Sublime Text 3\sublime_text.exe" %clipboard%
    return

#IfWinActive



;------------------------------------------------------------------
; Tools for developing
; Only uncomment when needed

; ^!1::
;     clipboard = 
;     Send, ^c
;     ClipWait ;waits for the clipboard to have content
;     Run, "C:\Program Files\Sublime Text 3\sublime_text.exe" %clipboard%

;     return


; ^!2::
;     clipboard =     ; Empty the clipboard
;     Send, ^c        ; Populate the clipboard with the focused files name
;     ClipWait, 0.5   ; Wait up to 0.5 seconds for the clipboard to have content
;     if ErrorLevel
;     {
;         MsgBox, The attempt to copy text onto the clipboard failed.
;         return
;     }
;     clipboard := StrReplace(clipboard, "`r`n", A_space)
;     MsgBox, %clipboard%

;     return

