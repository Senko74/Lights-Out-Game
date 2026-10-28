include defs.inc

    .data
windowData WNDCLASSEXA <>
className db "LightsOut", 0
titleName db "Lights Out", 0
windowHandle dq ?
msg MSG <> 
bitmapInfo BITMAPINFOHEADER <>
hdc dq ?
playerP PLAYERDATA<>
movPerSec dd 1
clouds CLOUD <250, 0, 70, 15, 3>, <250, 35, 70, 15, 2>, <250, 22, 70, 15, 4>, <250, 120, 70, 15, 1>


isBlind dq 00000000h ; blind equal to 00989680h

gameCountTick dq 0

timeBlind dq 300
blindTimer dq 0
betweenBlindTimer dq 0


    .data?
screenPixels dd 57600 dup(?)

    .code
main proc
    sub rsp, 120
    
createWindow :
    ; GetModuleHandleA return the memory adress of the programm (put it in the pile)
    mov rcx, 0
    call GetModuleHandleA
    push rax
    ; size of the struct windowData look into defs.inc
    mov windowData.cbSize, sizeof windowData
    ; style of the window in binary, each byte = an option
    mov windowData.style, 100011b
    ; we give the memory adress (in the struct) window have to call when there is inputs
    lea rax, onWindowMessage
    mov windowData.lpfnWndProc, rax
    ; useless options for the game
    mov windowData.cbClsExtra, 0
    mov windowData.cbWndExtra, 0
    pop rax
    ; we got back the memory adress of the program which was in the pile to put it in the strcu (to do it in order)
    mov windowData.hInstance, rax
    ; window options :
    mov windowData.hIcon, 0
    mov rcx, 0
    mov rdx, 7F00h
    call LoadCursorA
    mov windowData.hCursor, rax
    mov windowData.hbrBackground, 0
    mov windowData.lpszMenuName, 0
    lea rax, className
    mov windowData.lpszClassName, rax
    mov windowData.hIconSm, 0
    ; we send to window the memory of the struct, if its good it continue else it close the window with 404 
    lea rcx, windowData
    call RegisterClassExA
    cmp ax, 0
    je errorRegister

    ; we put the parameters to call the function CreateWindowExA which create the page
    mov rcx, 0
    lea r10, className
    mov rdx, r10
    lea r10, titleName
    mov r8, r10
    mov r9, WS_POPUP or WS_VISIBLE
    mov dword ptr [rsp + 32], 0
    mov dword ptr [rsp + 40], 0
    mov dword ptr [rsp + 48], 1280
    mov dword ptr [rsp + 56], 720
    mov qword ptr [rsp + 64], 0
    mov qword ptr [rsp + 72], 0
    mov rax, windowData.hInstance
    mov qword ptr [rsp + 80], rax
    mov qword ptr [rsp + 88], 0
    call CreateWindowExA
    ; window give in rax if it worked, 0 = error = close page
    cmp rax, 0
    je errorCreation
    
    mov bitmapInfo.biSize, sizeof bitmapInfo
    mov bitmapInfo.biWidth, 320
    mov bitmapInfo.biHeight, -180
    mov bitmapInfo.biBitCount, 32
    mov bitmapInfo.biCompression, 0

    mov windowHandle, rax

    mov rcx, windowHandle
    call GetDC
    mov hdc, rax

    jmp windowLoop

windowLoop:
    lea rcx, msg
    mov rdx, 0
    mov r8, 0
    mov r9, 0
    mov dword ptr [rsp + 32], PM_REMOVE
    call PeekMessageA
    cmp eax, 0
    je renderer
    cmp msg.message, 18
    je closeWindow
    lea rcx, msg
    call TranslateMessage
    lea rcx, msg
    call DispatchMessageA

    restartLoop :
    jmp windowLoop

renderer :

    add gameCountTick, 1
    cmp isBlind, 00989680h
    jne playerIsntBlind
    playerIsBlind :
        add blindTimer, 1
        mov rax, timeBlind
        cmp blindTimer, rax
        jl EndBlindCount
        call stopBlind
        mov blindTimer, 0
        jmp EndBlindCount
    playerIsntBlind :
        add betweenBlindTimer, 1
        cmp betweenBlindTimer, timeBetweenBlind
        jl EndBlindCount
        call startBlind
        mov betweenBlindTimer, 0
    EndBlindCount :

    call inputs
    mov rax, 0
    lea r10, screenPixels
    mov rsi, 57600
    mov rbp, isBlind
    cmp rbp, 00989680h
    jne renderBackground
    renderBlack :
        cmp rax, rsi
        jge backgroundEnd
        mov dword ptr[r10 + rax*4], 00000000h
        inc rax
        jmp renderBlack

    renderBackground :
        cmp rax, rsi
        jge backgroundEnd
        mov dword ptr[r10 + rax*4], 003A7BD5h
        inc rax
        jmp renderBackground

    backgroundEnd :
    mov rbx, 0 ; i
    mov r15, 4 ; count
    lea r13, clouds
    loopClouds :
        cmp rbx, r15
        jge endRenderClouds
        mov r14, sizeof CLOUD
        imul r14, rbx
        mov rcx, r13
        mov rdx, r14
        call moveCloud
        mov rcx, r13
        mov rdx, r14
        call checkCollisions
        mov ecx, [r13 + r14].CLOUD.x
        mov edx, [r13 + r14].CLOUD.y
        mov r8d, [r13 + r14].CLOUD.sx
        mov r9d, [r13 + r14].CLOUD.sy
        call renderCloud
        inc rbx
        jmp loopClouds
    endRenderClouds : 
    call renderPlayer
    mov rcx, hdc
    mov rdx, 0
    mov r8, 0
    mov r9, 1280
    mov dword ptr[rsp + 32], 720
    mov dword ptr[rsp + 40], 0
    mov dword ptr[rsp + 48], 0
    mov dword ptr[rsp + 56], 320
    mov qword ptr[rsp + 64], 180
    lea rax, screenPixels
    mov qword ptr[rsp + 72], rax
    lea rax, bitmapInfo
    mov qword ptr[rsp + 80], rax
    mov qword ptr[rsp + 88], 0  
    mov qword ptr[rsp + 96], 00CC0020h 
    call StretchDIBits
    mov rcx, 2
    call Sleep
    jmp windowLoop

closeWindow:
    mov rcx, 202
    call ExitProcess

errorRegister:
    mov rcx, 404
    call ExitProcess

errorCreation:
    mov rcx, 412
    call ExitProcess

errorMessage :
    mov rcx, 416
    call ExitProcess

main endp

onWindowMessage proc
    sub rsp, 40
    cmp edx, 2
    je destroy
    call DefWindowProcA
    add rsp, 40
    ret

destroy :
    mov rcx, 0
    call PostQuitMessage
    add rsp, 40
    mov rax, 0
    ret
onWindowMessage endp

stopBlind proc
    mov isBlind, 00000000h
    add timeBlind, 50
    ret
stopBlind endp

startBlind proc
    mov isBlind, 00989680h
    ret
startBlind endp

    end




