# BakkesMod on Linux with Heroic Games Launcher (Epic Games)

A step-by-step guide to get BakkesMod working with Rocket League installed via **Heroic Games Launcher** (Epic Games Store) on Linux.

> Tested on: **Fedora 43**, **GE-Proton10-33**, **Heroic 2.20.1 rpm**  
> Should work on most distros with minor path adjustments.

---

## Prerequisites

- Heroic Games Launcher installed by a native package (will work without it but it might need extra changes)
- Rocket League installed and running via Heroic Games Launcher
- GE-Proton installed (via [ProtonPlus](https://github.com/nicowillis/protonplus) or manually into `~/.local/share/Steam/compatibilitytools.d/`)
- Steam installed (even if you don't use it for RL, it`s needed for compatibility paths)
- `winetricks` installed (`sudo dnf install winetricks` / `sudo apt install winetricks`)

---

## Step 1  Find your paths

You'll need two paths. Find them in **Heroic → Rocket League → Settings**:

- **Wine Prefix**  something like `/home/YOU/Games/Heroic/Prefixes/default/Rocket League`
- **Proton version**  something like `GE-Proton10-33`

The Proton binary will be at:
```
~/.local/share/Steam/compatibilitytools.d/GE-Proton10-33/
```

---

## Step 2  Set the Wine prefix to Windows 10 and install dependencies

```bash
WINEPREFIX="/home/YOU/Games/Heroic/Prefixes/default/Rocket League" \
winetricks win10 vcrun2022
```

> If winetricks says `vcrun2022` is already installed, that's fine — skip it.

---

## Step 3  Link the game into the Wine prefix

Heroic installs the game outside the Wine prefix, so the BakkesMod installer can't find it. Fix this with a symlink:

```bash
ln -s "/home/YOU/Games/Heroic/rocketleague" \
"/home/YOU/Games/Heroic/Prefixes/default/Rocket League/drive_c/Program Files/rocketleague"
```

---

## Step 4  Install BakkesMod

Download **BakkesModSetup.exe** from [bakkesmod.com](https://bakkesmod.com), then run it using Proton's Wine:

```bash
WINEPREFIX="/home/YOU/Games/Heroic/Prefixes/default/Rocket League" \
~/.local/share/Steam/compatibilitytools.d/GE-Proton10-33/files/bin/wine \
~/Downloads/BakkesModSetup.exe
```

Go through the installer normally. If it opens a folder picker asking for the RL install location, navigate to:
```
C:\Program Files\rocketleague\Binaries\Win64
```

Verify it installed correctly:
```bash
ls "/home/YOU/Games/Heroic/Prefixes/default/Rocket League/drive_c/Program Files/BakkesMod/"
# Should show: BakkesMod.exe  unins000.dat  unins000.exe
```

---

## Step 5  Heroic settings

In **Heroic → Rocket League → Settings**, make sure:
- **Esync** is **disabled**
- **Fsync** is **enabled**

> Having both enabled causes a conflict that prevents the game from launching properly.

---

## Step 6  Launch BakkesMod

Use the included `bakkesmod.sh` script, or run manually:

```bash
WINEPREFIX="/home/YOU/Games/Heroic/Prefixes/default/Rocket League" \
STEAM_COMPAT_DATA_PATH="/home/YOU/Games/Heroic/Prefixes/default/Rocket League" \
STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.steam/steam" \
PROTONPATH="$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton10-33" \
WINEFSYNC=1 \
"$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton10-33/files/bin/wine" \
"/home/YOU/Games/Heroic/Prefixes/default/Rocket League/drive_c/Program Files/BakkesMod/BakkesMod.exe"
```

**Every session:**
1. Launch Rocket League from Heroic
2. Wait until you're at the **main menu**
3. Run `bakkesmod.sh` (or the command above)
4. Press **F2** in-game to open the BakkesMod menu

---

## Using the launch script

Edit `bakkesmod.sh` and fill in your paths at the top:

```bash
WINE_PREFIX="/home/YOU/Games/Heroic/Prefixes/default/Rocket League"
PROTON_PATH="$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton10-33"
STEAM_PATH="$HOME/.steam/steam"
```

Then make it executable and run it:
```bash
chmod +x bakkesmod.sh
./bakkesmod.sh
```

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `Mod is out of date, waiting for update` | Click "Settings" then uncheck "Enable safe mode" |
| `Failed to open fsync shared memory` | Disable Esync in Heroic settings, keep only Fsync |
| BakkesMod installer can't find RL | Do the symlink in Step 3 |
| Wine binary not found | Check your Proton version name matches exactly |
| BakkesMod opens but doesn't inject | Make sure RL is fully loaded to the main menu first |

---

## Notes

- The in-game **BakkesMod GUI may not render** but plugins and the console should work fine
- This guide uses **umu-launcher** which is what Heroic uses, that's why we need the `STEAM_COMPAT_*` environment variables
- Tested with GE-Proton-10-33 but should work with other Proton versions, just update the path

---

*Guide by Doge*
