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
    find "$TARGET_HOME/.local/bin" -type f -exec chmod +x {} +
    echo " - Custom scripts restored and made executable."
else
    echo " - No custom scripts found in backup."
fi

# Restore Home Files
echo "Restoring dotfiles to home directory..."
if [ -d "$BACKUP_DIR/home" ]; then
    cp -rp "$BACKUP_DIR/home/." "$TARGET_HOME/"
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
if [ -d "$BACKUP_DIR/wallpaper-all" ]; then
    echo "Restoring all wallpaper selection menu options..."
    mkdir -p "$TARGET_HOME/Pictures/wallpaper-all"
    cp -r "$BACKUP_DIR/wallpaper-all"/* "$TARGET_HOME/Pictures/wallpaper-all/"
    echo " - Wallpaper selection menu folder successfully restored."
fi

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

# Adjust hardcoded home paths in restored files
echo "Adjusting configuration paths for your local user..."
find "$TARGET_HOME/.config" "$TARGET_HOME/.local/bin" "$TARGET_HOME/.zshrc" "$TARGET_HOME/.p10k.zsh" "$TARGET_HOME/.fehbg" "$TARGET_HOME/.gtkrc-2.0" "$TARGET_HOME/.Xresources" -type f 2>/dev/null | while read -r file; do
    if [ -f "$file" ]; then
        if grep -q "/home/dionovan" "$file" 2>/dev/null; then
            sed -i "s|/home/dionovan|${TARGET_HOME}|g" "$file"
        fi
    fi
done
echo " - Hardcoded paths successfully customized to $TARGET_HOME."

# Restore GRUB and SDDM configs (requires sudo)
if [ -d "$BACKUP_DIR/grub" ] || [ -d "$BACKUP_DIR/sddm" ]; then
    echo ""
    echo "=== System Configurations (GRUB & SDDM) ==="
    echo "This script can also restore system-wide configurations (GRUB & SDDM)."
    echo "WARNING: This requires root privileges (sudo) and will overwrite system configuration files."
    read -p "Do you want to restore system-wide configs? (y/N): " sys_confirm
    if [[ "$sys_confirm" =~ ^[Yy]$ ]]; then
        echo "Restoring GRUB configuration..."
        if [ -f "$BACKUP_DIR/grub/grub" ]; then
            sudo cp "$BACKUP_DIR/grub/grub" /etc/default/grub
        fi
        if [ -f "$BACKUP_DIR/grub/40_custom" ]; then
            sudo cp "$BACKUP_DIR/grub/40_custom" /etc/grub.d/40_custom
        fi
        if [ -d "$BACKUP_DIR/grub/themes/astronaut-catppucin-1.02" ]; then
            sudo mkdir -p /boot/grub/themes
            sudo cp -r "$BACKUP_DIR/grub/themes/astronaut-catppucin-1.02" /boot/grub/themes/
        fi
        
        echo "Restoring SDDM configuration..."
        if [ -f "$BACKUP_DIR/sddm/sddm.conf" ]; then
            sudo cp "$BACKUP_DIR/sddm/sddm.conf" /etc/sddm.conf
        fi
        if [ -d "$BACKUP_DIR/sddm/themes/pixel-night-city" ]; then
            sudo mkdir -p /usr/share/sddm/themes
            sudo cp -r "$BACKUP_DIR/sddm/themes/pixel-night-city" /usr/share/sddm/themes/
        fi
        echo " - System configurations successfully restored."
    else
        echo " - Skipped system configuration restoration."
    fi
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
