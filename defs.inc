option casemap : none


WS_OVERLAPPED equ 00000000h
WS_CAPTION equ 00C00000h
WS_SYSMENU equ 00080000h
WS_THICKFRAME equ 00040000h
WS_MINIMIZEBOX equ 00020000h
WS_MAXIMIZEBOX equ 00010000h

WS_VISIBLE equ 10000000h
WS_POPUP equ 80000000h



PM_REMOVE equ 1

blindColor equ 00000000h
blindCloudsColor equ 121212h

timeBetweenBlind equ 600

NB_CLOUDS equ 4

BASIC_MIN_SPEED equ 1
BASIC_MAX_SPEED equ 1

WNDCLASSEXA struct 
    cbSize dd ?
    style dd ?
    lpfnWndProc dq ?
    cbClsExtra dd ?
    cbWndExtra dd ?
    hInstance dq ?
    hIcon dq ?
    hCursor dq ?
    hbrBackground dq ?
    lpszMenuName dq ?
    lpszClassName dq ?
    hIconSm dq ?
WNDCLASSEXA ends

MSG struct
    hwnd dq ?
    message dd ?
    fill dd ?
    wParam dq ?
    lParam dq ?
    time dd ? 
    point dq ?
    fillb dd ?
MSG ends


BITMAPINFOHEADER struct
    biSize dd ?
    biWidth dd ?
    biHeight dd ?
    biPlanes dw 1
    biBitCount dw ?
    biCompression dd ?
    biSizeImage dd ?
    biXPelsPerMeter dd ?
    biYPelsPerMeter dd ?
    biClrUsed dd ?
    biClrImportant dd ?
BITMAPINFOHEADER ends

PLAYERDATA struct
    x dd 3
    y dd 75
    sx dd 15
    sy dd 15
    life dd 3
    speed dd 3
    score dd 0
PLAYERDATA ends

CLOUD struct
    x dd 250
    y dd 75
    sx dd 70
    sy dd 20
    speed dd 3
CLOUD ends

EYE struct
    x dd 140
    y dd 77
    sx dd 10
    sy dd 10
    speed dd 1
EYE ends

extern ExitProcess : proc
extern CreateWindowExA : proc
extern StretchDIBits : proc
extern GetModuleHandleA : proc
extern DefWindowProcA : proc
extern RegisterClassExA : proc
extern PeekMessageA : proc
extern DefWindowProcA : proc
extern TranslateMessage : proc
extern DispatchMessageA : proc
extern PostQuitMessage : proc
extern GetDC : proc
extern StretchDIBits : proc
extern GetAsyncKeyState : proc
extern LoadCursorA : proc
extern Sleep : proc
extern wsprintfA : proc
externdef drawRect : proc
externdef screenPixels : dword
externdef renderPlayer : proc
externdef playerP : PLAYERDATA
externdef inputs : proc
externdef clouds : CLOUD
externdef renderCloud : proc
externdef moveCloud : proc
externdef isBlind : qword
externdef checkCollisions : proc
externdef score : byte
externdef scoreText : byte
externdef hdc : qword
extern TextOutA : proc
extern SetBkMode : proc
extern SetTextColor : proc
extern lstrlenA : proc
extern CreateFontA : proc
extern SelectObject : proc
extern GetStockObject : proc
externdef isAlive : qword
externdef maxScore : dword
externdef timeBlind : qword
externdef blindTimer : qword
externdef betweenBlindTimer : qword
externdef cloudsSave : CLOUD
extern CreateFileA : proc
extern ReadFile : proc
extern WriteFile : proc
extern CloseHandle : proc
externdef saveFileName : byte
externdef bytesDone : byte
externdef fileHandle : qword
externdef readBestScore : proc
externdef minSpeed : dword
externdef maxSpeed : dword
extern GetSystemMetrics : proc
externdef eye : EYE
extern PlaySound : proc
externdef musicName : byte
externdef lobbyMusicName : byte