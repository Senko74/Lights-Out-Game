    .data

saveFileName db "bestScore.dat", 0
fileHandle dq ?
bytesDone dd ?

minSpeed dd BASIC_MIN_SPEED
maxSpeed dd BASIC_MAX_SPEED
    
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

checkSpace : 
    mov rcx, 20h
    call GetAsyncKeyState
    test ax, 8000h
    jnz setAlive 
    jmp endInputs

moveUp :
    call movePlayerUp
    jmp endInputs

moveDown :
    call movePlayerDown
    jmp endInputs

setAlive :
    mov isAlive, 00989680h
    lea rcx, musicName
    mov rdx, 0
    mov r8, 20009h
    call PlaySound
    jmp endInputs

endInputs :
    add rsp, 40
    ret
inputs endp
    
movePlayerUp proc
    call moveEye
    mov eax, playerP.y
    sub eax, playerP.speed
    cmp eax, 1
    jl endMove
    mov playerP.y, eax
endMove :   
    ret
movePlayerUp endp

movePlayerDown proc
    call moveEye
    mov eax, playerP.y
    add eax, playerP.speed
    mov r10d, 179
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
    add playerP.score, 1
    mov eax, maxScore
    cmp playerP.score, eax
    jle notBestScore
    mov eax, playerP.score
    mov maxScore, eax
    notBestScore :
    rdtsc
    mov edx, 0
    mov r11d, 180
    sub r11d, [r10].CLOUD.sy
    div r11d
    mov [r10].CLOUD.y, edx
    mov [r10].CLOUD.sx, 70
    rdtsc
    mov edx, 0
    mov r11d, maxSpeed
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
    call resetGame
finish : 
    add rsp, 40
    ret
checkCollisions endp

moveEye proc
    mov eax, playerP.y
    shr eax, 3
    add eax, 70
    mov eye.y, eax
    ret
moveEye endp

resetGame proc
    sub rsp, 40
    lea rcx, lobbyMusicName
    mov rdx, 0
    mov r8, 20009h
    call PlaySound
    mov isBlind, 00000000h
    mov timeBlind, 300
    mov blindTimer, 0
    mov betweenBlindTimer, 0
    mov isAlive, 00000000h
    mov playerP.x, 3
    mov playerP.y, 75
    mov playerP.score, 0
    mov maxSpeed, BASIC_MAX_SPEED
    call saveBestScore
    lea rax, clouds
    lea r8, cloudsSave
    mov r9, 0
    mov r10, NB_CLOUDS * sizeof clouds / 8
    changeLoop :
        cmp r9, r10
        jge stop
        mov r11, [r8 + r9*8]
        mov [rax + r9*8], r11
        inc r9
        jmp changeLoop


stop :
    add rsp, 40
    ret
resetGame endp

saveBestScore proc
    sub rsp, 56
    lea rcx, saveFileName
    mov rdx, 40000000h
    mov r8, 0
    mov r9, 0
    mov qword ptr[rsp + 32], 2
    mov qword ptr[rsp + 40], 80h
    mov qword ptr[rsp + 48], 0
    call CreateFileA
    cmp rax, -1
    je stopSave
    mov fileHandle, rax
    mov rcx, fileHandle
    lea rdx, maxScore
    mov r8, 4
    lea r9, bytesDone
    mov dword ptr[rsp + 32], 0
    call WriteFile
    mov rcx, fileHandle
    call CloseHandle
stopSave :
    add rsp, 56
    ret
saveBestScore endp
    end
