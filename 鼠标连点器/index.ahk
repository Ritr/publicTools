LianDian() {
    loop 10 {
        MouseClick()
        Sleep(500)
    }
}

^k:: {
    LianDian()
}

^z::{
    Pause(1)
}

^c::{
    Pause(0)
}