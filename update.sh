#!/usr/bin/env bash
set -e

echo "==================================================================="
echo "    Update Cosmic Slider Mod (macOS / Linux)"
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
  echo "❌ Error: Claude Desktop directory not found!"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ONLINE_URL="https://raw.githubusercontent.com/santoxas-1/claude-desktop-cosmic-slider/main/cosmic-slider.js"

echo "🌐 Checking for online updates..."
if curl -s -f "$ONLINE_URL" -o "$SCRIPT_DIR/cosmic-slider.js.tmp"; then
  if [ -s "$SCRIPT_DIR/cosmic-slider.js.tmp" ]; then
    mv "$SCRIPT_DIR/cosmic-slider.js.tmp" "$SCRIPT_DIR/cosmic-slider.js"
    echo "✅ Successfully fetched the latest cosmic-slider.js from repository"
  fi
else
  rm -f "$SCRIPT_DIR/cosmic-slider.js.tmp"
  echo "ℹ️ Online update unavailable, using local file."
fi

# Deploy file
cp "$SCRIPT_DIR/cosmic-slider.js" "$ION_DIR/cosmic-slider.js"
echo "✅ Copied cosmic-slider.js to $ION_DIR"

# Verify index.html connection
if ! grep -q "cosmic-slider.js" "$ION_DIR/index.html"; then
  if grep -q "/i18n-ru.js" "$ION_DIR/index.html"; then
    sed -i.tmp 's|<script src="/i18n-ru.js"></script>|<script src="/i18n-ru.js"></script><script src="/cosmic-slider.js"></script>|g' "$ION_DIR/index.html"
  else
    sed -i.tmp 's|<head>|<head><script src="/cosmic-slider.js"></script>|g' "$ION_DIR/index.html"
  fi
  rm -f "$ION_DIR/index.html.tmp"
  echo "✅ Re-injected script tag into updated index.html"
else
  echo "✅ Script tag is active in index.html"
fi

echo ""
echo "🚀 Update completed! Restart Claude Desktop (Cmd+R / Ctrl+R)."
