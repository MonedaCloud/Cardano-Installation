#!/bin/bash

### Cardano Node Build/Install FROM source: 3 OF 3 ###
### Run first pre-install-os.sh script. ###
### Run second pre-install-libs.sh script. ###

CNODE_VERSION="8.0.0"

# These steps are recommended to be done manually.
#cd /opt/cardano/cnode/files/
#wget https://book.world.dev.cardano.org/environments/mainnet/conway-genesis.json
#echo '"ConwayGenesisFile": "/opt/cardano/cnode/files/conway-genesis.json",' >> config.json
#echo '"ConwayGenesisHash": "f28f1c1280ea0d32f8cd3143e268650d6c1a8e221522ce4a7d20d62fc09783e1"' >> config.json

mkdir -p ~/src

cd ~/src
rm -rf cardano-node
git clone https://github.com/input-output-hk/cardano-node.git cardano-node
cd cardano-node
git fetch --tags --all
git checkout tags/$CNODE_VERSION

# Prepare compiler env
cabal update
cabal configure -O0 -w ghc-8.10.7
echo -e "package cardano-crypto-praos\n flags: -external-libsodium-vrf" >> cabal.project.local

# Build release command
cabal build all

mkdir -p ~/.local/bin
cp -p "$(./scripts/bin-path.sh cardano-node)" ~/.local/bin/
cp -p "$(./scripts/bin-path.sh cardano-cli)" ~/.local/bin/
echo 'export PATH="$HOME/.local/bin/:$PATH"' >> ~/.bashrc
export PATH="$HOME/.local/bin/:$PATH"
. "${HOME}/.bashrc"

cardano-cli --version
cardano-node --version

cd /opt/cardano/cnode/scripts
./deploy-as-systemd.sh

echo 'alias env=/usr/bin/env
alias cntools=/opt/cardano/cnode/scripts/cntools.sh
alias gLiveView=/opt/cardano/cnode/scripts/gLiveView.sh
export CARDANO_NODE_SOCKET_PATH="/opt/cardano/cnode/sockets/node0.socket"
export PATH="/opt/cardano/cnode/scripts:/$HOME/.cabal/bin:$PATH"
export CNODE_HOME=/opt/cardano/cnode' >> ~/.bashrc
. "${HOME}/.bashrc"
echo 'END'
