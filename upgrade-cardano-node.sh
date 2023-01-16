#!/bin/sh

### Cardano Node Build/Upgrade FROM source: 1 OF 1 ###
### Run first pre-installCardanoNode.sh script. ###
### Run second installCardanoNodeLibs.sh script. ###

CNODE_VERSION="1.35.4"

#Patch OS - Optional
sudo apt update
sudo apt upgrade -y

#Backup
cp ~/.local/bin/cardano-cli ~/.local/bin/cardano-cli-pre
cp ~/.local/bin/cardano-node ~/.local/bin/cardano-node-pre

mkdir -p ~/src
cd ~/src
git clone https://github.com/input-output-hk/cardano-node.git cardano-node2
cd cardano-node2/
git fetch --all --recurse-submodules --tags
git checkout tags/$CNODE_VERSION

#Update Libs
ghcup upgrade
ghcup install ghc 8.10.7
ghcup install cabal 3.6.2.0
ghcup set ghc 8.10.7
ghcup set cabal 3.6.2.0
cabal update
ghc --version
cabal --version

cabal configure -O0 -w ghc-8.10.7
echo -e "package cardano-crypto-praos\n flags: -external-libsodium-vrf" >> cabal.project.local
cabal build cardano-node cardano-cli

sudo systemctl stop cnode

mkdir -p ~/.local/bin
cp -p "$(./scripts/bin-path.sh cardano-node)" ~/.local/bin/
cp -p "$(./scripts/bin-path.sh cardano-cli)" ~/.local/bin/

#Clean up
cd ~/src
rm -rf cardano-node-old
mv cardano-node cardano-node-old
mv cardano-node2 cardano-node

cardano-cli --version
cardano-node --version

sudo systemctl start cnode

echo 'END'
