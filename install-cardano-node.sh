#!/bin/sh

### Cardano Node Build/Install FROM source: 3 OF 3 ###
### Run first pre-install-os.sh script. ###
### Run second pre-install-libs.sh script. ###

CNODE_VERSION="1.35.7"

mkdir -p ~/src

cd ~/src
git clone https://github.com/input-output-hk/cardano-node.git
cd cardano-node
git fetch --tags --all
git checkout tags/$CNODE_VERSION
echo "with-compiler: ghc-8.10.7" >> cabal.project.local
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
