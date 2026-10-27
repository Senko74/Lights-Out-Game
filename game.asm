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

    end