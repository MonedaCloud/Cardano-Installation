# Cardano Node Installation

This repo contains scripts and installation steps for Cardano node as a block producer and relay.

## How to use this repo:

### Option 1: (Advanced)

- Installation manually step by step using cardano-node-install-steps.txt.

### Option 2: (Recommended)

- The below steps assume you already have a dedicated OS user with sudo privileges running on Ubuntu 22.04:

0. terminal:~$ `chmod +x *install*.sh`
1. terminal:~$ `./pre-install-os.sh`
2. terminal:~$ `source ~/.bashrc`
3. terminal:~$ `./pre-install-libs.sh`
4. terminal:~$ `source ~/.bashrc`
5. terminal:~$ `chmod +x set-genesis-files.sh` 
6. terminal:~$ `./set-genesis-files.sh`
7. terminal:~$ `./install-cardano-node.sh`
8. Configure env, cnode.sh, topology.json (Node Only).
9. terminal:~$ `sudo reboot`
* Node will start automatically right after the reboot. Check the syncing progress with `gLiveView` command.

**Note:** These steps were successfully tested on Mainnet and Preprod with Cardano node version **8.9.0**. These steps are the same for Producer nodes and Relay nodes.

# Cardano Node-Upgrading

- The below steps assume you already have a dedicated OS user with sudo privileges running on Ubuntu 22.04:
- Verify CNODE_VERSION="8.7.X" line has the correct release version number.

### Update Config files from Cardano "Configuration Files" Official release: (Required)

- terminal:~$ `nano update-genesis-files.sh` (Edit: CNODE_VERSION="8.7.X"s, NETWORK='mainnet', CNODE='relay' lines with the intended values.)
- terminal:~$ `./update-genesis-files.sh`
- Visit https://book.world.dev.cardano.org/environments.html for references.

### Node Producer config.json configuration:

- terminal:~$ `nano config.json` (Edit: Make sure that P2P line is disabled or removed and customize any other configuration line as needed.)

### Cardano Node Installation release upgrading commands:

1. terminal:~$ `chmod +x upgrade-genesis-files.sh`
2. terminal:~$ `./upgrade-genesis-files.sh`
3. terminal:~$ `chmod +x upgrade-cardano-node.sh`
4. terminal:~$ `nano upgrade-cardano-node.sh` (Edit: CNODE_VERSION="8.7.X" line with the correct version number.)

**DO NOT run the below command as sudo; the prompt will ask for sudo credentials.**

5. terminal:~$ `./upgrade-cardano-node.sh`

## References:

https://github.com/input-output-hk/cardano-node/releases

https://developers.cardano.org/docs/get-started/installing-cardano-node/

https://github.com/input-output-hk/cardano-node-wiki/blob/main/docs/getting-started/install.md

https://github.com/input-output-hk/cardano-node/blob/master/doc/getting-started/install.md#using-the-ported-c-code

https://github.com/input-output-hk/cardano-node-wiki/blob/main/docs/getting-started/install.md#installing-blst

https://github.com/input-output-hk/cardano-node-wiki/blob/main/docs/getting-started/understanding-config-files.md#light-genesis-aka-bootstrap-peers

https://book.world.dev.cardano.org/environments.html