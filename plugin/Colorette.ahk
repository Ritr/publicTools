; ******* General *******
; COLORETTE
ScriptVersion := 2.1
; V 2.1: Removed DLG selection, improved hover tooltip.
; Script created using Autohotkey (http www.autohotkey.com)
; AHK version: AHK_L (www.autohotkey.net/~Lexikos/AutoHotkey_L)
;
; AUTHOR: sumon @ the Autohotkey forums
; License: sumon's Std License (see my forum signature)
;
; To add a "pick sound", add the pick_click.wav file and uncomment lines the lines with FileCreateDir, FileInstall (23, 24)
;
; Thanks to: The Naked General _ jamixzol@gmail.com for his "Flashy and impractical color picker" which inspired me to this.
;
; || To-do ||
; Settings?
;
;https://www.autohotkey.com/boards/viewtopic.php?t=66463
;

; REMOVED: #NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode("Input")  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.
#SingleInstance Force
Persistent
Global iCatch_status := "off"
OnExit(Exitfunc, )
return

PickColor(){
   ; Setup
   ;~ FileCreateDir, data
   ;~ FileInstall, data\pick_click.wav, data\pick_click.wav
   ColoretteIcon := A_ScriptFullPath

   ; Hotkeys
   Hotkey("Rbutton", CatchColor) ; HEX (Default)
   Hotkey("^Rbutton", CatchColor) ; RGB

   ; Initiation
   TrayTip("Colorette:", "RIGHTCLICK to copy HEX value`nAdd CTRL for RGB value")
   SetSystemCursor("IDC_Cross") ; Reset in OnExit

   If (FileExist("colorette.exe"))
      TraySetIcon("Colorette.exe")

   ; MAIN LOOP: Pick Color

   CoordMode("Mouse", "Screen")
   CoordMode("Pixel")
   Loop
   {
      if (iCatch_Status = "On")
         Break
      MouseGetPos(&X, &Y)
      Color := PixelGetColor(X, Y, "RGB") ;V1toV2: Switched from BGR to RGB values
      ColorD := Color ; Build an int based variable
      color := SubStr(color, -1*(6)) ; Removes 0x prefix
; REMOVED:       SetFormat, IntegerFast, d
      ColorD += 0  ; Sets Var (which previously contained 11) to be 0xb.
      ColorD .= ""  ; Necessary due to the "fast" mode.
      ;~ ModColor := HexModify(Color, 1)
      GetKeyState("LControl") ? ColorMessage := HextoRGB(Color, "Message") : ColorMessage := Color
      ToolTip(ColorMessage) ; (%ModColor%)
      mX := X - 30 ; Offset Tooltip from Mouse
      mY := Y - 80
      mX := X + 30 ; Offset Tooltip from Mouse
      mY := Y - 100
      if (A_Index=1) {
         oGui2 := Gui()
         oGui2.Opt("-Caption +ToolWindow +LastFound +AlwaysOnTop +Border -DPIScale") ; +0x400000 OR +Border
         oGui2.Show("NoActivate x" . mX . " y" . mY . " w60 h60")
      } else {
         oGui2.Move(mX,mY)
      }
      oGui2.BackColor := color
   }
   oGui2.Destroy()
   Sleep(5000)

   Return

   CatchColor(ThisHotkey) ; Catch Hover'd color
{ ; V1toV2: Added bracket
   If (A_ThisHotkey = "^Rbutton")
      Out := "RGB"
   If (FileExist("data\pick_click.wav"))
      SoundPlay("data\pick_click.wav")
   ; Continue

   ColorPicked:
   color := SubStr(color, -1*(6)) ; Color HEX to RGB (or RGB to RGB)

   If (Out = "RGB")
   {
      OutColor := HexToRGB(Color)
      OutMsg := HexToRGB(Color, "Message")
      A_Clipboard := OutMsg
      ;~ OutParse := HexToRGB(Color, "Parse") ; Returns "R,G,B"
   }
   else
   {
      OutColor := Color
      OutMsg :=  "#" . Color
      A_Clipboard := OutColor
   }

   TrayTip("Colorette:", outmsg " picked")
   RestoreCursors()
   iCatch_Status := "On"
   Sleep(500)
   ToolTip()
   Hotkey("^Rbutton", "Off")
   Hotkey("Rbutton", "Off")

   Sleep(500)
   ;Gosub, Exit
   Return
}
} ; V1toV2: Added Bracket before hotkey or Hotstring

#esc::
ExitFunc(*){
   RestoreCursors()
   iCatch_Status := "On"
   ToolTip()
   try Hotkey("^Rbutton", "Off")
   try Hotkey("Rbutton", "Off")
   ExitApp()
   Return 1
}

