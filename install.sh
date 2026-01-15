#!/bin/bash

set -ex

# Dotfiles install script
# This script is idempotent - safe to run multiple times

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing dotfiles..."

# Update package lists (allow warnings from third-party repos)
sudo apt-get update

# Add Alacritty PPA
if ! grep -q "aslatter/ppa" /etc/apt/sources.list.d/*.list 2>/dev/null; then
    echo "Adding Alacritty PPA..."
    sudo add-apt-repository -y ppa:aslatter/ppa
    sudo apt-get update
fi

# Install i3 window manager
if ! command -v i3 &> /dev/null; then
    echo "Installing i3..."
    sudo apt-get install -y i3
else
    echo "i3 is already installed"
fi

# Install i3 ecosystem and desktop utilities
PACKAGES=(
    i3status
    i3lock
    polybar
    rofi
    feh
    scrot
    conky
    brightnessctl
    imagemagick
    python3
    python3-pip
    dunst
    alacritty
    xdotool
    xclip
    fonts-font-awesome
    papirus-icon-theme
    pulseaudio-utils
)

for pkg in "${PACKAGES[@]}"; do
    if ! dpkg -s "$pkg" &> /dev/null; then
        echo "Installing $pkg..."
        sudo apt-get install -y "$pkg"
    else
        echo "$pkg is already installed"
    fi
done

# Install JetBrains Mono font
if ! fc-list | grep -qi "JetBrains Mono"; then
    echo "Installing JetBrains Mono font..."
    mkdir -p ~/.local/share/fonts
    cd /tmp
    wget -q https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip
    unzip -o JetBrainsMono-2.304.zip -d JetBrainsMono
    cp JetBrainsMono/fonts/ttf/*.ttf ~/.local/share/fonts/
    fc-cache -f
    rm -rf JetBrainsMono JetBrainsMono-2.304.zip
    cd "$SCRIPT_DIR"
else
    echo "JetBrains Mono font is already installed"
fi

# Install zsh
if ! command -v zsh &> /dev/null; then
    echo "Installing zsh..."
    sudo apt-get install -y zsh
else
    echo "zsh is already installed"
fi

# Install powerlevel10k
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    echo "Installing powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    echo "powerlevel10k is already installed"
fi

# Install Python packages via pip
PIP_PACKAGES=(
    pywal
    wpgtk
)

for pkg in "${PIP_PACKAGES[@]}"; do
    if ! pip3 show "$pkg" &> /dev/null; then
        echo "Installing $pkg..."
        pip3 install "$pkg"
    else
        echo "$pkg is already installed"
    fi
done

# Create config directories
CONFIG_DIRS=(
    "$HOME/.config/i3"
    "$HOME/.config/polybar"
    "$HOME/.config/rofi"
    "$HOME/.config/dunst"
    "$HOME/.config/alacritty"
    "$HOME/.config/wpg/templates"
    "$HOME/.config/scripts"
    "$HOME/Pictures/Wallpapers"
)

for dir in "${CONFIG_DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        echo "Creating $dir..."
        mkdir -p "$dir"
    else
        echo "$dir already exists"
    fi
done

# Copy config files
echo "Copying config files..."

# i3 config
cp "$SCRIPT_DIR/.config/i3/config" "$HOME/.config/i3/config"

# Polybar config
cp "$SCRIPT_DIR/.config/polybar/config.ini" "$HOME/.config/polybar/config.ini"

# Alacritty config
cp "$SCRIPT_DIR/.config/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"

# Rofi config
cp "$SCRIPT_DIR/.config/rofi/config.rasi" "$HOME/.config/rofi/config.rasi"

# Dunst config
cp "$SCRIPT_DIR/.config/dunst/dunstrc" "$HOME/.config/dunst/dunstrc"
cp "$SCRIPT_DIR/.config/dunst/generate-dunstrc.sh" "$HOME/.config/dunst/generate-dunstrc.sh"
chmod +x "$HOME/.config/dunst/generate-dunstrc.sh"

# Scripts
cp "$SCRIPT_DIR/.config/scripts/"*.sh "$HOME/.config/scripts/"
chmod +x "$HOME/.config/scripts/"*.sh

# Xprofile
cp "$SCRIPT_DIR/.xprofile" "$HOME/.xprofile"

# Initialize wpg with default settings
if command -v wpg &> /dev/null; then
    echo "Initializing wpg..."
    wpg-install.sh -i 2>/dev/null || true
fi

echo ""
echo "=========================================="
echo "Installation complete!"
echo ""
echo "Next steps:"
echo "1. Add some wallpapers to ~/Pictures/Wallpapers"
echo "2. Log out and select i3 as your session"
echo "3. Press Super+W to pick a wallpaper and auto-theme"
echo "=========================================="
