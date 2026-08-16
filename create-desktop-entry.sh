#!/bin/bash
# create-desktop-entry.sh - Adds a clickable app launcher entry for launch.sh
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
DESKTOP_FILE="$HOME/.local/share/applications/bakkesmod-linux.desktop"

[ -x "$DIR/launch.sh" ] || chmod +x "$DIR/launch.sh"

mkdir -p "$(dirname "$DESKTOP_FILE")"
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Type=Application
Name=BakkesMod (Rocket League)
Comment=Launch BakkesMod for Rocket League via Heroic/Proton
Exec=$DIR/launch.sh
Icon=applications-games
Terminal=true
Categories=Game;
EOF

chmod +x "$DESKTOP_FILE"
echo "Desktop entry created: $DESKTOP_FILE"
echo "Look for 'BakkesMod (Rocket League)' in your application launcher."
