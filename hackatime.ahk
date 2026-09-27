#Requires AutoHotkey v2.0
SendMode "Input"

; ===================================
; React Password Game Code Typing Script
; ===================================

; Reads the code straight from snippet.txt — no escaping needed, ever
codeText := FileRead(A_ScriptDir "\fah.txt")

global typedLength := 0

; Ctrl+Alt+T to type out code
^!t::
{
    global typedLength
    typedLength := 0
    TypeLikeHuman(codeText)
}

; Ctrl+Alt+D to backspace typed code
^!d::
{
    global typedLength
    DeleteTyped(typedLength)
}

TypeLikeHuman(text) {
    global typedLength
    Loop Parse, text
    {
        ch := A_LoopField
        SendText ch
        typedLength += 1

        delay := Random(150, 2000)
        if (ch = "`n" or ch = ";" or ch = "{" or ch = "}")
            delay += Random(400, 1500)

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