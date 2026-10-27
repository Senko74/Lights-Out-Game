# Lights Out 🔦

> A game written in **100% x64 assembly (MASM)**: no engine, no C, just the Windows API and a hand-made software renderer.

![Lights Out screenshot](screenshot.png)

## The game

Dodge the spikes falling from the sky.  
The catch: **every 15 seconds, the lights go out.** You can only see yourself,
and you have to remember where the spikes were to survive.

*Made for a game jam, in 5 days.*

## Status

- [x] Window and message loop (Win32 API)
- [x] Software renderer: 320×180 pixel buffer, scaled ×4
- [x] Rectangle drawing routine
- [x] Player movement with the keyboard
- [ ] Falling spikes
- [ ] Collisions and game over
- [ ] Blindness every 15 seconds
- [ ] Score
- [ ] Sprites and sound

## How it works

Each frame:

```
read the keyboard → clear the buffer → draw the player → copy the buffer to the window → wait
```

- **`main.asm`**: window creation, message loop, main game loop
- **`render.asm`**: drawing routines (`drawRect`, `renderPlayer`)
- **`game.asm`**: game logic (keyboard input, player movement)
- **`defs.inc`**: constants, Windows structures and shared symbols

The game draws into its own 320×180 pixel buffer in memory, then `StretchDIBits` (GDI) scales it up to the window, which gives the pixel-art look.

## Build

Requirements: **Visual Studio** with the C++ build tools (for `ml64` and `link`).

```
build.bat
```

This produces `lightsout.exe`. No dependencies: only `kernel32`, `user32` and `gdi32`, which are part of Windows.

## Controls

| Key | Action |
|---|---|
| ↑ / ↓ | Move |
| Alt + F4 | Quit |