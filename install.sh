#!/bin/bash
# install.sh - Downloads, extracts, and installs BakkesMod into your Wine prefix
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
CONF_FILE="$DIR/bakkesmod.conf"
BAKKESMOD_ZIP_URL="https://github.com/bakkesmodorg/BakkesModInjectorCpp/releases/latest/download/BakkesModSetup.zip"

if [ ! -f "$CONF_FILE" ]; then
    echo "No config found. Running configure.sh first..."
    "$DIR/configure.sh"
fi
# shellcheck source=/dev/null
source "$CONF_FILE"

for cmd in curl unzip winetricks; do
    command -v "$cmd" >/dev/null 2>&1 || { echo "ERROR: '$cmd' is required but not installed."; exit 1; }
done

WINE_BIN="$PROTON_PATH/files/bin/wine"
[ -x "$WINE_BIN" ] || { echo "ERROR: Wine binary not found at $WINE_BIN"; exit 1; }

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
ZIP_PATH="$TMP_DIR/BakkesModSetup.zip"

echo "== Step 1/4: Downloading BakkesMod installer =="
curl -L -o "$ZIP_PATH" "$BAKKESMOD_ZIP_URL"

echo "== Step 2/4: Extracting installer =="
unzip -o "$ZIP_PATH" -d "$TMP_DIR" >/dev/null
INSTALLER_EXE="$(find "$TMP_DIR" -iname '*.exe' | head -n1)"
[ -n "$INSTALLER_EXE" ] || { echo "ERROR: No .exe found inside the downloaded zip."; exit 1; }
echo "Found installer: $(basename "$INSTALLER_EXE")"

echo "== Step 3/4: Preparing Wine prefix (win10 + vcrun2022) =="
WINEPREFIX="$WINE_PREFIX" winetricks --unattended win10 vcrun2022

if [ -n "${GAME_DIR:-}" ]; then
    LINK_TARGET="$WINE_PREFIX/drive_c/Program Files/rocketleague"
    if [ ! -e "$LINK_TARGET" ]; then
        echo "Linking game folder into Wine prefix..."
        ln -s "$GAME_DIR" "$LINK_TARGET"
    else
        echo "Symlink already exists at $LINK_TARGET, skipping."
    fi
else
    echo "No GAME_DIR set in config — skipping symlink step. If the installer can't find RL, add GAME_DIR to bakkesmod.conf and re-run."
fi

echo "== Step 4/4: Running BakkesMod installer =="
echo "(A Windows installer window should appear. If asked for the install location, use:"
echo "  C:\\Program Files\\rocketleague\\Binaries\\Win64)"
WINEPREFIX="$WINE_PREFIX" "$WINE_BIN" "$INSTALLER_EXE"

echo
if [ -f "$WINE_PREFIX/drive_c/Program Files/BakkesMod/BakkesMod.exe" ]; then
    echo "✅ Install verified — BakkesMod.exe found."
else
    echo "⚠️  BakkesMod.exe not found where expected. Check the installer output above."
fi

echo
echo "Also confirm in Heroic → Rocket League → Settings: Esync OFF, Fsync ON."
echo "Next: run ./launch.sh (after Rocket League is running) to start BakkesMod."
