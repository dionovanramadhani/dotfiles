#!/usr/bin/python3
import sys
import os
import subprocess
import warnings
warnings.filterwarnings("ignore")
import gi


gi.require_version('Gtk', '3.0')
gi.require_version('Gdk', '3.0')
from gi.repository import Gtk, Gdk, GdkPixbuf, GLib

class WallpaperWindow(Gtk.Window):
    def __init__(self, monitor_idx, geometry, image_path):
        super().__init__(type=Gtk.WindowType.TOPLEVEL)
        self.set_type_hint(Gdk.WindowTypeHint.DESKTOP)
        self.set_decorated(False)
        self.set_keep_below(True)
        self.set_accept_focus(False)
        self.set_skip_taskbar_hint(True)
        self.set_skip_pager_hint(True)

        # Move to the correct monitor position and resize
        self.move(geometry.x, geometry.y)
        self.resize(geometry.width, geometry.height)

        # Load and scale the image to cover this monitor
        self.pixbuf = self.load_cover_image(image_path, geometry.width, geometry.height)

        # Connect drawing area
        self.drawing_area = Gtk.DrawingArea()
        self.drawing_area.connect('draw', self.on_draw)
        self.add(self.drawing_area)

    def load_cover_image(self, path, mw, mh):
        try:
            # Load original image metadata/size
            pixbuf = GdkPixbuf.Pixbuf.new_from_file(path)
            iw = pixbuf.get_width()
            ih = pixbuf.get_height()

            # Calculate scale to cover (CSS background-size: cover)
            r = max(mw / iw, mh / ih)
            sw = int(iw * r)
            sh = int(ih * r)

            # Scale the image
            scaled = pixbuf.scale_simple(sw, sh, GdkPixbuf.InterpType.BILINEAR)

            # Crop from the center
            cx = max(0, (sw - mw) // 2)
            cy = max(0, (sh - mh) // 2)

            # Safeguard boundary constraints
            if cx + mw > sw:
                cx = sw - mw
            if cy + mh > sh:
                cy = sh - mh

            cropped = GdkPixbuf.Pixbuf.new_subpixbuf(scaled, cx, cy, mw, mh)
            return cropped
        except Exception as e:
            print(f"Error loading image {path} for monitor {mw}x{mh}: {e}", file=sys.stderr)
            return None

    def on_draw(self, widget, cr):
        if self.pixbuf:
            Gdk.cairo_set_source_pixbuf(cr, self.pixbuf, 0, 0)
            cr.paint()
        return False

class WallpaperFader:
    def __init__(self, image_path):
        self.image_path = image_path
        self.display = Gdk.Display.get_default()
        if not self.display:
            print("Error: Could not open default Gdk Display.", file=sys.stderr)
            sys.exit(1)

        self.num_monitors = self.display.get_n_monitors()
        self.windows = []
        self.opacity = 0.0

        for i in range(self.num_monitors):
            monitor = self.display.get_monitor(i)
            geometry = monitor.get_geometry()
            win = WallpaperWindow(i, geometry, image_path)
            win.set_opacity(0.0)
            win.show_all()
            
            # Lower the window below other windows after showing it
            win.realize()
            gdk_win = win.get_window()
            if gdk_win:
                gdk_win.lower()
                
            self.windows.append(win)

        # Start the transition timer (runs every 16ms, approx 60fps)
        self.step_size = 0.05  # Fade speed (0.05 means 20 steps, ~320ms total)
        GLib.timeout_add(16, self.fade_step)

    def fade_step(self):
        self.opacity += self.step_size
        if self.opacity >= 1.0:
            for win in self.windows:
                win.set_opacity(1.0)
            
            # Apply wallpaper permanently via feh
            try:
                subprocess.run(['feh', '--bg-fill', self.image_path], check=True)
            except subprocess.CalledProcessError as e:
                print(f"Failed to set background using feh: {e}", file=sys.stderr)
            
            # Wait a brief moment to ensure X11 renders the root window background
            # before we destroy our overlay windows.
            GLib.timeout_add(80, self.cleanup)
            return False  # Stop the timer
        else:
            for win in self.windows:
                win.set_opacity(self.opacity)
            return True   # Continue the timer

    def cleanup(self):
        for win in self.windows:
            win.destroy()
        Gtk.main_quit()

def main():
    if len(sys.argv) < 2:
        print("Usage: change_wallpaper.py <path_to_image>", file=sys.stderr)
        sys.exit(1)

    image_path = os.path.abspath(sys.argv[1])
    if not os.path.isfile(image_path):
        print(f"Error: {image_path} is not a valid file.", file=sys.stderr)
        sys.exit(1)

    # Initialize Gtk and start fader
    Gtk.init(None)
    fader = WallpaperFader(image_path)
    Gtk.main()

if __name__ == '__main__':
    main()
