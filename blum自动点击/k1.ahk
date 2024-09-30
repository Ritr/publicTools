; #d6e631
; 50,600 #fff
#Include ..\plugin\ImagePut.ahk
TrayTip("作者:337634268(接定制脚本、web开发)")
#k:: {
    Start()
}
#j:: {
    ExitApp()
}
Start() {    
    WinActivate("TelegramDesktop")
    loop {
        pic := ImagePutBuffer("TelegramDesktop")

        if xy := pic.PixelSearch(0xFF39dd00, 5) {
            MouseClick(, xy[1], xy[2])
        }
        if xy := pic.PixelSearch(0xFF49d206, 5) {
            MouseClick(, xy[1], xy[2])
        }
        if xy := pic.PixelSearch(0xFFd1e21e, 5) {
            MouseClick(, xy[1], xy[2])
        }
        if xy := pic.PixelSearch(0xFF55d818, 5) {
            MouseClick(, xy[1], xy[2])
        }
        if xy := pic.PixelSearch(0xFFc9e000, 5) {
            MouseClick(, xy[1], xy[2])
        }
        if xy := pic.PixelSearch(0xFF52d20b, 5) {
            MouseClick(, xy[1], xy[2])
        }
        if xy := pic.PixelSearch(0xFFc9ff6f, 5) {
            MouseClick(, xy[1], xy[2])
        }
        if xy := pic.PixelSearch(0xFFcddc00, 5) {
            MouseClick(, xy[1], xy[2])
        }
        if xy := pic.PixelSearch(0xFFc3dd00, 5) {
            MouseClick(, xy[1], xy[2])
        }
        color := pic[50, 600]
        if (color = 0xFFFFFFFF) {
            MouseClick(, 50, 600)
        }
    }
}
; Start()
