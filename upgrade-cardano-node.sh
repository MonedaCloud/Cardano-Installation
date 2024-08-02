#!/bin/bash

### Cardano Node/Relay upgrade FROM source: 1 OF 2 ###
### Run first upgrade-genesis-files.sh script. ###
### Run second upgrade-cardano-node.sh script. ###

# Cardano Node Release:
CNODE_VERSION="8.9.4"

### DO NOT EDIT BELOW THS LINE. ###

# Patch OS - Optional
sudo apt update
sudo apt upgrade -y

# Stop Cardano node:
sudo systemctl stop cnode

# Backup
cp ~/.local/bin/cardano-cli ~/.local/bin/cardano-cli-pre
cp ~/.local/bin/cardano-node ~/.local/bin/cardano-node-pre

# Build Cardano node from source
cd ~/src
git clone https://github.com/input-output-hk/cardano-node.git cardano-node2
cd cardano-node2/
git fetch --all --recurse-submodules --tags
git checkout tags/$CNODE_VERSION

# Prepare compiler env
cabal update
cabal configure -O0 -w ghc-8.10.7
echo -e "package cardano-crypto-praos\n flags: -external-libsodium-vrf" >> cabal.project.local

# Build release command
# cabal build all
cabal build cardano-cli
cabal build cardano-node

mkdir -p ~/.local/bin
cp -p "$(./scripts/bin-path.sh cardano-node)" ~/.local/bin/
cp -p "$(./scripts/bin-path.sh cardano-cli)" ~/.local/bin/

# Clean up
cd ~/src
rm -rf cardano-node-old
mv cardano-node cardano-node-old
mv cardano-node2 cardano-node

cardano-cli --version
cardano-node --version

# Start Cardano node:
sudo systemctl start cnode

echo 'Run [ systemctl start cnode ] on the terminal to check the status of the Cardano node service.'
echo 'Run [ journalctl -fu cnode ] on the terminal to monitor for service errors.'
echo 'Run [ tail -F /opt/cardano/cnode/logs/node0.json ] to follow node logs (Only mainnet configuration).'

echo 'END'
