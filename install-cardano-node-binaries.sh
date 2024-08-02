#!/bin/bash

### Cardano Node Build/Install FROM binaries: 3 OF 3 ###
### Run first pre-install-os.sh script. ###
### Run second pre-install-libs.sh script. ###

# https://github.com/input-output-hk/cardano-node/releases

# Cardano Node Release:
CNODE_VERSION="8.9.4"

# Values: mainnet|preprod|preview|sanchonet
NETWORK='mainnet'

# Cardano installation file path:
CNODE_FILES='/opt/cardano/cnode/files'

# Cardano installation cnode scripts path:
CNODE_SCRIPTS='/opt/cardano/cnode/scripts'

# Local Cardano Genesis files path:
LOCAL_FILES="`pwd`"

# Values: node|relay
CNODE='relay'

# Binary source:
BINARY="https://github.com/IntersectMBO/cardano-node/releases/download/$CNODE_VERSION/cardano-node-$CNODE_VERSION-linux.tar.gz"

### DO NOT EDIT BELOW THS LINE. ###

# Stop Cardano node:
sudo systemctl stop cnode

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

# Backup file:
cp $CNODE_FILES/config.json $CNODE_FILES/config.json.bk_pre_$CNODE_VERSION
cp $CNODE_FILES/topology.json $CNODE_FILES/topology.json.bk_pre_$CNODE_VERSION
cp $CNODE_FILES/byron-genesis.json $CNODE_FILES/byron-genesis.json.bk_pre_$CNODE_VERSION
cp $CNODE_FILES/shelley-genesis.json $CNODE_FILES/shelley-genesis.json.bk_pre_$CNODE_VERSION
cp $CNODE_FILES/alonzo-genesis.json $CNODE_FILES/alonzo-genesis.json.bk_pre_$CNODE_VERSION
cp $CNODE_FILES/conway-genesis.json $CNODE_FILES/conway-genesis.json.bk_pre_$CNODE_VERSION
cp $CNODE_SCRIPTS/env $CNODE_SCRIPTS/env_pre_$CNODE_VERSION

# Update blockchain genesis files:
cd $LOCAL_FILES
cp ./opt/cardano/cnode/files/$NETWORK/config.json $CNODE_FILES/config.json
cp ./opt/cardano/cnode/files/$NETWORK/topology.json $CNODE_FILES/topology.json
cp ./opt/cardano/cnode/files/$NETWORK/byron-genesis.json $CNODE_FILES/byron-genesis.json
cp ./opt/cardano/cnode/files/$NETWORK/shelley-genesis.json $CNODE_FILES/shelley-genesis.json
cp ./opt/cardano/cnode/files/$NETWORK/alonzo-genesis.json $CNODE_FILES/alonzo-genesis.json
cp ./opt/cardano/cnode/files/$NETWORK/conway-genesis.json $CNODE_FILES/conway-genesis.json
cp ./opt/cardano/cnode/scripts/env $CNODE_SCRIPTS/env

# Get pre-configured mainnet node config.json file without P2P and logging settings enabled:
if [[ "$CNODE" == "node" && "$NETWORK" == "mainnet" ]]; then
    cp ./opt/cardano/cnode/files/$NETWORK/config-node.json $CNODE_FILES/config.json
fi

# Get pre-configured mainnet relay config.json file with P2P and logging settings enabled:
if [[ "$CNODE" == "relay" && "$NETWORK" == "mainnet" ]]; then
    cp ./opt/cardano/cnode/files/$NETWORK/config-relay.json $CNODE_FILES/config.json
fi

# Run systemd deploy script:
cd /opt/cardano/cnode/scripts
./cnode.sh -d

echo 'alias env=/usr/bin/env
alias cntools=/opt/cardano/cnode/scripts/cntools.sh
alias gLiveView=/opt/cardano/cnode/scripts/gLiveView.sh
export CARDANO_NODE_SOCKET_PATH="/opt/cardano/cnode/sockets/node.socket"
export PATH="/opt/cardano/cnode/scripts:/$HOME/.cabal/bin:$PATH"
export CNODE_HOME=/opt/cardano/cnode' >> ~/.bashrc
. "${HOME}/.bashrc"

# Start Cardano node:
sudo systemctl start cnode

echo 'Run [ systemctl status cnode ] on the terminal to check the status of the Cardano node service.'
echo 'Run [ journalctl -fu cnode ] on the terminal to monitor for service errors.'
echo 'Run [ tail -F /opt/cardano/cnode/logs/node0.json ] to follow node logs (Only mainnet configuration).'

echo 'END'
