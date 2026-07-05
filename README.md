# BSPWM & Ricing Backup Pack (Debian -> Arch Linux)

Folder ini berisi semua file konfigurasi, shortcut, custom scripts, tema, ikon, font, dan wallpaper aktif dari sistem Debian-mu saat ini. Kamu bisa memindahkan folder ini ke USB drive, disk eksternal, atau menyimpannya di cloud saat menginstal distro Arch Linux barumu.

---

## 📂 Struktur Backup
* **`config/`**: Berisi folder konfigurasi dari `~/.config/` untuk aplikasi desktop environment:
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
* **`local_bin/`**: Berisi script kustom buatanmu dari `~/.local/bin/` (seperti menu audio, alt-tab switcher, powermenu, dll.).
* **`home/`**: Berisi dotfiles penting dari home directory-mu:
  * `.zshrc` & `.p10k.zsh` (Powerlevel10k shell styling)
  * `.Xresources` (Cursor & X11 settings)
  * `.fehbg` (Wallpaper restorer)
  * `.gtkrc-2.0` (GTK theme settings)
* **`themes/`**: Menyimpan custom GTK themes (`Everforest-BL-MB-Dark`, `Gruvbox-BL-LB-Dark`, dll.).
* **`icons/`**: Menyimpan custom icon packs (`Everforest-Dark`, `buuf-icons-for-plasma`).
* **`fonts/`**: Menyimpan font kustom (`MaterialIcons`, `NerdFonts`).
* **`wallpaper/`**: Menyimpan wallpaper aktif (`street-4.png`) berserta path aslinya agar dapat dikembalikan dengan pas.

---

## ⚡ Cara Restore di Arch Linux

### 1. Install Dependencies
Sebelum menjalankan restore script, pastikan kamu telah menginstal semua dependency desktop environment dan tool pendukung di Arch Linux menggunakan `pacman` dan helper AUR (seperti `yay` atau `paru`):

```bash
# 1. Install tool utama via Pacman
sudo pacman -S bspwm sxhkd polybar rofi picom alacritty cava feh zsh xclip maim xdotool calcurse thunar neovim code fastfetch neovide zed xsettingsd breeze-gtk breeze-icons breeze polkit-kde-agent
```

### 2. Jalankan Restore Script
Buka terminal, arahkan ke folder backup ini, lalu jalankan:

```bash
chmod +x restore.sh
./restore.sh
```

Script di atas akan secara otomatis memindahkan semua folder/file ke lokasinya masing-masing di home directory barumu (`~/.config`, `~/.local/bin`, `~/`, dll.), membetulkan hak akses executable pada script kustom, dan memperbarui font cache.

---

## ⚠️ Hal Penting yang Perlu Diperhatikan

1. **Polkit Agent (PENTING)**:
   * Konfigurasi `bspwmrc` di repositori ini telah diubah untuk menggunakan `polkit-kde-agent` secara default karena tersedia langsung di official repository Arch Linux.
   * **Solusi**: Pastikan kamu memasang package `polkit-kde-agent` menggunakan Pacman di Arch Linux agar autentikasi hak akses root (misalnya untuk KDE Partition Manager atau mounting disk) berfungsi secara out-of-the-box.

2. **Web Browser (Helium)**:
   * Folder profile Helium di `~/.config/net.imput.helium` memiliki cache sebesar ~1.2GB dan **sengaja dilewati** agar proses backup tetap ringan dan cepat.
   * Kamu perlu menginstal Helium kembali (bisa dicari di AUR atau website resminya) dan login ulang ke WhatsApp Web/Spotify di dalamnya.

3. **Wallpaper & Menu Wallpaper**:
   * Script kustom wallpaper-mu mencari gambar di folder `/home/dionovan/Pictures/wallpaper-all`.
   * Wallpaper aktif saat ini (`street-4.png`) telah di-restore ke folder tersebut secara otomatis. Namun, jika kamu memiliki wallpaper lain di folder `wallpaper-all` berukuran besar (total 1.3GB), pastikan kamu membackup folder `/home/dionovan/Pictures/wallpaper-all` secara manual ke harddisk/flashdisk eksternal dan menyalinnya kembali ke target.

4. **Default Shell (Zsh)**:
   * Setelah merestore `.zshrc` dan `.p10k.zsh`, ganti default shell user-mu ke Zsh dengan menjalankan:
     ```bash
     chsh -s $(which zsh)
     ```
