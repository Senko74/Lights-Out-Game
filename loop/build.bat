@echo off
ml64 /nologo /c data.asm
if errorlevel 1 exit /b
ml64 /nologo /c game.asm
if errorlevel 1 exit /b
ml64 /nologo /c main.asm
if errorlevel 1 exit /b
ml64 /nologo /c render.asm
if errorlevel 1 exit /b
link /nologo data.obj game.obj main.obj render.obj kernel32.lib user32.lib gdi32.lib winmm.lib /ENTRY:main /SUBSYSTEM:WINDOWS /NODEFAULTLIB /OUT:lightsout.exe
if errorlevel 1 exit /b
echo OK : lightsout.exe