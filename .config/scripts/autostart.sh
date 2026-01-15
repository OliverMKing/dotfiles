#!/bin/bash
# i3 autostart script

# Load pywal colors
if [ -f ~/.cache/wal/colors.Xresources ]; then
    xrdb -merge ~/.cache/wal/colors.Xresources
fi

# Apply wal sequences
if [ -f ~/.cache/wal/sequences ]; then
    cat ~/.cache/wal/sequences
fi

# Set wallpaper
if [ -f ~/.cache/wal/wal ]; then
    feh --bg-fill "$(cat ~/.cache/wal/wal)"
fi

# Kill existing polybar instances
killall -q polybar

# Wait for processes to die
while pgrep -x polybar >/dev/null; do sleep 0.1; done

# Start polybar
polybar main -c ~/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar.log >/dev/null &

# Start dunst
if ! pgrep -x dunst >/dev/null; then
    dunst &
fi
