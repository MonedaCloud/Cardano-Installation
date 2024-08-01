#!/bin/bash

### Cardano Node/Relay upgrade FROM binaries: 1 OF 2 ###
### Run first upgrade-genesis-files.sh script. ###
### Run second upgrade-cardano-node.sh script. ###

# Cardano Node Release:
CNODE_VERSION="8.9.4"

# Binary source:
BINARY="https://github.com/IntersectMBO/cardano-node/releases/download/$CNODE_VERSION/cardano-node-$CNODE_VERSION-linux.tar.gz"

### DO NOT EDIT BELOW THS LINE. ###

# Patch OS - Optional
sudo apt update
sudo apt upgrade -y

# Backup
cp ~/.local/bin/cardano-cli ~/.local/bin/cardano-cli-pre
cp ~/.local/bin/cardano-node ~/.local/bin/cardano-node-pre

# Download Cardano Node release from GitHub:
mkdir -p ~/src
cd ~/src
rm -rf cardano-node-*
wget $BINARY
tar -xvzf cardano-node*.tar.gz -C cardano-node2

# Deploy Cardano Node binaries into local bin directory:
mkdir -p ~/.local/bin
cp  ./cardano-node2/bin/* ~/.local/bin/
echo 'export PATH="$HOME/.local/bin/:$PATH"' >> ~/.bashrc
export PATH="$HOME/.local/bin/:$PATH"
. "${HOME}/.bashrc"

# Clean up
cd ~/src
rm -rf cardano-node-old

mv cardano-node cardano-node-old
mv cardano-node2 cardano-node

cardano-cli --version
cardano-node --version

sudo systemctl restart cnode

echo 'END'
