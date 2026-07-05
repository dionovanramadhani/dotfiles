#!/usr/bin/env python3
import subprocess
import re
import json
import os
import sys
import time

LOG_FILE = os.path.expanduser("~/.cache/notification_history.json")

def load_history():
    if os.path.exists(LOG_FILE):
        try:
            with open(LOG_FILE, 'r') as f:
                return json.load(f)
        except Exception:
            pass
    return []

def save_history(history):
    # Limit history to the last 50 notifications
    history = history[-50:]
    try:
        # Create directory if it doesn't exist
        os.makedirs(os.path.dirname(LOG_FILE), exist_ok=True)
        with open(LOG_FILE, 'w') as f:
            json.dump(history, f, indent=2)
    except Exception as e:
        print(f"Error saving history: {e}", file=sys.stderr)

def main():
    # Start dbus-monitor to listen for notify calls
    cmd = ["dbus-monitor", "interface='org.freedesktop.Notifications',member='Notify'"]
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True)

    # We match:
    # app_name (string)
    # replaces_id (uint32)
    # app_icon (string)
    # summary (string)
    # body (string)
    
    current_notification = {}
    state = 0  # 0: waiting, 1: app_name, 2: replaces_id, 3: icon, 4: summary, 5: body
    
    for line in proc.stdout:
        line = line.strip()
        if "member=Notify" in line:
            current_notification = {}
            state = 1
            continue
            
        if state == 1:
            m = re.match(r'^string\s+"(.*)"$', line)
            if m:
                current_notification['app_name'] = m.group(1)
                state = 2
        elif state == 2:
            m = re.match(r'^uint32\s+(\d+)$', line)
            if m:
                state = 3
        elif state == 3:
            m = re.match(r'^string\s+"(.*)"$', line)
            if m:
                current_notification['icon'] = m.group(1)
                state = 4
        elif state == 4:
            m = re.match(r'^string\s+"(.*)"$', line)
            if m:
                current_notification['summary'] = m.group(1)
                state = 5
        elif state == 5:
            m = re.match(r'^string\s+"(.*)"$', line)
            if m:
                current_notification['body'] = m.group(1)
                
                # Append notification with timestamp
                current_notification['timestamp'] = int(time.time())
                current_notification['unread'] = True
                
                history = load_history()
                history.append(current_notification)
                save_history(history)
                
                state = 0

if __name__ == "__main__":
    main()
