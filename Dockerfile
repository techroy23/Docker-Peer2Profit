FROM bitnami/minideb:bookworm
ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'keyboard-configuration keyboard-configuration/layoutcode select us' | debconf-set-selections
RUN apt-get update -y && apt-get upgrade -y

RUN install_packages xvfb xauth
RUN install_packages gdebi util-linux iproute2 net-tools curl wget nano gnupg htop util-linux uuid-runtime
RUN install_packages libxcb-glx0 libx11-xcb1 libxcb-icccm4 libxcb-image0 libxcb-shm0 libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 libxcb-sync1 libxcb-xfixes0 libxcb-render0 libxcb-shape0 libxcb-xinerama0 libxcb-xkb1 libxcb1 libx11-6 libxkbcommon-x11-0  libxkbcommon0  libgl1 libxcb-util1 libxau6 libxdmcp6 libbsd0

RUN wget --no-check-certificate -O /tmp/peer2profit.deb https://updates.peer2profit.app/peer2profit_0.48_amd64.deb && \
    gdebi --n /tmp/peer2profit.deb && \
    rm /tmp/peer2profit.deb

RUN mkdir -p /root/.config

COPY entrypoint.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/entrypoint.sh

CMD ["/usr/local/bin/entrypoint.sh"]
