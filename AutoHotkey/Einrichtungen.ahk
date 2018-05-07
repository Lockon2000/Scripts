#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; ---------------------------------------------------------------------

; +----------------------------------------------------------------------+
; | F4: Hotkey to suspend the script                                     |
; | Alt+W: Pin the active window on top of any other window              |
; | Ctrl+Alt+P: Hotkey to launch PowerShell in Admin mode                |
; | Ctrl+Alt+N: Create a new file and run it with the associated program |
; |----------------------------------------------------------------------|
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
#IfWinActive ahk_class CabinetWClass
^!n::
#IfWinActive ahk_class ExploreWClass
^!n::
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

    ; Create file
    FileAppend, , %UserInput%

    ; Open the file in the appropriate editor
    Run %UserInput%

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

    ; Create file
    FileAppend, , %UserInput%

    ; Open the file in the appropriate editor
    Run %UserInput%

    Return

#IfWinActive


;------------------------------------------------------------------
; Tools for developing
; Only uncomment when needed

; Print the AHK_Class of the active Window in a Massege Box
; ^!1::
;     WinGetClass, t, A
;     MsgBox, %t%
; 
;     return


; Print the current username in a Massege Box
; ^!2::
;     MsgBox, %A_UserName%
; 
;     return

