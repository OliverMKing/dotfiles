#!/bin/bash
# Apply theme script - reloads all applications with new colors

# Kill existing processes
pkill -x polybar

# Wait for processes to die
sleep 0.5

# Generate dunstrc with new colors
~/.config/dunst/generate-dunstrc.sh &

# Merge Xresources
xrdb -merge ~/.cache/wal/colors.Xresources 2>/dev/null

# Wait for color files to be generated
sleep 0.3

# Start polybar
polybar main -c ~/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar.log >/dev/null &

# Reload i3 config
i3-msg reload &

exit 0
