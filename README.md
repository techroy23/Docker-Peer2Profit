# Docker-Peer2Profit

## Overview
This repository provides a containerized environment for running the **Peer2Profit application** inside a lightweight Debian‑based image.  
The setup includes, headless X11 stack with **Xvfb**, **Openbox**, **x11vnc**, and **noVNC**, allowing remote access through both VNC and a browser.  

The container also integrates:
- Automated **DBus** system/session bus initialization
- This design enables reproducible, isolated execution of the Wipter client with minimal host dependencies.

## Features
- **Debian Trixie Slim Base**  
  - Lightweight, up‑to‑date foundation with only required packages installed.

- **Headless GUI Stack**  
  - `Xvfb` virtual framebuffer for X11 rendering  
  - `openbox` as a minimal window manager  
  - `x11vnc` for VNC access  
  - `noVNC` + `websockify` for browser‑based access

- **Custom System Identity Simulation**  
  - `custom.sh` dynamically generates randomized host metadata (hostname, machine ID, vendor/model, firmware version/date)  
  - Overrides `lsb_release` and `hostnamectl` outputs for consistency

- **DBus & Keyring Integration**  
  - Automatic startup of system and session DBus daemons  

- **Automated Peer2Profit Login**  
  - `entrypoint.sh` launches the Peer2Profit client  
  - Automated Peer2Profit configuration with user-defined `P2P_EMAIL`.

## Features
- Lightweight Debian-based image (`ghcr.io/techroy23/docker-slimvnc:latest`).
- Automated installation of required dependencies.

## Run
```
docker run -d \
  --name=docker-peer2profit \
  --restart=always \
  --pull always \
  --shm-size=2gb \
  --privileged \
  -e P2P_EMAIL="YourEmail@here.com" \
  -e VNC_PORT=5900 \
  -e NOVNC_PORT=6080 \
  -p 5900:5900 -p 6080:6080 \
  techroy23/docker-peer2profit:latest
```

## Access
- VNC Client: localhost:5555
- Web Interface (noVNC): http://localhost:6666

## Promo
<ul><li><a href="https://t.me/peer2profit_app_bot?start=1628962882611800423c343"> [ REGISTER HERE ] </a></li></ul>
<div align="center">
  <a href="https://t.me/peer2profit_app_bot?start=1628962882611800423c343">
      <img width="50%" src="https://raw.githubusercontent.com/techroy23/Docker-Peer2Profit/refs/heads/main/screenshot/p2p-banner-960x640.png" alt="PROMO">
  </a>
</div>
