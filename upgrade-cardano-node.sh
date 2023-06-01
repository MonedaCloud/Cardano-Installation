#!/bin/bash

### Cardano Node Build/Upgrade FROM source: 1 OF 1 ###
### Run first pre-install-os.sh script. ###
### Run second pre-install-libs.sh script. ###

CNODE_VERSION="8.0.0"

# Patch OS - Optional
sudo apt update
sudo apt upgrade -y

# Backup
cp ~/.local/bin/cardano-cli ~/.local/bin/cardano-cli-pre
cp ~/.local/bin/cardano-node ~/.local/bin/cardano-node-pre

# Update compiler libs
ghcup upgrade
ghcup install ghc 8.10.7
ghcup install cabal 3.8.1.0
ghcup set ghc 8.10.7
ghcup set cabal 3.8.1.0
cabal update
ghc --version
cabal --version

# Updade libsodium-vrf
cd ~/src
git clone https://github.com/input-output-hk/libsodium libsodium2
cd libsodium2
git checkout dbb48cce5429cb6585c9034f002568964f1ce567
./autogen.sh
./configure
make
sudo make install

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
cabal build cardano-node cardano-cli

# Deploy upgraded node
sudo systemctl stop cnode

mkdir -p ~/.local/bin
cp -p "$(./scripts/bin-path.sh cardano-node)" ~/.local/bin/
cp -p "$(./scripts/bin-path.sh cardano-cli)" ~/.local/bin/

# Clean up
cd ~/src
rm -rf cardano-node-old
rm -rf libsodium-old
mv libsodium libsodium-old
mv libsodium2 libsodium
mv cardano-node cardano-node-old
mv cardano-node2 cardano-node

cardano-cli --version
cardano-node --version

sudo systemctl start cnode

echo 'END'
