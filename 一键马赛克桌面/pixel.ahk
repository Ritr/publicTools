; gdi+ ahk tutorial 12 written by tic (Tariq Porter)
; Requires Gdip.ahk either in your Lib folder as standard library or using #Include
;
; Tutorial to pixelate a bitmap using machine code
TrayTip("一键马赛克 | 作者:337634268(接定制脚本、web开发)")
#SingleInstance Force
;#NoEnv
;SetBatchLines -1

; Uncomment if Gdip.ahk is not in your standard library
#Include ..\plugin\Gdip_All.ahk
v := 100
f := true
; myGui := Gui()
; myGui.OnEvent('Close', (*) => ExitApp())
; myGui.Title := "一键马赛克 | 作者:337634268(接定制脚本、web开发)"

; myGui.Show("w400 h40")

; Start gdi+
If !pToken := Gdip_Startup()
{
    MsgBox "Gdiplus failed to start. Please ensure you have gdiplus on your system"
    ExitApp
}
OnExit ExitFunc

; Create a layered window that is always on top as usual and get a handle to the window
;AHK v1
;Gui, 1: -Caption +E0x80000 +LastFound +OwnDialogs +Owner +AlwaysOnTop
;Gui, 1: Show, NA
Gui1 := Gui("-Caption +E0x80000 +LastFound +OwnDialogs +Owner +AlwaysOnTop")
Gui1.Show("NA")
hwnd1 := WinExist()
pBitmap := Gdip_BitmapFromScreen()

; pBitmap := ImagePutWindow(0)
; Get the width and height of the bitmap we have just created from the file
Width := Gdip_GetImageWidth(pBitmap), Height := Gdip_GetImageHeight(pBitmap)

; We also need to create
pBitmapOut := Gdip_CreateBitmap(Width, Height)

; As normal create a gdi bitmap and get the graphics for it to draw into
hbm := CreateDIBSection(Width, Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
G := Gdip_GraphicsFromHDC(hdc)

; Call WM_LBUTTONDOWN every time the gui is clicked, to allow it to be dragged
OnMessage(0x201, WM_LBUTTONDOWN)

; Update the window with the hdc so that it has a position and dimension for future calls to not
; have to explicitly pass them
UpdateLayeredWindow(hwnd1, hdc, (A_ScreenWidth - Width) // 2, (A_ScreenHeight - Height) // 2, Width, Height)

; Set a timer to update the gui with our pixelated bitmap
; SetTimer Update, 50
return

;#######################################################################
Update()
{
    global
Update:


    static dir := 0
    ; Some simple checks to see if we are increasing or decreasing the pixelation
    ; v is the block size of the pixelation and dir is the direction (inc/decreasing)
    ; if (v <= 1)
    ;     v := 1, dir := !dir
    ; else if (v >= 30)
    ;     v := 30, dir := !dir
    dir := !dir
    ; Call Gdip_PixelateBitmap with the bitmap we retrieved earlier and the block size of the pixels
    ; The function returns the pixelated bitmap, and doesn't dispose of the original bitmap
    Gdip_PixelateBitmap(pBitmap, &pBitmapOut, dir ? ++v : --v)

    ; We can optionally clear the graphics we will be drawing to, but if we know there will be no transparencies then
    ; it doesn't matter
    ;Gdip_GraphicsClear(G)

    ; We then draw our pixelated bitmap into our graphics and dispose of the pixelated bitmap
    Gdip_DrawImage(G, pBitmapOut, 0, 0, Width, Height, 0, 0, Width, Height)

    ; We can now update our window, and don't need to provide a position or dimensions as we don't want them to change
    UpdateLayeredWindow(hwnd1, hdc)
    return
}
; Mosaic the screen to hide your private information
;#######################################################################

; This is called on left click to allow to drag
WM_LBUTTONDOWN(wParam, lParam, msg, hwnd)
{
    PostMessage 0xA1, 2
}

;#######################################################################

; On exit, dispose of everything created
; Esc:: ExitApp


ExitFunc(ExitReason, ExitCode)
{
    global
    Gdip_DisposeImage(pBitmapOut), Gdip_DisposeImage(pBitmap)
    SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
    Gdip_DeleteGraphics(G)
    Gdip_Shutdown(pToken)
}
MButton::
{
    ; global hwnd1, pBitmap, pBitmapOut, G, hdc, Width, Height
    global f
    if f
    {
        ; 重新截图
        pBitmap := Gdip_BitmapFromScreen()
        Width := Gdip_GetImageWidth(pBitmap)
        Height := Gdip_GetImageHeight(pBitmap)

        ; 更新输出位图
        pBitmapOut := Gdip_CreateBitmap(Width, Height)
        Update()
        Gui1.Show()
    } else {
        Gui1.Hide()
    }
    f := !f

}
#HotIf !f
WheelDown:: {
    global v
    v += 10
    if(v >= 200){
        v := 200
    }
    Update()
}


#HotIf !f
WheelUp:: {
    global v
    v -= 10
    if(v <= 3){
        v := 3
    }
    Update()
}