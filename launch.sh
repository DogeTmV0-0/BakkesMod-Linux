#!/bin/bash
# launch.sh - Launches Rocket League (if needed) then BakkesMod, with no manual path editing
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
CONF_FILE="$DIR/bakkesmod.conf"

if [ ! -f "$CONF_FILE" ]; then
    echo "No config found. Run ./configure.sh first."
    exit 1
fi
# shellcheck source=/dev/null
source "$CONF_FILE"

BAKKESMOD_EXE="$WINE_PREFIX/drive_c/Program Files/BakkesMod/BakkesMod.exe"
WINE_BIN="$PROTON_PATH/files/bin/wine"

[ -x "$WINE_BIN" ] || { echo "ERROR: Wine binary not found at $WINE_BIN"; exit 1; }
[ -f "$BAKKESMOD_EXE" ] || { echo "ERROR: BakkesMod.exe not found. Run ./install.sh first."; exit 1; }

is_rl_running() {
    pgrep -if "RocketLeague.exe" >/dev/null 2>&1
}

if ! is_rl_running; then
    echo "Rocket League isn't running yet."
    if command -v xdg-open >/dev/null 2>&1; then
        echo "Trying to launch it via Heroic's deep link..."
        xdg-open "heroic://launch/rocketleague" >/dev/null 2>&1 || true
    fi
    echo "Waiting for Rocket League to start (up to 2 minutes)..."
    echo "(If it doesn't launch automatically, start it from Heroic now.)"
    for _ in $(seq 1 60); do
        is_rl_running && break
        sleep 2
    done
    if ! is_rl_running; then
        echo "ERROR: Rocket League still isn't detected as running."
        echo "Launch it manually from Heroic, wait for the main menu, then re-run this script."
        exit 1
    fi
    echo "Rocket League process detected. Giving it time to reach the main menu..."
    sleep 20
fi

echo "Launching BakkesMod..."
WINEPREFIX="$WINE_PREFIX" \
STEAM_COMPAT_DATA_PATH="$WINE_PREFIX" \
STEAM_COMPAT_CLIENT_INSTALL_PATH="$STEAM_PATH" \
PROTONPATH="$PROTON_PATH" \
WINEFSYNC=1 \
"$WINE_BIN" "$BAKKESMOD_EXE"
