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
    x dd 0
    y dd 75
    sx dd 15
    sy dd 15
    life dd 3
    speed dd 5
PLAYERDATA ends

CLOUD struct
    x dd 250
    y dd 75
    sx dd 70
    sy dd 20
    speed dd 3
CLOUD ends

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
externdef drawRect : proc
externdef screenPixels : dword
externdef renderPlayer : proc
externdef playerP : PLAYERDATA
externdef inputs : proc
externdef cloud : dword
externdef renderCloud : proc
externdef moveCloud : proc