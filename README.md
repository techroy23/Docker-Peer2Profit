# Docker-Peer2Profit

## Overview
This repository provides a Dockerized solution for running Peer2Profit. The setup uses `ghcr.io/techroy23/docker-slimvnc:latest` as base image to ensure minimal system overhead and integrates all necessary dependencies for seamless operation.

## Features
- Lightweight Debian-based image (`ghcr.io/techroy23/docker-slimvnc:latest`).
- Automated installation of required dependencies.
- Automated Peer2Profit configuration with user-defined `P2P_EMAIL`.
- VNC password can be set via `VNC_PASS`.

## Run
```bash

docker run -d --name docker-peer2profit \
  -e VNC_PASS="your_secure_password" \
  -e P2P_EMAIL="YourEmail@here.com" \
  -e VNC_PORT=5555 \
  -e NOVNC_PORT=6666 \
  -p 5555:5555 -p 6666:6666 \
  --shm-size=2gb \
  ghcr.io/techroy23/docker-peer2profit:latest

```

## Access
- VNC Client: localhost:5901
- Web Interface (noVNC): http://localhost:6080

## Promo
<ul><li><a href="https://t.me/peer2profit_app_bot?start=1628962882611800423c343"> [ REGISTER HERE ] </a></li></ul>
<div align="center">
  <a href="https://t.me/peer2profit_app_bot?start=1628962882611800423c343">
      <img src="screenshot/p2p-banner-960x640.png" alt="Alt text">
  </a>
</div>
