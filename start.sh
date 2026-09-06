#!/bin/bash

# ۱. پاک کردن فایل‌های قفل برای جلوگیری از خطا
rm -f /tmp/.X0-lock /tmp/.X11-unix/X0

echo "[1/4] Starting Xvfb (Virtual Screen)..."
Xvfb :0 -screen 0 1280x720x24 -ac +extension RANDR &
sleep 2

echo "[2/4] Starting Openbox (Desktop UI)..."
DISPLAY=:0 openbox-session &
sleep 1

echo "[3/4] Starting x11vnc (VNC Server)..."
# اجرای VNC کاملاً در پس‌زمینه و ذخیره لاگ‌های آن در یک فایل
x11vnc -display :0 -forever -nopw -rfbport 5900 -bg -o /var/log/x11vnc.log
sleep 2

echo "[4/4] Starting websockify (noVNC Web Server) on port $PORT..."
# اجرای وب‌سوکت در پیش‌زمینه با قابلیت heartbeat برای جلوگیری از قطعی Railway
exec websockify --web=/usr/share/novnc/ 0.0.0.0:${PORT:-8080} localhost:5900 --heartbeat=30
