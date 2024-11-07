#!/bin/bash

### Cardano Node/Relay upgrade FROM binaries: 1 OF 2 ###
### Run first upgrade-genesis-files.sh script. ###
### Run second upgrade-cardano-node.sh script. ###

# Cardano Node Release:
CNODE_VERSION="10.1.1"

# Binary source:
BINARY="https://github.com/IntersectMBO/cardano-node/releases/download/$CNODE_VERSION/cardano-node-$CNODE_VERSION-linux.tar.gz"

### DO NOT EDIT BELOW THS LINE. ###

# Patch OS - Optional
sudo apt update
sudo apt upgrade -y

# Stop Cardano node:
sudo systemctl stop cnode

# Backup
cp ~/.local/bin/cardano-cli ~/.local/bin/cardano-cli-pre
cp ~/.local/bin/cardano-node ~/.local/bin/cardano-node-pre

# Download Cardano Node release from GitHub:
mkdir -p ~/src
cd ~/src
rm -rf cardano-node-*
rm -rf bin
rm -rf share
wget $BINARY
tar -xvzf cardano-node*.tar.gz

# Deploy Cardano Node binaries into local bin directory:
mkdir -p ~/.local/bin
cp  ./bin/* ~/.local/bin/
echo 'export PATH="$HOME/.local/bin/:$PATH"' >> ~/.bashrc
export PATH="$HOME/.local/bin/:$PATH"
. "${HOME}/.bashrc"

cardano-cli --version
cardano-node --version

# Start Cardano node:
sudo systemctl start cnode

echo 'Run [ systemctl status cnode ] on the terminal to check the status of the Cardano node service.'
echo 'Run [ journalctl -fu cnode ] on the terminal to monitor for service errors.'
echo 'Run [ tail -F /opt/cardano/cnode/logs/node0.json ] to follow node logs (Only mainnet configuration).'

echo 'END'
