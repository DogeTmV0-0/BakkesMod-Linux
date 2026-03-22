#!/bin/bash
# ==============================================================
# BakkesMod launcher for Heroic Games Launcher (Epic Games)
# Tested on: Fedora 43, GE-Proton10-33, Heroic 2.20.1
# Guide: https://github.com/DogeTmV0-0/BakkesMod-Linux
# ==============================================================

# ---------------------------------------------------------------
# EDIT THESE TO MATCH YOUR SETUP
# ---------------------------------------------------------------

# Path to your Wine prefix for Rocket League
# Find it in Heroic -> Rocket League -> Settings -> Wine Prefix
WINE_PREFIX="/home/$USER/Games/Heroic/Prefixes/default/Rocket League"

# Path to your Proton/Wine installation
# GE-Proton installed via Steam or ProtonPlus is usually here:
PROTON_PATH="$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton10-33"
# If you use a different version, change GE-Proton10-33 to match yours

# Path to your Steam install (even if using Heroic, Steam needs to be installed)
STEAM_PATH="$HOME/.steam/steam"

# ---------------------------------------------------------------
# DO NOT EDIT BELOW THIS LINE
# ---------------------------------------------------------------

BAKKESMOD_EXE="$WINE_PREFIX/drive_c/Program Files/BakkesMod/BakkesMod.exe"
WINE_BIN="$PROTON_PATH/files/bin/wine"

if [ ! -f "$WINE_BIN" ]; then
    echo "ERROR: Wine binary not found at: $WINE_BIN"
    echo "Check your PROTON_PATH variable."
    exit 1
fi

if [ ! -f "$BAKKESMOD_EXE" ]; then
    echo "ERROR: BakkesMod.exe not found at: $BAKKESMOD_EXE"
    echo "Make sure BakkesMod is installed. See the guide for instructions."
    exit 1
fi

echo "Launching BakkesMod..."
echo "Make sure Rocket League is already running and you are at the main menu"
echo ""

WINEPREFIX="$WINE_PREFIX" \
STEAM_COMPAT_DATA_PATH="$WINE_PREFIX" \
STEAM_COMPAT_CLIENT_INSTALL_PATH="$STEAM_PATH" \
PROTONPATH="$PROTON_PATH" \
WINEFSYNC=1 \
"$WINE_BIN" "$BAKKESMOD_EXE"
