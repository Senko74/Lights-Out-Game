option casemap : none
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

WS_OVERLAPPED equ 00000000h
WS_CAPTION equ 00C00000h
WS_SYSMENU equ 00080000h
WS_THICKFRAME equ 00040000h
WS_MINIMIZEBOX equ 00020000h
WS_MAXIMIZEBOX equ 00010000h

WS_VISIBLE equ 10000000h

WS_OVERLAPPEDWINDOW equ WS_OVERLAPPED or WS_CAPTION or WS_SYSMENU or WS_THICKFRAME or WS_MINIMIZEBOX or WS_MAXIMIZEBOX

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

PM_REMOVE equ 1


