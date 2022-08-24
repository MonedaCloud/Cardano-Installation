# Cardano-Installation

This repo contains scripts and installation steps for Cardano node as block producer and relay.

## How to use this repo:

### Option 1:

- Install it all manually step by step using cardano-node-install-steps.txt.

### Option 2: (Recomended)

- Below steps assumes you already have a dedicate user named cardano with sudo privileges running on Ubuntu 20.04:
1. terminal:~$ ./pre-install-os.sh
2. terminal:~$ ~/.bashrc
3. terminal:~$ ./pre-install-libs.sh
4. terminal:~$ ~/.bashrc
5. terminal:~$ ./install-cardano-node.sh
6. Configure env, cnode.sh, topologyUpdater.sh (Relay Only), topology.json (Node Only).
7. terminal:~$ sudo reboot
