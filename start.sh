#!/bin/bash

rm -f /tmp/.X0-lock /tmp/.X11-unix/X0

echo "[1/5] Starting Xvfb..."
Xvfb :0 -screen 0 1280x720x24 -ac +extension RANDR &
sleep 2

echo "[2/5] Starting Openbox..."
DISPLAY=:0 openbox &
sleep 1

echo "[3/5] Starting xterm (Terminal)..."
# باز کردن یک ترمینال با پس‌زمینه مشکی و متن سفید
DISPLAY=:0 xterm -bg black -fg white &

echo "[4/5] Starting x11vnc..."
x11vnc -display :0 -forever -nopw -rfbport 5900 -bg -o /var/log/x11vnc.log
sleep 2

echo "[5/5] Starting websockify..."
exec websockify --web=/usr/share/novnc/ 0.0.0.0:${PORT:-8080} localhost:5900 --heartbeat=30
