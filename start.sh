#!/bin/bash

# پاک کردن فایل‌های قفل احتمالی برای جلوگیری از خطای اجرای مجدد
rm -f /tmp/.X0-lock
rm -f /tmp/.X11-unix/X0

echo "[1/4] Starting Virtual Framebuffer (Xvfb)..."
Xvfb :0 -screen 0 $RESOLUTION &

# صبر تا Xvfb آماده شود
sleep 2 

echo "[2/4] Starting Openbox (Window Manager)..."
DISPLAY=:0 openbox &

echo "[3/4] Starting x11vnc Server..."
# اجرای VNC روی پورت 5900 بدون نیاز به پسورد (برای سادگی)
x11vnc -display :0 -forever -nopw -rfbport 5900 &

# صبر تا VNC آماده شود
sleep 2

echo "[4/4] Starting noVNC Web Server on port $PORT..."
# اجرای وب‌سرور noVNC. Railway متغیر PORT را به صورت خودکار تزریق می‌کند.
# کانتینر noVNC به پورت 5900 (VNC) وصل می‌شود و آن را روی پورت وب ($PORT) سرو می‌کند.
websockify --web=/usr/share/novnc/ 0.0.0.0:$PORT localhost:5900
