# Cardano Node Installation

This repo contains scripts and installation steps for Cardano node as a block producer and relay. (Cardano release 8.0.0)

## How to use this repo:

### Option 1:

- Install it all manually step by step using cardano-node-install-steps.txt.

### Option 2: (Recomended)

- The below steps assumes you already have a dedicated user named **cardano** with sudo privileges running on Ubuntu 20.04:

0. terminal:~$ `chmod +x *install*.sh`
1. terminal:~$ `./pre-install-os.sh`
2. terminal:~$ `source ~/.bashrc`
3. terminal:~$ `./pre-install-libs.sh`
4. terminal:~$ `source ~/.bashrc`
5. terminal:~$ `./install-cardano-node.sh`
6. Configure env, cnode.sh, topologyUpdater.sh (Relay Only), topology.json (Node Only).
7. terminal:~$ `sudo reboot`
* Node will start automatically right after the reboot. Check the syncing progress with `gLiveView` command.

**Note:** These steps were successfully tested on Mainnet with Cardano node version **8.0.0** (Conway). This steps are the same for Producer nodes and Relay nodes.

# Cardano Node-Upgrading

- The below steps assumes you already have a dedicated user named **cardano** with sudo privileges running on Ubuntu 20.04:
- Verify CNODE_VERSION="8.0.X" line has the correct release version number.

### Download ConwayGenesisFile from Cardano "Configuration Files" Official release: (Required)

- terminal:~$ `cd /opt/cardano/cnode/files/`

- terminal:~$ `wget https://book.world.dev.cardano.org/environments/mainnet/conway-genesis.json`

- terminal:~$ `nano config.json` (Edit: Add ConwayGenesisFile configuration lines.)

- "ConwayGenesisFile": "/opt/cardano/cnode/files/conway-genesis.json",

- "ConwayGenesisHash": "f28f1c1280ea0d32f8cd3143e268650d6c1a8e221522ce4a7d20d62fc09783e1",

### Cardano release upgrade commands

1. terminal:~$ `chmod +x upgrade-cardano-node.sh`
2. terminal:~$ `nano upgrade-cardano-node.sh` (Edit: CNODE_VERSION="8.0.X" line with the correct version number.)

**DO NOT run below comand as sudo, the prompt will ask for sudo credentials by itself.**

3. terminal:~$ `./upgrade-cardano-node.sh`

## References:

https://github.com/input-output-hk/cardano-node/releases

https://developers.cardano.org/docs/get-started/installing-cardano-node/

https://github.com/input-output-hk/cardano-node/blob/master/doc/getting-started/install.md#using-the-ported-c-code
