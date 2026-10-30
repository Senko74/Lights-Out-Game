# Mangekyo

<img width="852" height="480" alt="Mangekyo gameplay" src="https://github.com/user-attachments/assets/175f64ca-5cd3-4408-9d9e-c9aaab234ba2" />

A small 2D game I wrote entirely in x64 assembly (MASM) for a game jam. There is no engine and no C code. The only thing the game relies on is the Windows API: kernel32, user32, gdi32 and winmm.

## The game

You looked into the Mangekyo and now you're stuck inside it.

Clouds come at you from the right and you have to dodge them by moving up and down. Every now and then the lights go out. You can still see yourself, but the clouds are almost invisible, so you have to remember where they were. Each blackout lasts longer than the last one, and the clouds get faster. A red eye watches you the whole time.

Your score goes up as long as you survive. The best one is saved and shows up in the lobby.

Controls:

- Space starts a game from the lobby
- Up and Down arrows move you

## Building it

You need Windows 10 or 11 (64-bit) and Visual Studio with the "Desktop development with C++" workload. That's where `ml64`, `link` and `rc` come from.

Then from the root of the repo:

```
.\build.bat
.\start.bat
```

`build.bat` loads the Visual Studio environment through `vcvars64.bat`, compiles the icon resource, assembles the three `.asm` files and links everything into the executable. If Visual Studio isn't installed in the default location, change the `vcvars64.bat` path at the top of the script.

The program is linked with `/NODEFAULTLIB` and its entry point is `main`, so there is no C runtime at all.

## How it works

### Window and main loop

`main.asm` registers a window class and creates a borderless popup window the size of the screen (read with `GetSystemMetrics`). The game then runs in a loop built on `PeekMessageA`. Each turn it handles any pending Windows messages, then reads the inputs, updates the game, draws a frame and sleeps for a few milliseconds.

### Rendering

The game never draws directly to the screen. Everything is written by hand into a 320x180 pixel buffer that lives in memory, one 32-bit color per pixel.

Drawing a rectangle means looping over its rows and columns and writing the color at `(y * 320 + x) * 4` in the buffer. The player, the clouds, the eye and the background are all built this way, with `drawRect` in `render.asm` doing most of the work.

Once the frame is complete, `StretchDIBits` (GDI) takes the buffer and stretches it to fill the window. This is what gives the game its big, blocky pixels. The bitmap header uses a negative height so that the first line in memory is the top of the image.

On top of that, a grain pass slightly darkens random pixels every frame, using a small xorshift random generator. Text such as the score is drawn afterwards with `TextOutA`, using a font created with `CreateFontA`.

### Gameplay

`game.asm` holds the game logic:

- Inputs are read with `GetAsyncKeyState`.
- Each cloud moves left at its own speed. When one leaves the screen it comes back on the right at a random height with a new random speed.
- Collisions are simple rectangle overlap checks between the player and each cloud. Touching a cloud sends you back to the lobby.
- The blackouts run on two frame counters, one for the time between blackouts and one for their length. When a blackout ends it gets longer for next time, and the clouds speed up.
- The eye's pupil follows the player's height.

### Saving the best score

The best score is written to `bestScore.dat` with `CreateFileA` and `WriteFile`, and read back at startup with `ReadFile`. If the file doesn't exist yet, the game simply starts at zero.

### Sound

The music is played with `PlaySoundA` from winmm, in a loop and asynchronously so it doesn't block the game. One track plays in the lobby, the other during a game. `waveOutSetVolume` sets the volume.

## Files

- `asm/main.asm`: window, main loop, frame drawing and text
- `asm/game.asm`: inputs, movement, clouds, collisions, blackouts, saving
- `asm/render.asm`: drawing routines for rectangles, the player and clouds
- `asm/defs.inc`: constants, structures and declarations shared by all files
- `assets/`: music, icon and the `.rc` resource file
- `build.bat`: builds the game
- `start.bat`: launches it

## Why assembly

Mostly to see if I could. Writing a game this way means doing everything an engine usually hides: opening a window, managing the stack by hand for every Windows call, putting pixels in memory one by one. It's slow to write, but by the end you know exactly what every byte is doing.
