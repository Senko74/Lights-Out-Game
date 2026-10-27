@echo off
call "C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvars64.bat" >nul

ml64 /nologo /c game.asm
if errorlevel 1 exit /b
ml64 /nologo /c main.asm
if errorlevel 1 exit /b
ml64 /nologo /c render.asm
if errorlevel 1 exit /b
link /nologo  game.obj main.obj render.obj kernel32.lib user32.lib gdi32.lib winmm.lib /ENTRY:main /SUBSYSTEM:WINDOWS /NODEFAULTLIB /OUT:lightsout.exe
if errorlevel 1 exit /b
echo OK : lightsout.exe