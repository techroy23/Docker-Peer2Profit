FROM debian:trixie-slim

ARG TARGETARCH

WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates dos2unix bash curl wget gdebi git procps net-tools coreutils util-linux iproute2 scrot gnome-keyring libsecret-tools wmctrl xautomation uuid-runtime \
		dbus dbus-x11 openbox menu xterm xvfb x11vnc python3-numpy \
        xfonts-base xfonts-75dpi xfonts-100dpi xfonts-scalable \
		libxcb-glx0 libx11-xcb1 libxcb-icccm4 libxcb-image0 libxcb-shm0 libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 libxcb-sync1 libxcb-xfixes0 libxcb-render0 libxcb-shape0 libxcb-xinerama0 libxcb-xkb1 libxcb1 libx11-6 libxkbcommon-x11-0 libxkbcommon0 libgl1 libxcb-util1 libxau6 libxdmcp6 libbsd0 \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone --depth=1 https://github.com/novnc/noVNC /opt/noVNC \
    && git clone --depth=1 https://github.com/novnc/websockify /opt/noVNC/utils/websockify \
    && cp /opt/noVNC/vnc.html /opt/noVNC/index.html \
    && chmod +x /opt/noVNC/utils/novnc_proxy

COPY peer2profit_0.48_amd64.deb /tmp/peer2profit_0.48_amd64.deb

RUN gdebi --n /tmp/peer2profit_0.48_amd64.deb \
    && rm /tmp/peer2profit_0.48_amd64.deb

RUN printf '#!/bin/sh \n echo "%s"' "$(lsb_release -a)" > /usr/bin/lsb_release \
    && printf '#!/bin/sh \n echo "%s"' "$(hostnamectl)" > /usr/bin/hostnamectl

COPY entrypoint.sh /app/entrypoint.sh

COPY custom.sh /app/custom.sh

RUN dos2unix /app/entrypoint.sh /app/custom.sh \
    && chmod a+x /app/entrypoint.sh /app/custom.sh /usr/bin/hostnamectl /usr/bin/lsb_release

ENTRYPOINT ["/app/entrypoint.sh"]

CMD ["bash"]