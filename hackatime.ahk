#Requires AutoHotkey v2.0
SendMode "Input"

; ===================================
; React Code Typing + Idle Cursor Movement Script
; ===================================

; snippet.txt must be saved with LF line endings (not CRLF)
codeText := FileRead(A_ScriptDir "\fah.txt")

global typedLength := 0
global cursorMoving := true
global isPaused := false
global isTyping := false

; Start cursor movement automatically when script launches
SetTimer(MoveCursorRandomly, 15000)

; ---- Hotkey: Ctrl+Alt+T to type code ----
^!t::
{
    global typedLength, isTyping
    typedLength := 0
    if WinExist("ahk_exe Code.exe")
        WinActivate
    Sleep 300
    isTyping := true
    TypeLikeHuman(codeText)
    isTyping := false
}

; ---- Hotkey: Ctrl+Alt+D to delete typed code ----
^!d::
{
    global typedLength
    DeleteTyped(typedLength)
}

; ---- Hotkey: Ctrl+Alt+P to pause/resume typing ----
^!p::
{
    global isPaused, isTyping
    if isTyping
    {
        isPaused := !isPaused
        ToolTip(isPaused ? "Typing paused" : "Typing resumed")
        SetTimer(ClearToolTip, -1000)
    }
}

; ---- Hotkey: Ctrl+Alt+M to toggle cursor movement ----
^!m::
{
    global cursorMoving
    cursorMoving := !cursorMoving
    if cursorMoving
    {
        SetTimer(MoveCursorRandomly, 15000)
        ToolTip("Cursor movement ON")
    }
    else
    {
        SetTimer(MoveCursorRandomly, 0)
        ToolTip("Cursor movement OFF")
    }
    SetTimer(ClearToolTip, -1000)
}

ClearToolTip() {
    ToolTip()
}

TypeLikeHuman(text) {
    global typedLength, isPaused
    Loop Parse, text
    {
        while (isPaused)
            Sleep 100

        ch := A_LoopField
        SendText ch
        typedLength += 1

        delay := Random(250, 750)
        if (ch = "`n" or ch = ";" or ch = "{" or ch = "}")
            delay += Random(600, 1500)

        Sleep delay
    }
}

DeleteTyped(n) {
    if (n <= 0)
        return
    Loop n
    {
        Send "{Backspace}"
        Sleep Random(10, 30)
    }
}

MoveCursorRandomly() {
    MouseGetPos(&curX, &curY)
    newX := curX + Random(-50, 50)
    newY := curY + Random(-50, 50)
    MouseMove(newX, newY, 10)
}