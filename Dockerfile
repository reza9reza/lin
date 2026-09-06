# استفاده از سبک‌ترین ایمیج پایه
FROM alpine:latest

# نصب پکیج‌های مورد نیاز: X11 (گرافیک پایه)، Openbox (محیط دسکتاپ سبک)، 
# x11vnc (سرور VNC)، novnc و websockify (برای اتصال تحت وب)
RUN apk add --no-cache \
    xvfb \
    openbox \
    x11vnc \
    xterm \
    firefox-esr \
    novnc \
    websockify \
    font-misc-misc \
    terminus-font \
    bash \
    supervisor

# کپی کردن اسکریپت راه‌انداز به داخل کانتینر
COPY start.sh /start.sh
RUN chmod +x /start.sh

# متغیرهای محیطی پیش‌فرض
ENV RESOLUTION=1280x720x24
ENV PORT=8080

# باز کردن پورتی که Railway از آن استفاده می‌کند
EXPOSE 8080

# اجرای اسکریپت راه‌انداز
CMD ["/start.sh"]
