#!/bin/bash

### Cardano Node Build/Install FROM source: 3 OF 3 ###
### Run first pre-install-os.sh script. ###
### Run second pre-install-libs.sh script. ###

# https://github.com/input-output-hk/cardano-node/releases
CNODE_VERSION="8.7.2"
# Values: mainnet|preprod
NETWORK='mainnet'

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
# Add below line for development testnet enviroments only:
echo -e "package cardano-crypto-praos\n flags: -external-libsodium-vrf" >> cabal.project.local

# Build release command
cabal build all
cabal build cardano-cli
cabal build cardano-node

mkdir -p ~/.local/bin
cp -p "$(./scripts/bin-path.sh cardano-node)" ~/.local/bin/
cp -p "$(./scripts/bin-path.sh cardano-cli)" ~/.local/bin/
echo 'export PATH="$HOME/.local/bin/:$PATH"' >> ~/.bashrc
export PATH="$HOME/.local/bin/:$PATH"
. "${HOME}/.bashrc"

cardano-cli --version
cardano-node --version

case "$NETWORK" in
'mainnet')
# MAINNET CONFIG
echo "1. Setting up $NETWORK CONFIG FILES"
cd /opt/cardano/cnode/files/
mv config.json config.json.bk
mv conway-genesis.json conway-genesis.json.bk
wget https://book.world.dev.cardano.org/environments/mainnet/config.json
# Adding conway files for release >v8.0.0:
wget https://book.world.dev.cardano.org/environments/mainnet/conway-genesis.json
;;
'preprod')
# PREPROD CONFIG
echo "2. Setting up $NETWORK CONFIG FILES"
cd /opt/cardano/cnode/files/
mv config.json config.json.bk
mv conway-genesis.json conway-genesis.json.bk
wget https://book.world.dev.cardano.org/environments/preprod/config.json
# Adding conway files for release >v8.0.0:
wget https://book.world.dev.cardano.org/environments/preprod/conway-genesis.json
;;
*)
echo "NETWORK: $NETWORK CONFIGURED"
;;
esac

# Start/restart Cardano node service:
sudo systemctl restart cnode

# Run systemd deploy script:
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
