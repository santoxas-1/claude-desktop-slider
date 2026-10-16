#!/usr/bin/env bash
set -e

echo "==================================================================="
echo "    Uninstall Cosmic Slider Mod (macOS / Linux)"
echo "==================================================================="
echo ""

CANDIDATES=(
  "/Applications/Claude.app/Contents/Resources/ion-dist"
  "$HOME/Applications/Claude.app/Contents/Resources/ion-dist"
  "/opt/Claude/resources/ion-dist"
  "$HOME/.local/share/Claude/resources/ion-dist"
)

ION_DIR=""
for dir in "${CANDIDATES[@]}"; do
  if [ -d "$dir" ]; then
    ION_DIR="$dir"
    break
  fi
done

if [ -z "$ION_DIR" ]; then
  echo "❌ Error: Claude Desktop ion-dist directory not found!"
  exit 1
fi

if [ -f "$ION_DIR/index.html.cosmic.bak" ]; then
  mv "$ION_DIR/index.html.cosmic.bak" "$ION_DIR/index.html"
  echo "✅ index.html restored from backup"
else
  sed -i.tmp 's|<script src="/cosmic-slider.js"></script>||g' "$ION_DIR/index.html"
  rm -f "$ION_DIR/index.html.tmp"
  echo "✅ Removed script tag from index.html"
fi

if [ -f "$ION_DIR/cosmic-slider.js" ]; then
  rm -f "$ION_DIR/cosmic-slider.js"
  echo "✅ Removed cosmic-slider.js"
fi

echo ""
echo "🚀 Mod uninstalled successfully. Restart Claude Desktop."
