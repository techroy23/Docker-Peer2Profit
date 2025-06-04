FROM ghcr.io/techroy23/docker-slimvnc:latest

RUN apt-get update -y
RUN apt-get install net-tools uuid-runtime libxcb-glx0 libx11-xcb1 libxcb-icccm4 libxcb-image0 libxcb-shm0 libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 libxcb-sync1 libxcb-xfixes0 libxcb-render0 libxcb-shape0 libxcb-xinerama0 libxcb-xkb1 libxcb1 libx11-6 libxkbcommon-x11-0  libxkbcommon0  libgl1 libxcb-util1 libxau6 libxdmcp6 libbsd0 -y

COPY peer2profit_0.48_amd64.deb /tmp/peer2profit_0.48_amd64.deb
RUN gdebi --n /tmp/peer2profit_0.48_amd64.deb
RUN rm /tmp/peer2profit_0.48_amd64.deb

# Clean up unnecessary packages and cache to reduce image size
RUN apt-get autoclean && apt-get autoremove -y && apt-get autopurge -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy your new entrypoint
COPY custom-entrypoint.sh /custom-entrypoint.sh
RUN chmod +x /custom-entrypoint.sh
