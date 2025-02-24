# Cardano Node Installation

This repo contains scripts and installation steps for Cardano node as a block producer and relay.

## How to use this repo:

### Default settings

```bash
# Adjust settings before proceeding with the installation.
CNODE_VERSION="10.1.4"
NETWORK='mainnet'
CNODE_FILES='/opt/cardano/cnode/files'
CNODE='relay'
```

**Note:** These steps were successfully tested on Mainnet and Preprod environments with Cardano node version **10.1.4**.

### The below steps assume you already have a dedicated Ubuntu base 20.04/22.04 LTS OS and a user with sudo privileges: (Ubuntu 24.04 is not supported.)

### Adding a sudo-user (node) to run the Cardano node application:
0. terminal:~$ `sudo adduser node`
1. terminal:~$ `sudo usermod -aG sudo node`
2. terminal:~$ `su - node`

### Option 1: (Installing from Cardano GitHub binaries repository.)

0. terminal:~$ `git clone https://github.com/MonedaCloud/Cardano-Installation.git`
1. terminal:~$ `cd Cardano-Installation`
2. terminal:~$ `git checkout v10.1.4`
3. terminal:~$ `./pre-install-os.sh && source ~/.bashrc` (Accept defaults by hitting [ENTER])
5. terminal:~$ `./pre-install-libs.sh && source ~/.bashrc`
7. terminal:~$ `./install-cardano-node-binaries.sh && source ~/.bashrc`
8. Configure scripts/env, scripts/cnode.sh, files/topology.json. Check the [configuration-files.md](https://github.com/MonedaCloud/Cardano-Installation/blob/main/configuration-files.md) guide.
9. terminal:~$ `sudo reboot`
* Node will start automatically right after the reboot. Check the syncing progress with `gLiveView` command.

### Option 2: (Installing from source.)

0. terminal:~$ `git clone https://github.com/MonedaCloud/Cardano-Installation.git`
1. terminal:~$ `cd Cardano-Installation`
2. terminal:~$ `git checkout v10.1.4`
3. terminal:~$ `./pre-install-os.sh && source ~/.bashrc` (Accept defaults by hitting [ENTER])
5. terminal:~$ `./pre-install-libs.sh && source ~/.bashrc`
7. terminal:~$ `./install-cardano-node.sh && source ~/.bashrc`
8. Configure scripts/env, scripts/cnode.sh, files/topology.json. Check the configuration-files.md guide.
9. terminal:~$ `sudo reboot`
* Node will start automatically right after the reboot. Check the syncing progress with `gLiveView` command.

### Configuring firewall: (Required for source and binaries intallation options.)
0. terminal:~$ `sudo ufw default deny incoming`
1. terminal:~$ `sudo ufw default allow outgoing`
2. terminal:~$ `sudo ufw allow 22/tcp`
3. terminal:~$ `sudo ufw allow 6000/tcp` (Use the port configured in the /opt/cardano/cnode/scripts/env file.)
4. terminal:~$ `sudo ufw enable`
5. terminal:~$ `sudo ufw status`

## Upgrading Cardano Node

```bash
# Set settings variables before running upgrade-genesis-files.sh.
# The below steps assume a dedicated OS user with sudo privileges running on Ubuntu 22.04:
# Default upgrade settings: (Adjust settings before proceeding with the upgrade.)
CNODE_VERSION="10.1.4"
NETWORK='mainnet'
CNODE_FILES='/opt/cardano/cnode/files'
CNODE='relay'
```

### Update Configuration files from Cardano "Configuration Files" Official release: (Required)

```bash
git clone https://github.com/MonedaCloud/Cardano-Installation.git
cd Cardano-Installation
git checkout v10.1.4
```

#### Node/relay Configuration

```bash
nano upgrade-genesis-files.sh
```

### Upgrading Steps (Upgrading from source.)

```bash
sudo systemctl stop cnode
./upgrade-cardano-node.sh
./upgrade-genesis-files.sh
sudo systemctl restart cnode
```

### Upgrading Steps (Upgrading from binaries.)

```bash
sudo systemctl stop cnode
./upgrade-cardano-node-binaries.sh
./upgrade-genesis-files.sh
sudo systemctl restart cnode
```

- Disable P2P feature for node producers:

```bash
nano /opt/cardano/cnode/files/config.json
```

```bash
"EnableP2P": false,
```

### Monitoring the Cardano Node

- terminal:~$ `journalctl -fu cnode`
- terminal:~$ `gLiveView`
- terminal:~$ `tail -F /opt/cardano/cnode/logs/node0.json` (Mainnet configuration only.)


**DO NOT run upgrade-cardano-node.sh as sudo; the prompt will ask for sudo credentials.**

## References:

https://book.world.dev.cardano.org/environments.html

https://github.com/input-output-hk/cardano-node/releases

https://developers.cardano.org/docs/get-started/installing-cardano-node/

https://github.com/input-output-hk/cardano-node-wiki/blob/main/docs/getting-started/install.md

https://github.com/input-output-hk/cardano-node/blob/master/doc/getting-started/install.md#using-the-ported-c-code

https://github.com/input-output-hk/cardano-node-wiki/blob/main/docs/getting-started/install.md#installing-blst

https://github.com/input-output-hk/cardano-node-wiki/blob/main/docs/getting-started/understanding-config-files.md#light-genesis-aka-bootstrap-peers

https://github.com/cardano-community/guild-operators

https://cardano-community.github.io/support-faq/

https://www.coincashew.com/coins/overview-ada