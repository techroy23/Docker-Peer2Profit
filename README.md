# Docker-Peer2Profit

## Overview
This repository provides a Dockerized solution for running Peer2Profit, allowing users to share bandwidth and earn passive income securely and efficiently. The setup uses Bitnami's `ghcr.io/techroy23/docker-slimvnc:latest` base image to ensure minimal system overhead and integrates all necessary dependencies for seamless operation.

## Features
- Lightweight Debian-based image (`ghcr.io/techroy23/docker-slimvnc:latest`).
- Automated installation of required dependencies.
- Automated Peer2Profit configuration with user-defined `P2P_EMAIL`.
- VNC password can be set via `VNC_PASS`
- Streamlined Peer2Profit configuration with a custom entrypoint.
- Optimized with essential tools and libraries for robustness.

## Run
```

docker run -d --name docker-slimvnc \
  -e VNC_PASS="your_secure_password" \
  -p 5901:5901 -p 6080:6080 \
  --shm-size=2gb \
  ghcr.io/techroy23/docker-peer2profit:latest

```

## Access
- VNC Client: localhost:5901
- Web Interface (noVNC): http://localhost:6080
