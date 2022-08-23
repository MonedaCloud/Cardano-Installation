#!/bin/sh

### Cardano Node Libs FROM source: 2 OF 3 ###
### Run first pre-install-os.sh script. ###

ghcup install ghc 8.10.7
ghcup install cabal 3.6.2.0
ghcup set ghc 8.10.7
ghcup set cabal 3.6.2.0

mkdir -p ~/src

cd ~/src
git clone https://github.com/input-output-hk/libsodium
cd libsodium
git checkout 66f017f1
./autogen.sh
./configure
make
sudo make install

echo " " >> ~/.bashrc
echo 'export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"' >> ~/.bashrc
echo 'export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"' >> ~/.bashrc
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
. "${HOME}/.bashrc"

sudo apt install libsodium-dev

cd ~/src
git clone https://github.com/bitcoin-core/secp256k1
cd secp256k1
git checkout ac83be33
./autogen.sh
./configure --enable-module-schnorrsig --enable-experimental
make
sudo make install


cd ~/src
curl -sS -o prereqs.sh https://raw.githubusercontent.com/cardano-community/guild-operators/master/scripts/cnode-helper-scripts/prereqs.sh
chmod 755 prereqs.sh
# If upgrading, DO NOT use -f option. It will overwrite configuration files.
#RELAY
./prereqs.sh -f -s
#NODE - INSTALLS CNCLI
#./prereqs.sh -f -s -c
. "${HOME}/.bashrc"

echo 'Run source ~/.bashrc on the terminal before proceeding to nest step.'
