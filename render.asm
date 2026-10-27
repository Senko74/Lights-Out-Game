    .code
    include defs.inc


drawRect proc
    mov r10d, dword ptr[rsp + 40] ; color
    push r15
    mov r11, 0 
widthYLoop :
    cmp r11, r9
    jge finishDrawing
    mov rax, 0
    widthXLoop :
        cmp rax, r8
        jge nextLine
        mov r15, rdx
        add r15, r11
        imul r15, 320
        add r15, rcx
        push r9
        lea r9, screenPixels
        push rdx
        mov rdx, r15
        imul rdx, 4
        add rdx, r9
        mov dword ptr[rdx + rax*4], r10d
        pop rdx
        pop r9
        inc rax
        jmp widthXLoop
    
nextLine:
    inc r11
    jmp widthYLoop


finishDrawing :
    pop r15
    ret
drawRect endp

renderPlayer proc 
    sub rsp, 40
    mov ecx, playerP.x
    mov edx, playerP.y
    mov r8d, playerP.sx
    mov r9d, playerP.sy
    mov dword ptr[rsp + 32], 000000FFh
    call drawRect
    add rsp, 40
    ret
renderPlayer endp

    end