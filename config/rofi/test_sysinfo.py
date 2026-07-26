#!/usr/bin/env python3
import os
import socket
import time
import subprocess

def get_cpu_pct():
    with open("/proc/stat", "r") as f:
        line = f.readline()
    parts = line.split()
    idle1 = float(parts[4])
    total1 = sum(float(x) for x in parts[1:])
    time.sleep(0.1)
    with open("/proc/stat", "r") as f:
        line = f.readline()
    parts = line.split()
    idle2 = float(parts[4])
    total2 = sum(float(x) for x in parts[1:])
    return int(100 * (1 - (idle2 - idle1) / (total2 - total1)))

def get_ram_pct():
    with open("/proc/meminfo", "r") as f:
        lines = f.readlines()
    mem_total = 0
    mem_available = 0
    for line in lines:
        if line.startswith("MemTotal:"):
            mem_total = int(line.split()[1])
        elif line.startswith("MemAvailable:"):
            mem_available = int(line.split()[1])
    if mem_total > 0:
        return int((mem_total - mem_available) * 100 / mem_total)
    return 0

def get_uptime():
    with open("/proc/uptime", "r") as f:
        uptime_seconds = float(f.readline().split()[0])
    hours = int(uptime_seconds // 3600)
    minutes = int((uptime_seconds % 3600) // 60)
    if hours > 0:
        return f"{hours} hrs, {minutes} mins"
    return f"{minutes} mins"

def get_disk_usage():
    out = subprocess.check_output(["df", "-h", "/"]).decode("utf-8")
    lines = out.strip().split("\n")
    if len(lines) > 1:
        return f"{lines[1].split()[2]} used"
    return "unknown"

def get_packages():
    try:
        out = subprocess.check_output("pacman -Q | wc -l", shell=True)
        return out.decode("utf-8").strip()
    except:
        return "unknown"

width = 42

logo_marked = [
    f"    <span foreground='#83a598'>.</span>    ",
    f"   <span foreground='#83a598'>/ \\</span>   ",
    f"  <span foreground='#83a598'>/</span>   <span foreground='#d3869b'>\\</span>  ",
    f" <span foreground='#83a598'>/^</span>   <span foreground='#d3869b'>^\\</span> ",
    f"<span foreground='#83a598'>/ (</span>   <span foreground='#d3869b'>) \\</span>",
    f"<span foreground='#83a598'>/  ~</span> <span foreground='#d3869b'>~  \\</span>",
    f"<span foreground='#83a598'>/.^</span>   <span foreground='#d3869b'>^.\\</span>"
]

lines = []
for line in logo_marked:
    margin = (width - 9) // 2
    lines.append(" " * margin + line)

lines.append("")

margin_colors = (width - 23) // 2
colors_line = (
    '<span foreground="#504945">■■</span> '
    '<span foreground="#fb4934">■■</span> '
    '<span foreground="#b8bb26">■■</span> '
    '<span foreground="#fabd2f">■■</span> '
    '<span foreground="#83a598">■■</span> '
    '<span foreground="#d3869b">■■</span> '
    '<span foreground="#8ec07c">■■</span> '
    '<span foreground="#ebdbb2">■■</span>'
)
lines.append(" " * margin_colors + colors_line)

lines.append("")

username = os.getlogin()
hostname = socket.gethostname()
uptime_str = get_uptime()

g1 = f"hola <span foreground='#fb4934'><b>{username}</b></span>"
g1_len = 5 + len(username)
lines.append(" " * ((width - g1_len) // 2) + g1)

g2 = f"Bienvenido a <span foreground='#8ec07c'><b>{hostname}</b></span>"
g2_len = 13 + len(hostname)
lines.append(" " * ((width - g2_len) // 2) + g2)

g3 = f"up <span foreground='#83a598'><b>{uptime_str}</b></span>"
g3_len = 3 + len(uptime_str)
lines.append(" " * ((width - g3_len) // 2) + g3)

lines.append("")

specs = [
    ("distro", "#fb4934", "Arch Linux"),
    ("kernel", "#83a598", subprocess.check_output(["uname", "-r"]).decode("utf-8").strip()),
    ("packages", "#d3869b", get_packages()),
    ("shell", "#b8bb26", os.path.basename(os.environ.get("SHELL", "zsh"))),
    ("term", "#fabd2f", "alacritty"),
    ("wm", "#8ec07c", "bspwm"),
    ("disk", "#83a598", get_disk_usage())
]

max_spec_len = 0
for key, color, val in specs:
    raw_line_len = 8 + 3 + len(val)
    if raw_line_len > max_spec_len:
        max_spec_len = raw_line_len

margin_specs = (width - max_spec_len) // 2

for key, color, val in specs:
    key_padded = key.rjust(8)
    icon = f"<span foreground='{color}'>■</span>"
    line = f"<span foreground='{color}'>{key_padded}</span> {icon} {val}"
    lines.append(" " * margin_specs + line)

lines.append("")

cpu_pct = get_cpu_pct()
ram_pct = get_ram_pct()

def make_bar(pct, name, bar_color):
    active = int(pct * 18 / 100)
    inactive = 18 - active
    bar = f"<span foreground='{bar_color}'>{'█' * active}</span><span foreground='#3c3836'>{'█' * inactive}</span>"
    total_len = 26 + len(str(pct))
    margin = (width - total_len) // 2
    return " " * margin + f"<span foreground='#d3869b'>{name}</span> <span foreground='#fb4934'>{pct}%</span>  {bar}"

lines.append(make_bar(cpu_pct, "cpu", "#fb4934"))
lines.append(make_bar(ram_pct, "ram", "#83a598"))

message_text = "\n".join(lines)

subprocess.run([
    "rofi",
    "-markup",
    "-e", message_text,
    "-theme", "/home/dionovan/.config/rofi/config.rasi",
    "-theme-str", """
        window {
            width: 360px;
            border: 0px;
            border-radius: 0px;
            padding: 30px 20px;
            background-color: @background;
        }
        mainbox {
            children: [ message ];
            background-color: transparent;
        }
        message {
            border: 0px;
            padding: 0px;
            background-color: transparent;
        }
        textbox {
            text-color: @foreground;
            background-color: transparent;
            font: "JetBrainsMono Nerd Font Bold 10";
        }
    """
])
