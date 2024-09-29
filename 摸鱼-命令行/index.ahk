; url := 'https://www.zhihu.com/'
; MsgBox(http('Get', url))

; http(verb, url) {
;     ; https://learn.microsoft.com/en-us/windows/win32/winhttp/winhttprequest
;     web := ComObject('WinHttp.WinHttpRequest.5.1')
;     web.Open(verb, url)
;     web.Send()F11
;     web.WaitForResponse()
;     return web.ResponseText
; }
C() {
    Run("cmd")
    Sleep(500)
    Send("{F11}")
    commands := [
        "echo Hello World",
        "dir",
        "cd",
        "cls",
        "ipconfig",
        "tasklist",
        "netstat",
        "whoami",
        "systeminfo",
        "chkdsk",
        "sfc /scannow",
        "attrib",
        "echo %DATE%",
        "echo %TIME%",
        "set",
        "assoc",
        "ftype",
        "net user",
        "net localgroup",
        "net share",
        "net use",
        "netstat -a",
        "path",
        "findstr",
        "more",
        "type",
        "find",
        "sort",
        "fc",
        "clip",
        "tree",
        "hostname",
        "tasklist /svc",
        "wmic process list",
        "wmic os get caption",
        "wmic useraccount list",
        "wmic product get name",
        "wmic logicaldisk get name",
        "wmic nic get name",
        "wmic cpu get name",
        "wmic memorychip get capacity",
        "wmic bios get serialnumber",
        "wmic diskdrive get model",
        "wmic volume get label",
        "wmic service get name",
        "wmic startup get caption",
        "netsh interface show interface",
        "route print",
        "arp -a",
        "echo %COMSPEC%",
        "ver",
        "echo %PROCESSOR_ARCHITECTURE%",
        "echo %OS%"
    ]

    loop 50 {
        Sleep(1000)
        N := Random(1, commands.Length)
        SendText(commands[N])
        Send("{Enter}")
        Sleep(2000)
        Send("^c")
    }
}

#c:: {
    C()
}

#s:: {
    ExitApp()
}