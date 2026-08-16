# BakkesMod on Linux with Heroic Games Launcher (Epic Games)

Automated setup and launcher for getting BakkesMod working with Rocket League installed via **Heroic Games Launcher** (Epic Games Store) on Linux.
> Tested on: **Fedora 43**, **GE-Proton10-33**, **Heroic 2.20.1 rpm**
> Should work on most distros with minor path adjustments.
---

## Prerequisites

- Heroic Games Launcher installed by a native package (will work without it but it might need extra changes)
- Rocket League installed and running via Heroic Games Launcher
- GE-Proton installed (via [ProtonPlus](https://github.com/nicowillis/protonplus) or manually into `~/.local/share/Steam/compatibilitytools.d/`)
- Steam installed (even if you don't use it for RL, it`s needed for compatibility paths)
- `winetricks` installed (`sudo dnf install winetricks` / `sudo apt install winetricks`)
- `curl` and `unzip` installed

---

## Setup

This repo automates the install and launch process with four scripts instead of manual steps:

| Script | What it does |
| --- | --- |
| `configure.sh` | Auto-detects your Steam path, Proton install, Wine prefix, and Rocket League folder, and saves them to `bakkesmod.conf`. Only asks you for input if something can't be found automatically. |
| `install.sh` | Downloads the latest BakkesMod installer, extracts it, runs the required `winetricks` dependencies, symlinks the game folder into the Wine prefix, and runs the installer — all in one go. |
| `launch.sh` | Auto-launches Rocket League (via Heroic's deep link) if it isn't already running, waits for it to reach the main menu, then starts BakkesMod. Run this every session. |
| `create-desktop-entry.sh` | Adds a "BakkesMod (Rocket League)" entry to your application launcher so you can start everything with one click, no terminal needed. |

### One-time setup

```bash
chmod +x configure.sh install.sh launch.sh create-desktop-entry.sh
./configure.sh
```

### Install BakkesMod

```bash
./install.sh
```

If the installer opens a folder picker asking for the RL install location, point it at:

```
C:\Program Files\rocketleague\Binaries\Win64
```

In **Heroic → Rocket League → Settings**, also make sure:

- **Esync** is **disabled**
- **Fsync** is **enabled**

> Having both enabled causes a conflict that prevents the game from launching properly. This one setting isn't automatable from outside Heroic, so it's a manual one-time check.

### Launch BakkesMod

```bash
./launch.sh
```

**Every session:** just run this. It will try to launch Rocket League for you and wait for the main menu; if auto-launch doesn't work on your setup, it'll tell you to start Rocket League manually and re-run. Press **F2** in-game to open the BakkesMod menu once it's running.

### Optional: one-click launcher

```bash
./create-desktop-entry.sh
```

Adds an app-launcher entry so you can start BakkesMod without opening a terminal.

### Re-configuring

Re-run `./configure.sh` any time you change your Proton version or move your Heroic library. `bakkesmod.conf` holds your personal paths and is git-ignored — it's generated locally, not something to commit or share.

---

## Troubleshooting

| Problem                                  | Fix                                                 |
| ---------------------------------------- | --------------------------------------------------- |
| `Mod is out of date, waiting for update` | Click "Settings" then uncheck "Enable safe mode"    |
| `Failed to open fsync shared memory`     | Disable Esync in Heroic settings, keep only Fsync   |
| BakkesMod installer can't find RL        | Make sure `GAME_DIR` is set correctly in `bakkesmod.conf` (re-run `configure.sh` if unsure) |
| Wine binary not found                    | Re-run `configure.sh` and confirm your Proton version matches exactly |
| BakkesMod opens but doesn't inject       | Make sure RL is fully loaded to the main menu first |

---

## Notes

- The in-game **BakkesMod GUI may not render** but plugins and the console should work fine
- This guide uses **umu-launcher** which is what Heroic uses, that's why we need the `STEAM_COMPAT_*` environment variables
- Tested with GE-Proton-10-33 but should work with other Proton versions — `configure.sh` will pick it up automatically
- Auto-launching Rocket League relies on Heroic's `heroic://launch/` deep link, which isn't guaranteed to be enabled on every setup — if it doesn't fire, `launch.sh` falls back to asking you to start the game manually

---

*Guide by Doge*