; FUNCTIONS
; : SetSystemCursor() and RestoreCursors()
HexToRGB(Color, Mode:="") ; Input: 6 characters HEX-color. Mode can be RGB, Message (R: x, G: y, B: z) or parse (R,G,B)
{
   ; If df, d is *16 and f is *1. Thus, Rx = R*16 while Rn = R*1
   Rx := SubStr(Color, 1, 1), Rn := SubStr(Color, 2, 1)
   Gx := SubStr(Color, 3, 1), Gn := SubStr(Color, 4, 1)
   Bx := SubStr(Color, 5, 1), Bn := SubStr(Color, 6, 1)

   AllVars := "Rx|Rn|Gx|Gn|Bx|Bn"
   Loop Parse, Allvars, "|" ; Add the Hex values (A - F)
   {
      ; StrReplace() is not case sensitive
      ; check for StringCaseSense in v1 source script
      ; and change the CaseSense param in StrReplace() if necessary
      %A_LoopField% := StrReplace(%A_LoopField%, "a", 10,,, 1)
      ; StrReplace() is not case sensitive
      ; check for StringCaseSense in v1 source script
      ; and change the CaseSense param in StrReplace() if necessary
      %A_LoopField% := StrReplace(%A_LoopField%, "b", 11,,, 1)
      ; StrReplace() is not case sensitive
      ; check for StringCaseSense in v1 source script
      ; and change the CaseSense param in StrReplace() if necessary
      %A_LoopField% := StrReplace(%A_LoopField%, "c", 12,,, 1)
      ; StrReplace() is not case sensitive
      ; check for StringCaseSense in v1 source script
      ; and change the CaseSense param in StrReplace() if necessary
      %A_LoopField% := StrReplace(%A_LoopField%, "d", 13,,, 1)
      ; StrReplace() is not case sensitive
      ; check for StringCaseSense in v1 source script
      ; and change the CaseSense param in StrReplace() if necessary
      %A_LoopField% := StrReplace(%A_LoopField%, "e", 14,,, 1)
      ; StrReplace() is not case sensitive
      ; check for StringCaseSense in v1 source script
      ; and change the CaseSense param in StrReplace() if necessary
      %A_LoopField% := StrReplace(%A_LoopField%, "f", 15,,, 1)
   }
   R := Rx*16+Rn
   G := Gx*16+Gn
   B := Bx*16+Bn

   If (Mode = "Message") ; Returns "R: 255 G: 255 B: 255"
      Out := "R:" . R . " G:" . G . " B:" . B
   else if (Mode = "Parse") ; Returns "255,255,255"
      Out := R . "," . G . "," . B
   else
      Out := R . G . B ; Returns 255255255
    return Out
}

