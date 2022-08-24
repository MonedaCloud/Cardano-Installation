# Cardano-Installation

This repo contains scripts and installation steps for Cardano node as a block producer and relay.

## How to use this repo:

### Option 1:

- Install it all manually step by step using cardano-node-install-steps.txt.

### Option 2: (Recomended)

- The below steps assumes you already have a dedicated user named **cardano** with sudo privileges running on Ubuntu 20.04:
1. terminal:~$ `./pre-install-os.sh`
2. terminal:~$ `source ~/.bashrc`
3. terminal:~$ `./pre-install-libs.sh`
4. terminal:~$ `source ~/.bashrc`
5. terminal:~$ `./install-cardano-node.sh`
6. Configure env, cnode.sh, topologyUpdater.sh (Relay Only), topology.json (Node Only).
7. terminal:~$ `sudo reboot`
* Node will start automatically right after the reboot. Check the syncing progress with `gLiveView` command.

**Note:** These steps were sucessfully tested on Mainnet with Cardano node version **1.35.3** (Vasil).


#### References:

https://developers.cardano.org/docs/get-started/installing-cardano-node/

https://github.com/input-output-hk/cardano-node/blob/master/doc/getting-started/install.md#using-the-ported-c-code
