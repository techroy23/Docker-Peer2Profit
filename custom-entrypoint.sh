#!/bin/bash
set -e

echo "Executing custom entrypoint ..."

setup_peer2profit() {
  CONFIG_FILE="/root/.config/org.peer2profit.peer2profit.ini"
  FLAG_FILE="/root/.config/org.peer2profit.setup_done"

  if [ -z "$P2P_EMAIL" ]; then
    echo "P2P_EMAIL is not set or is blank. Skipping creation of the Peer2Profit configuration file."
  fi

  if [ -f "$FLAG_FILE" ]; then
    echo "Configuration already exists. Skipping."
    return 0
  fi

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

  echo "Configuration created successfully at $CONFIG_FILE."
}

echo " Starting Peer2Profit ..."
setup_peer2profit
/usr/bin/peer2profit &

echo "### ### ###"
echo " netstat "
echo "### ### ###"

monitor_netstat() {
    while true; do
        echo " "
        echo " "
        netstat -antp | awk 'NR==2 || /ESTABLISHED/'
        echo " "
        echo " "
        sleep 300
    done
}

monitor_netstat &
bg_pid=$!

sleep 5
echo "Monitoring started in the background. PID: $bg_pid"
