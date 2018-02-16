#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


#SingleInstance Force
#IfWinActive ahk_exe DarkSoulsII.exe


~LButton::o	 ; the right-hand attack | is made because of superior speed of keyboard keys
~RButton::p   	 ; the left-hand attack | is made because of superior speed of keyboard keys

~WheelUp::     	 ; toggle between the enemies  ( right )
send {9 down}
sleep 30
send {9 up}
return

~WheelDown::  	 ; toggle between the enemies  ( left )
send {6 down}
sleep 30
send {6 up}
return

Capslock::i  	 ; Lock Guard

r::              ; right-hand very strong atack
Send {w down}
sleep 20
Send {f down}
sleep 20
Send {w up}
send {f up}
return

x::		; Break guard right hand
Send {w down}
sleep 20
Send {o down}
sleep 20
Send {w up}
send {o up}
return

LAlt::		; left-hand very strong atack
Send {w down}
sleep 20
Send {c down}
sleep 20
Send {w up}
send {c up}
return

g::		; Break guard left hand
Send {w down}
sleep 20
Send {p down}
sleep 20
Send {w up}
send {p up}
return

F2::Suspend



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;This Section explains the controls of the game which you will have to memorize:
;
;the movemnet is handeled normaly through (WSAD)
;
;use E to interact
;use Q to use items
;
;1 for toggling between walk and normal
;2 for toggling between dash and normal
;
;use the capslock to lock gurad
;
;3 to switch your left hand weapon
;4 to switch your right hand weapon
;5 to switch the spell
;tab to switch your items
;
;use left ctrl to hold your right weapon two-handedly ( press and hold it for the left weapon ) 
;
;click the mouse wheel button centre the camera or if an enemy is in front of you to focus on him
;turn the wheel up and down to switch between several enemies
;
;use the left mouse button for normal attack using right hand
;use the right mouse button for normal attack using left hand
;
;use F for the strong right hand attack
;use C for the strong left hand attack
;
;use R for the very strong right hand attack
;use Left Alt for the very strong left hand attack
;
;use x for breaking the gurad of your enemy using the right hand and G for using the left hand
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;This section explains the configuration of the keybindings that you have to follow in order for the above hotkeys to work correctly:
;
;First section the ( Mouse Section )
;
;Set all keys to Nothing except for the (reset camera/target Lock/release) set it to click Mouse wheel
;
;
;Second section the ( Movement Section )
;
;walk           B
;forward	W
;backward	S
;left		A
;right		D
;dash/....	Space
;Jump		Left Shift
;Auto-walk	1
;Auto-dash	2
;
;
;Third section the ( Camera Section )
;
;Tilt up	7
;Tilt down	8
;Tilt left/..	6
;Tilt right/..	9
;Reset...	0
;
;
;Forth section the ( item section )
;
;spells		5
;items		Tab
;left weapon	3
;right weapon	4
;
;
;Fifth section the ( Fighting Section )
;
;Attack right		O
;Strong Attack right	F
;Attack left		P
;strong Attack left	C
;Use item		Q
;Interact		E
;Wield two-handedly	Left Ctrl
;Lock guard		I
;
;
;Sixth section the ( Menu section )
;
;Open Start Menu	ESC
;Open Gesture Menu	T
;Move cursor up		up arrow
;move cursor down	down arrow
;move cursor left	left arrow
;move cursor right	right arrow
;confirm		Enter
;Cancel			Backspace
;Toggle menu left	N
;Toggle menu right	M
;Function 1		H
;Function 2		J
;
;
;This is all :) :)
;Enjoy!!!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


