; ToBase / FromBase by Lazslo @ http://www.autohotkey.com/forum/post-276241.html#276241
ToBase(n,b) { ; n >= 0, 1 < b <= 36
   Return (n < b ? "" : ToBase(n//b,b)) . ((d:=mod(n,b)) < 10 ? d : Chr(d+87))
}

FromBase(s,b) { ; convert base b number s=strings of 0..9,a..z, to AHK number
   Return (L:=StrLen(s))=0 ? "":(L>1 ? FromBase(SubStr(s, 1, L-1),b)*b:0) + ((c:=Ord(SubStr(s, -1)))>57 ? c-87:c-48)
}

HexModify(n, Add:="") ; MsgBox % HexModify("ffffff", -55)
{
   ;~ Hex := "0123456789abcdef"
   R := ToBase(FromBase(SubStr(n, 1, 2), 16) + Add, 16)
   G := ToBase(FromBase(SubStr(n, 3, 2), 16) + Add, 16)
   B := ToBase(FromBase(SubStr(n, 5, 2), 16) + Add, 16)
   return R . G . B
}

RestoreCursors()
{
   SPI_SETCURSORS := 0x57
   DllCall("SystemParametersInfo", "UInt", SPI_SETCURSORS, "UInt", 0, "UInt", 0, "UInt", 0)
}

SetSystemCursor( Cursor := "", cx := 0, cy := 0 )
{
   BlankCursor := 0, SystemCursor := 0, FileCursor := 0 ; init
   CursorHandle := ""
   SystemCursors := "32512IDC_ARROW,32513IDC_IBEAM,32514IDC_WAIT,32515IDC_CROSS,32516IDC_UPARROW,32640IDC_SIZE,32641IDC_ICON,32642IDC_SIZENWSE,32643IDC_SIZENESW,32644IDC_SIZEWE,32645IDC_SIZENS,32646IDC_SIZEALL,32648IDC_NO,32649IDC_HAND,32650IDC_APPSTARTING,32651IDC_HELP"

   if (Cursor = "") ; empty, so create blank cursor
   {
      AndMask := Buffer(32*4, 0xFF), XorMask := Buffer(32*4, 0) ; V1toV2: if 'XorMask' is a UTF-16 string, use 'VarSetStrCapacity(&XorMask, 32*4)'
      BlankCursor := "1" ; flag for later
   }
   Else If SubStr(Cursor, 1, 4) = "IDC_" ; load system cursor
   {
      Loop Parse, SystemCursors, ","
      {
         CursorName := SubStr(A_Loopfield, 6, 15) ; get the cursor name, no trailing space with substr
         CursorID := SubStr(A_Loopfield, 1, 5) ; get the cursor id
         SystemCursor := "1"
         If ( CursorName = Cursor )
         {
            CursorHandle := DllCall("LoadCursor", "Uint", 0, "Int", CursorID)
            Break
         }
      }
      if (CursorHandle = "") ; invalid cursor name given
      {
         MsgBox("Error: Invalid cursor name", "SetCursor", "")
         CursorHandle := "Error"
      }
   }
   Else If FileExist( Cursor )
   {
      SplitPath(Cursor, , , &Ext) ; auto-detect type
      if (Ext = "ico")
         uType := 0x1
      Else       if (Ext ~= "^(?i:cur|ani)$")
         uType := 0x2
      Else ; invalid file ext
      {
         MsgBox("Error: Invalid file type", "SetCursor", "")
         CursorHandle := "Error"
      }
      FileCursor := "1"
   }
   Else
   {
      MsgBox("Error: Invalid file path or cursor name", "SetCursor", "")
      CursorHandle := "Error" ; raise for later
   }

   if (CursorHandle != "Error")
   {
      Loop Parse, SystemCursors, ","
      {
         if (BlankCursor = 1)
         {
            Type := "BlankCursor"
;            %Type%%A_Index% := DllCall("CreateCursor", "Uint", 0, "Int", 0, "Int", 0, "Int", 32, "Int", 32, "Uint", AndMask, "Uint", XorMask)
            cursor_temp := DllCall("CreateCursor", "Uint", 0, "Int", 0, "Int", 0, "Int", 32, "Int", 32, "Uint", AndMask, "Uint", XorMask)
;            CursorHandle := DllCall("CopyImage", "Uint", %Type%%A_Index%, "Uint", 0x2, "Int", 0, "Int", 0, "Int", 0)
            CursorHandle := DllCall("CopyImage", "Uint", cursor_temp, "Uint", 0x2, "Int", 0, "Int", 0, "Int", 0)
            DllCall("SetSystemCursor", "Uint", CursorHandle, "Int", SubStr(A_Loopfield, 1, 5))
         }
                  Else if (SystemCursor = 1)
         {
            Type := "SystemCursor"
            CursorHandle := DllCall("LoadCursor", "Uint", 0, "Int", CursorID)
;            %Type%%A_Index% := DllCall("CopyImage", "Uint", CursorHandle, "Uint", 0x2, "Int", cx, "Int", cy, "Uint", 0)
            Cursor_temp := DllCall("CopyImage", "Uint", CursorHandle, "Uint", 0x2, "Int", cx, "Int", cy, "Uint", 0)
;            CursorHandle := DllCall("CopyImage", "Uint", %Type%%A_Index%, "Uint", 0x2, "Int", 0, "Int", 0, "Int", 0)
            CursorHandle := DllCall("CopyImage", "Uint", Cursor_temp, "Uint", 0x2, "Int", 0, "Int", 0, "Int", 0)
            DllCall("SetSystemCursor", "Uint", CursorHandle, "Int", SubStr(A_Loopfield, 1, 5))
         }
                  Else if (FileCursor = 1)
         {
            Type := "FileCursor"
;            %Type%%A_Index% := DllCall("LoadImageA", "UInt", 0, "Str", Cursor, "UInt", uType, "Int", cx, "Int", cy, "UInt", 0x10)
            Cursor_temp := DllCall("LoadImageA", "UInt", 0, "Str", Cursor, "UInt", uType, "Int", cx, "Int", cy, "UInt", 0x10)
;            DllCall("SetSystemCursor", "Uint", %Type%%A_Index%, "Int", SubStr(A_Loopfield, 1, 5))
            DllCall("SetSystemCursor", "Uint", cursor_temp, "Int", SubStr(A_Loopfield, 1, 5))
         }
      }
   }
}

#c::
{ 
   iCatch_status := "off"
   PickColor()
   return
} 


