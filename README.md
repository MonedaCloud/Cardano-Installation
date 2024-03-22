# Cardano Node Installation

This repo contains scripts and installation steps for Cardano node as a block producer and relay.

## How to use this repo:

### Default settings

- Adjust settings before proceeding with the installation.
- CNODE_VERSION="8.9.0"
- NETWORK='mainnet'
- CNODE_FILES='/opt/cardano/cnode/files'
- CNODE='relay'

**Note:** These steps were successfully tested on Mainnet and Preprod environments with Cardano node version **8.9.0**. These steps are the same for Producer nodes and Relay nodes.

- The below steps assume you already have a dedicated OS user with sudo privileges running on Ubuntu 22.04:

### Option 1: (Installing from Cardano GitHub binaries repository.)

0. terminal:~$ `git clone https://github.com/MonedaCloud/Cardano-Installation.git`
1. terminal:~$ `cd Cardano-Installation`
2. terminal:~$ `git checkout v8.9.0`
3. terminal:~$ `./pre-install-os.sh && source ~/.bashrc` (Accept defaults by hitting [ENTER])
5. terminal:~$ `./pre-install-libs.sh && source ~/.bashrc`
7. terminal:~$ `./install-cardano-node-binaries.sh`
8. Configure env, cnode.sh, topology.json (Node Only).
9. terminal:~$ `sudo reboot`
* Node will start automatically right after the reboot. Check the syncing progress with `gLiveView` command.

### Option 2: (Installing from source.)

0. terminal:~$ `git clone https://github.com/MonedaCloud/Cardano-Installation.git`
1. terminal:~$ `cd Cardano-Installation`
2. terminal:~$ `git checkout v8.9.0`
3. terminal:~$ `./pre-install-os.sh && source ~/.bashrc` (Accept defaults by hitting [ENTER])
5. terminal:~$ `./pre-install-libs.sh && source ~/.bashrc`
7. terminal:~$ `./install-cardano-node.sh`
8. Configure env, cnode.sh, topology.json (Node Only).
9. terminal:~$ `sudo reboot`
* Node will start automatically right after the reboot. Check the syncing progress with `gLiveView` command.

## Upgrading Cardano Node

- The below steps assume you already have a dedicated OS user with sudo privileges running on Ubuntu 22.04:
- Default upgrade settings: (Adjust settings before proceeding with the upgrade.)
- CNODE_VERSION="8.9.0"
- NETWORK='mainnet'
- CNODE_FILES='/opt/cardano/cnode/files'
- CNODE='relay'

### Update Configuration files from Cardano "Configuration Files" Official release: (Required)

- terminal:~$ `nano upgrade-cardano-node.sh` (Edit: CNODE_VERSION="8.9.X" line with the correct version number.)
- terminal:~$ `nano upgrade-genesis-files.sh` (Edit: CNODE_VERSION="8.9.X"s, NETWORK='mainnet', CNODE='relay' lines with the intended values.)

- Visit https://book.world.dev.cardano.org/environments.html for references.

### Upgrading Steps (Upgrading from source.)

0. terminal:~$ `sudo systemctl stop cnode`
1. terminal:~$ `./upgrade-cardano-node.sh`
2. terminal:~$ `./upgrade-genesis-files.sh`
4. terminal:~$ `sudo systemctl start cnode`

### Monitoring the Cardano Node

- terminal:~$ `journalctl -fu cnode`
- terminal:~$ `gLiveView`
- terminal:~$ `tail -F /opt/cardano/cnode/logs/node0.json` (Mainnet configuration only.)


**DO NOT run upgrade-cardano-node.sh as sudo; the prompt will ask for sudo credentials.**

## References:

https://github.com/input-output-hk/cardano-node/releases

https://developers.cardano.org/docs/get-started/installing-cardano-node/

https://github.com/input-output-hk/cardano-node-wiki/blob/main/docs/getting-started/install.md

https://github.com/input-output-hk/cardano-node/blob/master/doc/getting-started/install.md#using-the-ported-c-code

https://github.com/input-output-hk/cardano-node-wiki/blob/main/docs/getting-started/install.md#installing-blst

https://github.com/input-output-hk/cardano-node-wiki/blob/main/docs/getting-started/understanding-config-files.md#light-genesis-aka-bootstrap-peers

https://book.world.dev.cardano.org/environments.html