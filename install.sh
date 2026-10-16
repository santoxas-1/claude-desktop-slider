#!/usr/bin/env bash
set -e

echo "==================================================================="
echo "    Cosmic Slider Mod for Claude Desktop (macOS / Linux)"
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

echo "📁 Found Claude Desktop: $ION_DIR"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Backup index.html
if [ ! -f "$ION_DIR/index.html.cosmic.bak" ]; then
  cp "$ION_DIR/index.html" "$ION_DIR/index.html.cosmic.bak"
  echo "✅ Backup created: index.html.cosmic.bak"
fi

# 2. Copy cosmic-slider.js
cp "$SCRIPT_DIR/cosmic-slider.js" "$ION_DIR/cosmic-slider.js"
echo "✅ Copied cosmic-slider.js"

# 3. Inject script tag into index.html
if ! grep -q "cosmic-slider.js" "$ION_DIR/index.html"; then
  if grep -q "/i18n-ru.js" "$ION_DIR/index.html"; then
    sed -i.tmp 's|<script src="/i18n-ru.js"></script>|<script src="/i18n-ru.js"></script><script src="/cosmic-slider.js"></script>|g' "$ION_DIR/index.html"
  else
    sed -i.tmp 's|<head>|<head><script src="/cosmic-slider.js"></script>|g' "$ION_DIR/index.html"
  fi
  rm -f "$ION_DIR/index.html.tmp"
  echo "✅ Script tag added to index.html"
else
  echo "ℹ️ Script already connected in index.html"
fi

echo ""
echo "🚀 Installation completed successfully!"
echo "Restart Claude Desktop (or press Cmd+R / Ctrl+R) to enjoy Warp Speed mode."
