#!/usr/bin/env bash

# Exit on error
set -e

BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_HOME="$HOME"

echo "=== BSPWM Dotfiles Restore Script ==="
echo "This script will restore your desktop configuration, shortcuts, custom scripts, themes, icons, and fonts."
echo ""

# Ask for confirmation
read -p "Do you want to proceed with the restoration? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Restoration cancelled."
    exit 0
fi

# Create target directories
echo "Creating necessary directories..."
mkdir -p "$TARGET_HOME/.config"
mkdir -p "$TARGET_HOME/.local/bin"
mkdir -p "$TARGET_HOME/.themes"
mkdir -p "$TARGET_HOME/.local/share/icons"
mkdir -p "$TARGET_HOME/.fonts"
mkdir -p "$TARGET_HOME/.local/share/fonts"

# Restore Configs
echo "Restoring configuration files to ~/.config/..."
if [ -d "$BACKUP_DIR/config" ]; then
    cp -r "$BACKUP_DIR/config"/* "$TARGET_HOME/.config/"
    echo " - Configuration folders successfully restored."
else
    echo " - No config folder found in backup."
fi

# Restore Local Bin
echo "Restoring custom scripts to ~/.local/bin/..."
if [ -d "$BACKUP_DIR/local_bin" ]; then
    cp -r "$BACKUP_DIR/local_bin"/* "$TARGET_HOME/.local/bin/"
    chmod +x "$TARGET_HOME/.local/bin"/*.sh "$TARGET_HOME/.local/bin"/*.py 2>/dev/null || true
    echo " - Custom scripts restored and made executable."
else
    echo " - No custom scripts found in backup."
fi

# Restore Home Files
echo "Restoring dotfiles to home directory..."
if [ -d "$BACKUP_DIR/home" ]; then
    cp -r "$BACKUP_DIR/home"/.??* "$TARGET_HOME/" 2>/dev/null || true
    # Also copy non-hidden if any
    cp -r "$BACKUP_DIR/home"/* "$TARGET_HOME/" 2>/dev/null || true
    echo " - Home dotfiles successfully restored."
else
    echo " - No home files found in backup."
fi

# Restore Themes
echo "Restoring themes..."
if [ -d "$BACKUP_DIR/themes" ] && [ "$(ls -A "$BACKUP_DIR/themes")" ]; then
    cp -r "$BACKUP_DIR/themes"/* "$TARGET_HOME/.themes/"
    echo " - Themes successfully restored."
else
    echo " - No themes to restore."
fi

# Restore Icons
echo "Restoring icons..."
if [ -d "$BACKUP_DIR/icons" ] && [ "$(ls -A "$BACKUP_DIR/icons")" ]; then
    cp -r "$BACKUP_DIR/icons"/* "$TARGET_HOME/.local/share/icons/"
    echo " - Icons successfully restored."
else
    echo " - No icons to restore."
fi

# Restore Fonts
echo "Restoring fonts..."
if [ -d "$BACKUP_DIR/fonts/dot_fonts" ] && [ "$(ls -A "$BACKUP_DIR/fonts/dot_fonts")" ]; then
    cp -r "$BACKUP_DIR/fonts/dot_fonts"/* "$TARGET_HOME/.fonts/"
fi
if [ -d "$BACKUP_DIR/fonts/local_share" ] && [ "$(ls -A "$BACKUP_DIR/fonts/local_share")" ]; then
    cp -r "$BACKUP_DIR/fonts/local_share"/* "$TARGET_HOME/.local/share/fonts/"
fi
echo "Updating font cache..."
fc-cache -fv > /dev/null || echo "Warning: fc-cache failed to run. Make sure fontconfig is installed."
echo " - Fonts successfully restored."

# Restore Wallpaper
echo "Restoring wallpaper..."
if [ -f "$BACKUP_DIR/wallpaper/path.txt" ]; then
    WALL_PATH=$(cat "$BACKUP_DIR/wallpaper/path.txt")
    # Resolve path if it uses home
    WALL_PATH_RESOLVED="${WALL_PATH//\/home\/dionovan/$TARGET_HOME}"
    WALL_DIR=$(dirname "$WALL_PATH_RESOLVED")
    mkdir -p "$WALL_DIR"
    
    # Find the image file in backup (there should be only one image and path.txt)
    WALL_FILE=$(find "$BACKUP_DIR/wallpaper" -type f ! -name "path.txt" | head -n 1)
    if [ -n "$WALL_FILE" ]; then
        cp "$WALL_FILE" "$WALL_PATH_RESOLVED"
        echo " - Wallpaper restored to: $WALL_PATH_RESOLVED"
    else
        echo " - Warning: Wallpaper file not found in backup."
    fi
else
    echo " - No wallpaper path history found."
fi

echo ""
echo "=== IMPORTANT NOTICE ==="
echo "1. Arch package equivalents:"
echo "   Make sure you install the following packages using Pacman:"
echo "   sudo pacman -S bspwm sxhkd polybar rofi picom alacritty cava feh zsh xclip maim xdotool calcurse thunar neovim code fastfetch neovide zed xsettingsd breeze-gtk breeze-icons breeze polkit-kde-agent"
echo ""
echo "2. Polkit Authentication Agent:"
echo "   The backup bspwmrc has been configured to use 'polkit-kde-agent' which is available directly from the Arch Linux official repositories."
echo "   Ensure you install 'polkit-kde-agent' and it will run out-of-the-box."
echo ""
echo "3. Spicetify / Spotify / Web apps:"
echo "   These apps need to be installed manually on Arch. Your configurations have been copied,"
echo "   but you will need to install the software for them to work."
echo ""
echo "Restoration complete! Please log out and log back into your BSPWM session."
