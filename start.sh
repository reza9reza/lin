#!/bin/bash

rm -f /tmp/.X0-lock /tmp/.X11-unix/X0

echo "[1/6] Starting Xvfb..."
Xvfb :0 -screen 0 1280x720x24 -ac +extension RANDR &
sleep 2

echo "[2/6] Creating Openbox Menu..."
mkdir -p /root/.config/openbox
cat << 'EOF' > /root/.config/openbox/menu.xml
<?xml version="1.0" encoding="UTF-8"?>
<openbox_menu>
<menu id="root-menu" label="Openbox">
  <item label="Terminal"><action name="Execute"><execute>xterm -bg black -fg white</execute></action></item>
  <item label="Firefox"><action name="Execute"><execute>firefox-esr</execute></action></item>
  <separator />
  <item label="Exit"><action name="Exit"/></item>
</menu>
</openbox_menu>
EOF

echo "[3/6] Starting Openbox..."
DISPLAY=:0 openbox-session &
sleep 1

echo "[4/6] Setting Background..."
DISPLAY=:0 xsetroot -solid grey &

echo "[5/6] Starting xterm..."
DISPLAY=:0 xterm -bg black -fg white &

echo "[6/6] Starting x11vnc & websockify..."
x11vnc -display :0 -forever -nopw -rfbport 5900 -bg -o /var/log/x11vnc.log
sleep 2
exec websockify --web=/usr/share/novnc/ 0.0.0.0:${PORT:-8080} localhost:5900 --heartbeat=30
