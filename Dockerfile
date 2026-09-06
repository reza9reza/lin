FROM alpine:latest

RUN apk add --no-cache \
    xvfb \
    openbox \
    x11vnc \
    xterm \
    dillo \
    novnc \
    websockify \
    bash \
    supervisor \
    font-misc-misc \
    terminus-font \
    ttf-dejavu \
    xsetroot \
    util-linux

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENV RESOLUTION=1280x720x24
ENV PORT=8080

EXPOSE 8080

CMD ["/start.sh"]
