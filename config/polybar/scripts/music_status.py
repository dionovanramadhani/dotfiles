#!/usr/bin/env python3
import subprocess
import re

def get_active_player():
    try:
        out = subprocess.check_output([
            'dbus-send', '--print-reply', '--dest=org.freedesktop.DBus',
            '/org/freedesktop/DBus', 'org.freedesktop.DBus.ListNames'
        ], stderr=subprocess.DEVNULL).decode('utf-8')
        players = re.findall(r'org\.mpris\.MediaPlayer2\.[a-zA-Z0-9_.-]+', out)
        # Prioritize spotify
        for p in players:
            if 'spotify' in p:
                return p
        if players:
            return players[0]
    except Exception:
        pass
    return None

def get_metadata(player):
    try:
        # Get status
        status_out = subprocess.check_output([
            'dbus-send', '--print-reply', '--session', f'--dest={player}',
            '/org/freedesktop/MediaPlayer2', 'org.freedesktop.DBus.Properties.Get',
            'string:org.mpris.MediaPlayer2.Player', 'string:PlaybackStatus'
        ], stderr=subprocess.DEVNULL).decode('utf-8')
        status = 'Paused'
        if 'Playing' in status_out:
            status = 'Playing'
        elif 'Stopped' in status_out:
            status = 'Stopped'
            
        # Get metadata
        meta_out = subprocess.check_output([
            'dbus-send', '--print-reply', '--session', f'--dest={player}',
            '/org/freedesktop/MediaPlayer2', 'org.freedesktop.DBus.Properties.Get',
            'string:org.mpris.MediaPlayer2.Player', 'string:Metadata'
        ], stderr=subprocess.DEVNULL).decode('utf-8')
        
        # Parse artist and title using regex
        title_match = re.search(r'string\s+"xesam:title"\s*\n\s*variant\s+string\s+"([^"]+)"', meta_out)
        title = title_match.group(1) if title_match else ""
        
        # Artist
        artist_match = re.search(r'string\s+"xesam:artist"\s*\n\s*variant\s+array\s+\[\s*\n?\s*string\s+"([^"]+)"', meta_out)
        artist = artist_match.group(1) if artist_match else ""
        if not artist:
            artist_match = re.search(r'string\s+"xesam:artist"\s*\n\s*variant\s+string\s+"([^"]+)"', meta_out)
            artist = artist_match.group(1) if artist_match else ""
        
        return status, artist, title
    except Exception:
        return None, "", ""

def main():
    player = get_active_player()
    if not player:
        print("")
        return
        
    status, artist, title = get_metadata(player)
    if not status or status == 'Stopped':
        print("")
        return
        
    icon = "󰎆" # Music icon
    if status == 'Playing':
        icon = "󰎆"
    else:
        icon = "󰏤" # Pause icon
        
    if artist and title:
        text = f"{artist} - {title}"
    elif title:
        text = title
    else:
        text = "Unknown"
        
    # Truncate if too long
    max_len = 25
    if len(text) > max_len:
        text = text[:max_len-3] + "..."
        
    print(f"{icon} {text}")

if __name__ == '__main__':
    main()
