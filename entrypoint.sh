#!/bin/bash

set -e
mkdir -p /tmp/runtime-root
mkdir -p /run/dbus
export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/run/dbus/system_bus_socket
export XDG_RUNTIME_DIR=/tmp/runtime-root
export NO_AT_BRIDGE=1
export DISPLAY=:0
export VNC_DISPLAY=":0"
DISPLAY=:0
VNC_DISPLAY=":0"

# Allow override of ports via env vars, with fallback check
pick_port() {
    local port="$1"
    local attempts=0
    while [ $attempts -lt 2 ]; do
        if ! lsof -iTCP:"$port" -sTCP:LISTEN >/dev/null 2>&1; then
            echo "$port"
            return
        fi
        port=$((port + 1))
        attempts=$((attempts + 1))
    done
    echo "$port"
}
VNC_PORT=$(pick_port "${VNC_PORT:-5910}")
NOVNC_PORT=$(pick_port "${NOVNC_PORT:-6080}")

if [ -z "${P2P_EMAIL:-}" ]; then
    echo " >>> An2Kin >>> [ERR] P2P_EMAIL is not set."
    exit 1
fi

echo " >>> An2Kin >>> Modifying lsb_release / hostnamectl"
sh /app/custom.sh 
/usr/bin/lsb_release
/usr/bin/hostnamectl

RAND_NUM=$(awk 'BEGIN { srand(); printf "%04d\n", int(1000 + rand()*9000) }')
HOSTNAME="PC-$RAND_NUM"
if hostname "$HOSTNAME" && echo "$HOSTNAME" > /etc/hostname; then
    echo " >>> An2Kin >>> [INFO] Hostname successfully set to: $HOSTNAME"
else
    echo " >>> An2Kin >>> [ERR] Failed to set hostname to: $HOSTNAME"
    echo " >>> An2Kin >>> [ERR] Please check permissions or container capabilities."
fi

echo " >>> An2Kin >>> [RUN] update-ca-certificates"
update-ca-certificates
sleep 2

echo " >>> An2Kin >>> [RUN] dbus-uuidgen > /etc/machine-id"
dbus-uuidgen > /etc/machine-id
sleep 2

echo " >>> An2Kin >>> [RUN] dbus-daemon --system --fork"
dbus-daemon --system --fork
sleep 2

echo " >>> An2Kin >>> [RUN] dbus-daemon --session --fork --print-address --print-pid"
dbus_output=$(dbus-daemon --session --fork --print-address --print-pid)
DBUS_SESSION_BUS_ADDRESS=$(echo "$dbus_output" | head -n1)
DBUS_SESSION_BUS_PID=$(echo "$dbus_output" | tail -n1)
export DBUS_SESSION_BUS_ADDRESS
export DBUS_SESSION_BUS_PID
sleep 2

max_attempts=999
attempt=0
while [ $attempt -lt $max_attempts ]; do
    new_display_num=$(shuf -i 100-10000 -n 1)
    export DISPLAY=":$new_display_num"
    export VNC_DISPLAY=":$new_display_num"
    DISPLAY=":$new_display_num"
    VNC_DISPLAY=":$new_display_num"
    Xvfb $DISPLAY -screen 0 1280x800x24 &
    if pgrep -x Xvfb > /dev/null; then
        echo " >>> An2Kin >>> [RUN] Xvfb $DISPLAY -screen 0 1280x800x24"
        break
    else
        if [ $attempt -lt $((max_attempts - 1)) ]; then
            new_display_num=$(shuf -i 100-1000 -n 1)
            export DISPLAY=":$new_display_num"
            export VNC_DISPLAY=":$new_display_num"
            DISPLAY=":$new_display_num"
            VNC_DISPLAY=":$new_display_num"
        else
            echo "ERROR: Xvfb failed to start ..."
            exit 255
        fi
    fi
    attempt=$((attempt+1))
done
sleep 2

echo " >>> An2Kin >>> [RUN] openbox"
openbox &
sleep 2

echo " >>> An2Kin >>> [RUN] gnome-keyring-daemon --start --components=secrets"
gnome-keyring-daemon --start --components=secrets
sleep 2

echo " >>> An2Kin >>> [RUN] $WIPTER_PASSWORD | gnome-keyring-daemon --unlock --replace"
echo "$WIPTER_PASSWORD" | gnome-keyring-daemon --unlock --replace
sleep 2

echo " >>> An2Kin >>> [RUN] x11vnc -display $DISPLAY -rfbport $VNC_PORT -forever -shared -nopw -quiet"
x11vnc -display $DISPLAY -rfbport $VNC_PORT -forever -shared -nopw -quiet &
sleep 2

echo " >>> An2Kin >>> [RUN] /opt/noVNC/utils/novnc_proxy --vnc 0.0.0.0:$VNC_PORT --listen 0.0.0.0:$NOVNC_PORT"
/opt/noVNC/utils/novnc_proxy --vnc 0.0.0.0:$VNC_PORT --listen 0.0.0.0:$NOVNC_PORT &
sleep 2

setup_peer2profit() {
  CONFIG_FILE="/root/.config/org.peer2profit.peer2profit.ini"
  FLAG_FILE="/root/.config/org.peer2profit.setup_done"

  if [ -z "$P2P_EMAIL" ]; then
    echo " "
    echo " >>> An2Kin >>> [WARN] P2P_EMAIL is not set or is blank — skipping Peer2Profit configuration."
    echo " "
    return 0
  fi

  if [ -f "$FLAG_FILE" ]; then
    echo " "
    echo " >>> An2Kin >>> [INFO] Peer2Profit configuration already exists — skipping setup."
    echo " "
    return 0
  fi

  echo " "
  echo " >>> An2Kin >>> [INFO] Creating Peer2Profit configuration at $CONFIG_FILE..."
  echo " "
  mkdir -p "$(dirname "$CONFIG_FILE")"

  cat <<EOF > "$CONFIG_FILE"
[General]
Username=$P2P_EMAIL
hideToTrayMsg=false
installid2=$(uuidgen)
locale=en_US
EOF

  chown -R "root:root" "$(dirname "$CONFIG_FILE")"
  touch "$FLAG_FILE"
  
  echo " "
  echo " >>> An2Kin >>> [INFO] Peer2Profit configuration created successfully."
  echo " "
}

check_peer2profit() {
    while true; do
        if pgrep -x "peer2profit" > /dev/null; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') - peer2profit is running"
        else
            echo "$(date '+%Y-%m-%d %H:%M:%S') - peer2profit is NOT running, restarting..."
            /usr/bin/peer2profit &
        fi
        sleep 300
    done
}

echo " >>> An2Kin >>> [INFO] Starting Peer2Profit service..."
setup_peer2profit
/usr/bin/peer2profit &
check_peer2profit &
tail -f /dev/null