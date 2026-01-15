#!/bin/bash
# Lock screen with i3lock-color using pywal colors

# Source pywal colors
source ~/.cache/wal/colors.sh

# Remove # from colors for i3lock-color format
bg="${color0:1}"
fg="${color7:1}"
accent="${color2:1}"
urgent="${color1:1}"

i3lock \
    --color="${bg}" \
    --inside-color="${bg}cc" \
    --ring-color="${accent}ff" \
    --line-uses-ring \
    --keyhl-color="${fg}ff" \
    --bshl-color="${urgent}ff" \
    --separator-color="${accent}ff" \
    --insidever-color="${accent}cc" \
    --insidewrong-color="${urgent}cc" \
    --ringver-color="${accent}ff" \
    --ringwrong-color="${urgent}ff" \
    --ind-pos="x+w/2:y+h/2" \
    --radius=120 \
    --ring-width=12 \
    --verif-text="Verifying..." \
    --wrong-text="Wrong!" \
    --noinput-text="No Input" \
    --lock-text="Locking..." \
    --lockfailed-text="Lock Failed" \
    --verif-color="${fg}ff" \
    --wrong-color="${urgent}ff" \
    --time-color="${fg}ff" \
    --date-color="${fg}cc" \
    --layout-color="${fg}ff" \
    --clock \
    --time-str="%H:%M" \
    --date-str="%a, %b %d" \
    --time-font="JetBrains Mono" \
    --date-font="JetBrains Mono" \
    --verif-font="JetBrains Mono" \
    --wrong-font="JetBrains Mono" \
    --time-size=48 \
    --date-size=18
