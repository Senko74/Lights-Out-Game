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
    sub ecx, 1
    mov edx, playerP.y
    sub edx, 1
    mov r8d, playerP.sx
    add r8d, 2
    mov r9d, playerP.sx
    add r9d, 2
    mov dword ptr[rsp + 32], 0014306Bh
    call drawRect
    mov ecx, playerP.x
    mov edx, playerP.y
    mov r8d, playerP.sx
    mov r9d, playerP.sy
    mov dword ptr[rsp + 32], 002A6FD1h
    call drawRect
    mov ecx, playerP.x 
    add ecx, 6
    mov edx, playerP.y
    add edx, 6
    mov r8d, 3
    mov r9d, 3
    mov dword ptr[rsp + 32], 004FEAFFh
    call drawRect
    add rsp, 40
    ret
renderPlayer endp

renderCloud proc
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
        cmp isBlind, 00989680h
        jne renderNormal
        renderBlack :
            mov dword ptr[rdx + rax*4], 00121212h
            jmp endRender
        renderNormal :
            mov dword ptr[rdx + rax*4], 00E8EEF5h

        endRender :
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
renderCloud endp

    end