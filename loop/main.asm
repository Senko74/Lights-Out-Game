include defs.inc

    .data
windowData WNDCLASSEXA <>
className db "LightsOut", 0
titleName db "Lights Out", 0
windowHanfle dq ?

    .code
main proc
    sub rsp, 104
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
    mov windowData.hCursor, 0
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
    mov r9, WS_OVERLAPPEDWINDOW or WS_VISIBLE
    mov dword ptr [rsp + 32], 0
    mov dword ptr [rsp + 40], 0
    mov dword ptr [rsp + 48], 1920
    mov dword ptr [rsp + 56], 1080
    mov qword ptr [rsp + 64], 0
    mov qword ptr [rsp + 72], 0
    mov rax, windowData.hInstance
    mov qword ptr [rsp + 80], rax
    mov qword ptr [rsp + 88], 0
    call CreateWindowExA
    ; window give in rax if it worked, 0 = error = close page
    cmp rax, 0
    je errorCreation
    mov windowHanfle, rax
    jmp windowLoop

windowLoop:
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
main endp

onWindowMessage proc
    sub rsp, 40
    call DefWindowProcA
    add rsp, 40
    ret
onWindowMessage endp

    end