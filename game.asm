    .code
    include defs.inc

    
inputs proc
    sub rsp, 40

chechMoveUp : 
    mov rcx, 26h
    call GetAsyncKeyState
    test ax, 8000h
    jnz moveUp

chechMoveDown : 
    mov rcx, 28h
    call GetAsyncKeyState
    test ax, 8000h
    jnz moveDown
    jmp endInputs

moveUp :
    call movePlayerUp
    jmp endInputs

moveDown :
    call movePlayerDown
    jmp endInputs

endInputs :
    add rsp, 40
    ret
inputs endp
    
movePlayerUp proc
    mov eax, playerP.y
    sub eax, playerP.speed
    cmp eax, 0
    jl endMove
    mov playerP.y, eax
endMove :   
    ret
movePlayerUp endp

movePlayerDown proc
    mov eax, playerP.y
    add eax, playerP.speed
    mov r10d, 180
    sub r10d, playerP.sy
    cmp eax, r10d
    jg endMove
    mov playerP.y, eax
endMove :   
    ret
movePlayerDown endp

moveCloud proc
    ; rcx -> ptr tableau
    ; rdx -> compteur
    sub rsp, 40
    mov r10, rcx
    add r10, rdx
    mov eax, [r10].CLOUD.x
    sub eax, [r10].CLOUD.speed
    cmp eax, 0
    jle removeSize
    mov [r10].CLOUD.x, eax
    jmp endMove

removeSize :
    mov [r10].CLOUD.x, 0
    mov eax, [r10].CLOUD.speed
    sub [r10].CLOUD.sx, eax
    cmp [r10].CLOUD.sx, 0
    jle tpRight
    jmp endMove

tpRight :
    rdtsc
    mov edx, 0
    mov r11d, 180
    sub r11d, [r10].CLOUD.sy
    div r11d
    mov [r10].CLOUD.y, edx
    mov [r10].CLOUD.sx, 70
    rdtsc
    mov edx, 0
    mov r11d, 4
    div r11d
    add edx, 1
    mov [r10].CLOUD.speed, edx
    mov eax, 320
    sub eax, [r10].CLOUD.sx
    mov [r10].CLOUD.x, eax

endMove :
    add rsp, 40
    ret
moveCloud endp

checkCollisions proc
    mov r11, rcx
    add r11, rdx
    sub rsp, 40
    mov r10d, [r11].CLOUD.x
    add r10d, [r11].CLOUD.sx
    cmp playerP.x, r10d
    jge finish
    mov eax, playerP.x
    add eax, playerP.sx
    cmp eax, [r11].CLOUD.x
    jle finish
    mov eax, [r11].CLOUD.y
    add eax, [r11].CLOUD.sy
    cmp playerP.y, eax
    jge finish
    mov eax, playerP.y
    add eax, playerP.sy
    cmp eax, [r11].CLOUD.y
    jle finish
    mov rcx, 0
    call PostQuitMessage
finish : 
    add rsp, 40
    ret
checkCollisions endp

    end
