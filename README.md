# BSPWM & Ricing Backup Pack (Debian -> Arch Linux)

This folder contains all configuration files, shortcuts, custom scripts, themes, icons, fonts, and active wallpapers from your current Debian system. You can move this folder to a USB drive, external disk, or save it in the cloud when installing your new Arch Linux distribution.

---

## 📂 Backup Structure
* **`config/`**: Contains configuration folders from `~/.config/` for desktop environment applications:
  * `bspwm/` (Window manager settings)
  * `sxhkd/` (Keyboard shortcuts)
  * `polybar/` (Status bar)
  * `rofi/` (App launcher & menus)
  * `picom/` (Compositor/transparency/fading)
  * `alacritty/` (Terminal emulator)
  * `cava/` (Console audio visualizer)
  * `gtk-3.0/` & `gtk-4.0/` (GTK theme configs)
  * `autostart/` (Desktop autostart files)
  * `nvim/` (Neovim text editor configuration)
  * `Code/User/` (VSCode user settings & keybindings)
  * `fastfetch/` (Fastfetch system info styling)
  * `neovide/` (Neovide editor GUI configuration)
  * `zed/` (Zed editor configuration)
  * `Thunar/` (Thunar custom actions & shortcuts)
  * `calcurse/` (Calcurse calendar configuration & shortcuts)
  * `xsettingsd/` (Desktop xsettings configurations)
  * `mimeapps.list` (Default file associations)
* **`local_bin/`**: Contains your custom scripts from `~/.local/bin/` (such as audio menu, alt-tab switcher, powermenu, etc.).
* **`home/`**: Contains important dotfiles from your home directory:
  * `.zshrc` & `.p10k.zsh` (Powerlevel10k shell styling)
  * `.Xresources` (Cursor & X11 settings)
  * `.fehbg` (Wallpaper restorer)
  * `.gtkrc-2.0` (GTK theme settings)
* **`themes/`**: Stores custom GTK themes (`Everforest-BL-MB-Dark`, `Gruvbox-BL-LB-Dark`, etc.).
* **`icons/`**: Stores custom icon packs (`Everforest-Dark`, `buuf-icons-for-plasma`).
* **`fonts/`**: Stores custom fonts (`MaterialIcons`, `NerdFonts`).
* **`wallpaper/`**: Stores the active wallpaper along with its original path file `path.txt` so it can be restored to its exact location.
* **`wallpaper-all/`**: Contains all wallpaper options available in the custom wallpaper selection menu.

---

## ⚡ How to Restore on Arch Linux

### 1. Install Dependencies
Before running the restore script, ensure you have installed all desktop environment dependencies and supporting tools on Arch Linux using `pacman` and an AUR helper (such as `yay` or `paru`):

```bash
# 1. Install main tools via Pacman
sudo pacman -S bspwm sxhkd polybar rofi picom alacritty cava feh zsh xclip maim xdotool calcurse thunar neovim code fastfetch neovide zed xsettingsd breeze-gtk breeze-icons breeze polkit-kde-agent
```

### 2. Run the Restore Script
Open a terminal, navigate to this backup folder, and run:

```bash
chmod +x restore.sh
./restore.sh
```

The script will automatically move all folders/files to their respective locations in your new home directory (`~/.config`, `~/.local/bin`, `~/`, etc.), apply the correct executable permissions to the custom scripts, adjust hardcoded paths dynamically to match your new system username, and update the font cache.

---

## ⚠️ Important Things to Note

1. **Polkit Agent (IMPORTANT)**:
   * The `bspwmrc` configuration in this repository has been updated to use `polkit-kde-agent` by default as it is directly available in the official Arch Linux repository.
   * **Solution**: Ensure you install the `polkit-kde-agent` package using Pacman on Arch Linux so that root access authentication (such as for KDE Partition Manager or mounting disks) works out-of-the-box.

2. **Web Browser (Helium)**:
   * The Helium profile folder in `~/.config/net.imput.helium` has a cache of ~1.2GB and was **intentionally omitted** to keep the backup lightweight and fast.
   * You will need to reinstall Helium (available via the AUR or its official website) and log back in to WhatsApp Web/Spotify within it.

3. **Wallpaper & Wallpaper Menu**:
   * Your custom wallpaper script looks for images inside the `/home/dionovan/Pictures/wallpaper-all` directory.
   * All wallpaper selections inside the `wallpaper-all/` folder, as well as the currently active wallpaper ([wallhaven-2e2xyx.jpg](file:///home/dionovan/projects/portfolio/dotfiles/wallpaper/wallhaven-2e2xyx.jpg)), are now backed up in the repository and will be automatically restored to the target `/home/dionovan/Pictures/wallpaper-all/` folder when you run the restore script.

4. **Default Shell (Zsh)**:
   * After restoring `.zshrc` and `.p10k.zsh`, change your user's default shell to Zsh by running:
     ```bash
     chsh -s $(which zsh)
     ```
