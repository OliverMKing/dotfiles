#!/bin/bash
# Wallpaper picker script
# Uses rofi to select a wallpaper, then applies it with wpg/pywal

WALLPAPER_DIR="${HOME}/Pictures/Wallpapers"

# Create wallpaper directory if it doesn't exist
mkdir -p "$WALLPAPER_DIR"

# Check if wallpaper directory has any images
if [ -z "$(ls -A "$WALLPAPER_DIR" 2>/dev/null)" ]; then
    notify-send "Wallpaper Picker" "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Use rofi to select wallpaper
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) | \
    while read -r img; do
        echo -en "$(basename "$img")\0icon\x1f$img\n"
    done | rofi -dmenu -i -p "Wallpaper" -show-icons -theme-str 'element-icon { size: 128px; }')

# Exit if no selection
[ -z "$WALLPAPER" ] && exit 0

# Find full path of selected wallpaper
WALLPAPER_PATH=$(find "$WALLPAPER_DIR" -name "$WALLPAPER" -type f | head -1)

if [ -z "$WALLPAPER_PATH" ]; then
    notify-send "Wallpaper Picker" "Could not find wallpaper: $WALLPAPER"
    exit 1
fi

# Apply wallpaper and generate colors with wpg
if command -v wpg &> /dev/null; then
    wpg -s "$WALLPAPER_PATH"
else
    # Fallback to pywal if wpg not available
    wal -i "$WALLPAPER_PATH"
fi

# Run post-theme script to reload configs
~/.config/scripts/apply-theme.sh

notify-send "Wallpaper Applied" "$(basename "$WALLPAPER_PATH")"
