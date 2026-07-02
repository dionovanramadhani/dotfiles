# 🛠️ Gruvbox Dark Setup

Welcome to my **dotfiles** repository! This is a collection of my personal Linux configuration files centered around **bspwm** (tiling window manager) with a consistent, clean, and productive **Gruvbox Dark** theme.

---

## 📸 Visual Preview

### Desktop Preview

This repository is configured to use the beautiful **Gruvbox** theme for the status bar and launcher:

|                Default View                |                i3 Mode View                |
| :----------------------------------------: | :----------------------------------------: |
| ![Screenshot 1](polybar/screenshots/1.png) | ![Screenshot 2](polybar/screenshots/2.png) |

---

## ⚙️ System Components & Tech Stack

Below are the core technologies and applications used in this setup:

| Component                | Application                                             | Description / Theme                                          |
| :----------------------- | :------------------------------------------------------ | :----------------------------------------------------------- |
| **Window Manager**       | [bspwm](https://github.com/baskerville/bspwm)           | A lightweight, tiling window manager                         |
| **Hotkey Daemon**        | [sxhkd](https://github.com/baskerville/sxhkd)           | Keyboard shortcut manager                                    |
| **Status Bar**           | [polybar](https://github.com/polybar/polybar)           | Modular status bar styled with Gruvbox Dark                  |
| **Application Launcher** | [rofi](https://github.com/davatorium/rofi)              | Customized application menu & power menu                     |
| **Terminal Emulator**    | [alacritty](https://github.com/alacritty/alacritty)     | GPU-accelerated terminal with Bold typography                |
| **Text Editor**          | [neovim](https://github.com/neovim/neovim)              | Configured using the [NvChad](https://nvchad.com/) framework |
| **System Info**          | [fastfetch](https://github.com/fastfetch-cli/fastfetch) | Customized system info layout in Red                         |
| **Shell**                | Zsh                                                     | Configured directly in Alacritty                             |

---

## 🖥️ Dual Monitor Configuration

This setup is optimized specifically for a highly productive **Dual-Monitor** workstation:

1. **DP-0 (Primary Monitor)**:
   - Resolution: `1920x1080 @ 144Hz`
   - Orientation: Landscape (Primary)
   - Workspaces: `1`, `2`, `3`, `4`, `5`
   - Displays **Polybar** at the top.
2. **HDMI-0 (Secondary Monitor)**:
   - Resolution: `2560x1080 @ 75Hz`
   - Orientation: Portrait (Rotated right)
   - Workspaces: `6`, `7`, `8`, `9`
   - No Polybar to maximize the vertical viewing area.

---

## ⌨️ Key Keyboard Shortcuts (sxhkd)

Here are some of the most important hotkeys configured in `sxhkdrc`:

### Applications & Utilities

- `Alt + Return` : Launch **Alacritty** terminal
- `Super + Space` : Open **Rofi** (Application Launcher)
- `Super + X` : Open **Power Menu** (`powermenu.sh`)
- `Super + W` : Open **Wallpaper Menu** (`wallpaper_menu.sh`)
- `Alt + Shift + C` : Open Calendar (`calcurse`) in a floating terminal window
- `Alt + B` / `Super + H` : Launch the **Helium** web browser
- `Alt + O` : Open **Thunar** file manager
- `Alt + D` : Open **Discord**
- `Alt + W` : Open **WhatsApp Web** in Helium

### Window & Workspace Management

- `Super + Q` / `Ctrl + Q` : Close the active window
- `Alt + F` : Toggle between **Floating** and **Tiled** states
- `Super + Arrow Keys` : Shift focus to a window in the specified direction
- `Super + Shift + Arrow Keys` : Swap window positions
- `Super + Alt + Arrow Keys` : Move the active window between monitors (`DP-0` <-> `HDMI-0`)
- `Alt + [1-9]` : Switch workspace (desktop)
- `Alt + Shift + [1-9]` : Move the active window to a specific workspace

### Screenshots (maim)

- `Print` : Take a fullscreen screenshot (saved to `~/Pictures/Screenshots/` and copied to clipboard)
- `Super + Shift + S` : Screenshot a selected area (copied directly to clipboard)
- `Alt + Print` : Screenshot the active window (saved and copied to clipboard)

---

## 🚀 Installation & Requirements

### 1. Fonts & Icons

To ensure all glyphs, icons, and text elements render correctly, please install:

- **JetBrains Mono Nerd Font** (used in Rofi, Alacritty, and Polybar)
- **Material Icons (Round)** (provided in `polybar/fonts/MaterialIcons`)

Install the Material Icons manually:

```bash
mkdir -p ~/.fonts
cp -R ~/.config/polybar/fonts/MaterialIcons ~/.fonts/
fc-cache -f
```

Additionally, install the **Papirus** icon theme using your Linux distribution's package manager for the application launcher.

### 2. Setting Up Dotfiles

You can symlink these configuration directories to your `~/.config/` folder:

```bash
# Back up existing configurations if they exist
mv ~/.config/bspwm ~/.config/bspwm.backup
mv ~/.config/sxhkd ~/.config/sxhkd.backup
mv ~/.config/polybar ~/.config/polybar.backup
mv ~/.config/rofi ~/.config/rofi.backup
mv ~/.config/alacritty ~/.config/alacritty.backup
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.config/fastfetch ~/.config/fastfetch.backup

# Create symlinks from this dotfiles repository to ~/.config/
# (Assuming the repository is located at ~/projects/portfolio/dotfiles)
ln -sf ~/projects/portfolio/dotfiles/bspwm ~/.config/bspwm
ln -sf ~/projects/portfolio/dotfiles/sxhkd ~/.config/sxhkd
ln -sf ~/projects/portfolio/dotfiles/polybar ~/.config/polybar
ln -sf ~/projects/portfolio/dotfiles/rofi ~/.config/rofi
ln -sf ~/projects/portfolio/dotfiles/alacritty ~/.config/alacritty
ln -sf ~/projects/portfolio/dotfiles/nvim ~/.config/nvim
ln -sf ~/projects/portfolio/dotfiles/fastfetch ~/.config/fastfetch
```

### 3. Post-Install & Services

- **Wallpaper**: Setup uses `feh` to manage the wallpaper, which is loaded automatically through `bspwmrc` (using `.fehbg`).
- **Compositor**: `picom` is used for window transparency, blur, and shadows (`picom --config ~/.config/picom/picom.conf`).
- **Polkit Agent**: The default XFCE authentication agent (`xfce-polkit`) is initiated on startup to handle GUI authentication prompts.
