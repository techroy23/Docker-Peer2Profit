FROM bitnami/minideb:bookworm
ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'keyboard-configuration keyboard-configuration/layoutcode select us' | debconf-set-selections
RUN apt-get update -y && apt-get upgrade -y
RUN install_packages xvfb gdebi util-linux iproute2 net-tools curl wget nano gnupg htop util-linux uuid-runtime libxcb-icccm4

RUN wget --no-check-certificate -O /tmp/peer2profit.deb https://updates.peer2profit.app/peer2profit_0.48_amd64.deb && \
    gdebi --n /tmp/peer2profit.deb && \
    rm /tmp/peer2profit.deb

RUN mkdir -p /root/.config

COPY entrypoint.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/entrypoint.sh

CMD ["/usr/local/bin/entrypoint.sh"]
