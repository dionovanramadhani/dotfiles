# Panduan Setup Desktop & System (Debian -> Arch Linux)

Dokumen ini berisi panduan langkah demi langkah untuk melakukan restorasi dan konfigurasi lingkungan desktop serta system bootloader Anda pada sistem Arch Linux baru.

Semua konfigurasi di bawah ini telah disinkronkan dan tersimpan di dalam repositori dotfiles Anda.

---

## 📂 Daftar Isi
1. [Setup BSPWM (Window Manager)](#1-setup-bspwm-window-manager)
2. [Setup Polybar (Status Bar)](#2-setup-polybar-status-bar)
3. [Setup Shortcuts (Keyboard Bindings)](#3-setup-shortcuts-keyboard-bindings)
4. [Setup Terminal (Alacritty)](#4-setup-terminal-alacritty)
5. [Setup SDDM & Theme (Display Manager)](#5-setup-sddm-theme-display-manager)
6. [Setup GRUB & Theme (Bootloader)](#6-setup-grub-theme-bootloader)
7. [Konfigurasi Dual-Boot Windows 10](#7-konfigurasi-dual-boot-windows-10)

---

## 1. Setup BSPWM (Window Manager)
BSPWM adalah window manager utama Anda. Konfigurasinya mengatur layout window, resolusi monitor, startup applications, dan penanganan window.

### Langkah-langkah:
1. Pastikan bspwm terinstal di sistem baru:
   ```bash
   sudo pacman -S bspwm
   ```
2. Salin file konfigurasi ke direktori config user Anda:
   ```bash
   mkdir -p ~/.config/bspwm
   cp config/bspwm/bspwmrc ~/.config/bspwm/
   chmod +x ~/.config/bspwm/bspwmrc
   ```
3. **Penting (Polkit Agent)**: 
   Konfigurasi [bspwmrc](file:///home/dionovan/projects/portfolio/dotfiles/config/bspwm/bspwmrc#L37-L39) yang baru telah disesuaikan untuk menggunakan `polkit-kde-agent`. Pasang agen tersebut via Pacman:
   ```bash
   sudo pacman -S polkit-kde-agent
   ```
   Agen ini otomatis mendeteksi hak akses administrator dan memunculkan popup password saat membuka program seperti GParted atau KDE Partition Manager.

---

## 2. Setup Polybar (Status Bar)
Polybar adalah panel status bar yang menampilkan informasi workspaces, volume, baterai, tanggal, dan notifikasi kustom.

### Langkah-langkah:
1. Pasang Polybar di Arch Linux:
   ```bash
   sudo pacman -S polybar
   ```
2. Salin konfigurasinya ke user directory:
   ```bash
   mkdir -p ~/.config/polybar
   cp -r config/polybar/* ~/.config/polybar/
   chmod +x ~/.config/polybar/launch.sh
   ```
3. Uji coba dengan menjalankan launcher script:
   ```bash
   ~/.config/polybar/launch.sh
   ```

---

## 3. Setup Shortcuts (Keyboard Bindings)
Pintasan keyboard Anda diatur menggunakan **sxhkd** (Simple X Hotkey Daemon). Pintasan mencakup navigasi desktop, peluncuran aplikasi (Rofi, Alacritty), dan pengaturan windows.

### Langkah-langkah:
1. Pasang sxhkd:
   ```bash
   sudo pacman -S sxhkd
   ```
2. Salin konfigurasi pintasan keyboard Anda:
   ```bash
   mkdir -p ~/.config/sxhkd
   cp config/sxhkd/sxhkdrc ~/.config/sxhkd/
   ```
3. Untuk menerapkan pintasan baru tanpa relog, kirim sinyal SIGUSR1 ke daemon sxhkd:
   ```bash
   pkill -USR1 -x sxhkd
   ```

---

## 4. Setup Terminal (Alacritty)
Alacritty adalah terminal emulator berkecepatan tinggi yang dikonfigurasi dengan tema warna yang serasi dengan desktop Anda.

### Langkah-langkah:
1. Pasang Alacritty:
   ```bash
   sudo pacman -S alacritty
   ```
2. Salin file konfigurasinya:
   ```bash
   mkdir -p ~/.config/alacritty
   cp config/alacritty/alacritty.toml ~/.config/alacritty/
   ```

---

## 5. Setup SDDM & Theme (Display Manager)
SDDM bertugas sebagai layar login saat pertama kali boot. Anda menggunakan tema kustom **pixel-night-city** yang menggunakan background MP4 interaktif.

### Langkah-langkah:
1. Pasang SDDM di Arch Linux:
   ```bash
   sudo pacman -S sddm
   ```
2. Salin folder tema kustom ke direktori sistem SDDM:
   ```bash
   sudo mkdir -p /usr/share/sddm/themes
   sudo cp -r sddm/themes/pixel-night-city /usr/share/sddm/themes/
   ```
3. Salin file konfigurasi utama SDDM agar menggunakan tema tersebut:
   ```bash
   sudo cp sddm/sddm.conf /etc/sddm.conf
   ```
4. Aktifkan service SDDM pada systemd agar berjalan saat boot:
   ```bash
   sudo systemctl enable sddm.service
   ```

---

## 6. Setup GRUB & Theme (Bootloader)
GRUB mengontrol menu booting Anda. Anda menggunakan tema **astronaut-catppucin-1.02**.

### Langkah-langkah:
1. Salin folder tema GRUB ke `/boot/grub/themes/`:
   ```bash
   sudo mkdir -p /boot/grub/themes
   sudo cp -r grub/themes/astronaut-catppucin-1.02 /boot/grub/themes/
   ```
2. Salin konfigurasi GRUB bawaan yang mengarah ke tema tersebut:
   ```bash
   sudo cp grub/grub /etc/default/grub
   ```
3. Update file GRUB bootloader:
   ```bash
   sudo grub-mkconfig -o /boot/grub/grub.cfg
   ```

---

## 7. Konfigurasi Dual-Boot Windows 10
Untuk menambahkan pilihan booting ke Windows 10 pada menu GRUB, Anda dapat menggunakan script kustom yang sudah disediakan.

> [!WARNING]
> UUID partisi EFI Windows 10 pada instalasi baru mungkin akan berbeda dengan sistem lama. Anda wajib memperbarui UUID ini terlebih dahulu agar Windows dapat di-boot kembali.

### Langkah-langkah:
1. Temukan UUID dari partisi EFI Windows 10 Anda. Jalankan perintah ini di terminal:
   ```bash
   sudo blkid
   ```
   Cari partisi bertipe `vfat` (biasanya berukuran 100MB-260MB yang berisi EFI system partition) dan salin kode UUID-nya (contoh: `4E61-5688`).
   
2. Buka file konfigurasi kustom GRUB dari backup:
   [`grub/40_custom`](file:///home/dionovan/projects/portfolio/dotfiles/grub/40_custom)
   
3. Edit baris ke-7 pada UUID target dengan UUID baru yang Anda temukan:
   ```grub
   # Ganti "4E61-5688" dengan UUID EFI partisi Windows Anda saat ini
   search --no-floppy --fs-uuid --set=root 4E61-5688
   ```

4. Pasang file konfigurasi kustom tersebut ke direktori sistem GRUB:
   ```bash
   sudo cp grub/40_custom /etc/grub.d/40_custom
   sudo chmod +x /etc/grub.d/40_custom
   ```

5. Regenerasi ulang GRUB config agar menu Windows 10 muncul saat booting:
   ```bash
   sudo grub-mkconfig -o /boot/grub/grub.cfg
   ```
