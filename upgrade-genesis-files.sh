#!/bin/bash

### Cardano Node/Relay upgrade FROM source: 1 OF 2 ###
### Run first update-genesis-files.sh script. ###
### Run second upgrade-cardano-node.sh script. ###

# Cardano Node Release:
CNODE_VERSION="10.1.2"

# Values: mainnet|preprod|preview|sanchonet
NETWORK='mainnet'

# Cardano installation file path:
CNODE_FILES='/opt/cardano/cnode/files'

# Cardano installation cnode scripts path:
CNODE_SCRIPTS='/opt/cardano/cnode/scripts'

# Values: node|relay
CNODE='relay'

### DO NOT EDIT BELOW THS LINE. ###

# Backup file:
cp $CNODE_FILES/config.json $CNODE_FILES/config.json.bk_pre_$CNODE_VERSION
cp $CNODE_FILES/topology.json $CNODE_FILES/topology.json.bk_pre_$CNODE_VERSION
cp $CNODE_FILES/byron-genesis.json $CNODE_FILES/byron-genesis.json.bk_pre_$CNODE_VERSION
cp $CNODE_FILES/shelley-genesis.json $CNODE_FILES/shelley-genesis.json.bk_pre_$CNODE_VERSION
cp $CNODE_FILES/alonzo-genesis.json $CNODE_FILES/alonzo-genesis.json.bk_pre_$CNODE_VERSION
cp $CNODE_FILES/conway-genesis.json $CNODE_FILES/conway-genesis.json.bk_pre_$CNODE_VERSION
cp $CNODE_SCRIPTS/env $CNODE_SCRIPTS/env_pre_$CNODE_VERSION

# Update blockchain genesis files. topology file is NOT modified:
cp ./opt/cardano/cnode/files/$NETWORK/config.json $CNODE_FILES/config.json
cp ./opt/cardano/cnode/files/$NETWORK/byron-genesis.json $CNODE_FILES/byron-genesis.json
cp ./opt/cardano/cnode/files/$NETWORK/shelley-genesis.json $CNODE_FILES/shelley-genesis.json
cp ./opt/cardano/cnode/files/$NETWORK/alonzo-genesis.json $CNODE_FILES/alonzo-genesis.json
cp ./opt/cardano/cnode/files/$NETWORK/conway-genesis.json $CNODE_FILES/conway-genesis.json
cp ./opt/cardano/cnode/scripts/env $CNODE_SCRIPTS/env

# Get pre-configured mainnet node config.json file without P2P:
if [[ "$CNODE" == "node" && "$NETWORK" == "mainnet" ]]; then
    cp ./opt/cardano/cnode/files/$NETWORK/config-node.json $CNODE_FILES/config.json
fi

# Get pre-configured mainnet relay config.json file with P2P:
if [[ "$CNODE" == "relay" && "$NETWORK" == "mainnet" ]]; then
    cp ./opt/cardano/cnode/files/$NETWORK/config-relay.json $CNODE_FILES/config.json
fi

echo "Cardano genesis files updated for version $CNODE_VERSION on network $NETWORK."

echo "Run upgrade-cardano-node.sh script using CNODE_VERSION="$CNODE_VERSION" configuration."

echo 'END'
