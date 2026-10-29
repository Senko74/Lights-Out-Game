@echo off
call "C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvars64.bat" >nul

cd ./assets
rc /nologo rc Logo.rc
cd ../asm
ml64 /nologo /c game.asm
if errorlevel 1 exit /b
ml64 /nologo /c main.asm
if errorlevel 1 exit /b
ml64 /nologo /c render.asm
if errorlevel 1 exit /b
link /nologo ../assets/Logo.res ../asm/game.obj ../asm/main.obj ../asm/render.obj kernel32.lib user32.lib gdi32.lib winmm.lib /ENTRY:main /SUBSYSTEM:WINDOWS /NODEFAULTLIB /OUT:Mangeyko.exe 
if errorlevel 1 exit /b
cd ../asm

echo OK : Mangeyko.exe