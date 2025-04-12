#!/bin/bash

echo " "
echo "Starting container initialization..."

if [ -z "$P2P_EMAIL" ]; then
  echo " "
  echo "P2P_EMAIL is not set or is blank. Skipping creation of the Peer2Profit configuration file."
else
  FLAG_FILE="/root/.config/org.peer2profit.setup_done"

  if [ -f "$FLAG_FILE" ]; then
    echo " "
    echo "Peer2Profit configuration file has already been created. Skipping."
  else
    INSTALL_ID2=$(uuidgen)
    CONFIG_FILE="/root/.config/org.peer2profit.peer2profit.ini"
    CONFIG_DIR=$(dirname "$CONFIG_FILE")
    mkdir -p "$CONFIG_DIR"
    cat <<EOF > "$CONFIG_FILE"
[General]
Username=$P2P_EMAIL
hideToTrayMsg=true
installid2=$INSTALL_ID2
locale=en_US
EOF

    chown -R "root:root" "$CONFIG_DIR"

    # Create the flag file to mark the script as completed
    touch "$FLAG_FILE"
	echo " "
    echo "Peer2Profit configuration file created successfully at $CONFIG_FILE."
  fi
fi

echo "Staring Peer2Profit..."
xvfb-run peer2profit
