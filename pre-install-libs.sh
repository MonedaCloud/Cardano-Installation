#!/bin/bash

### Cardano Node Libs FROM source: 2 OF 3 ###
### Run first pre-install-os.sh script. ###

# Values: RELAY|NODE
MODE='RELAY'

# Values: mainnet|preprod|preview|sanchonet
NETWORK='mainnet'

### DO NOT EDIT BELOW THS LINE. ###

ghcup install ghc 8.10.7
ghcup install cabal 3.8.1.0
ghcup set ghc 8.10.7
ghcup set cabal 3.8.1.0
cabal update

mkdir -p ~/src

echo " " >> ~/.bashrc
echo 'export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"' >> ~/.bashrc
echo 'export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"' >> ~/.bashrc
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
. "${HOME}/.bashrc"

# Install libsodium-dev native OS libs:
sudo apt install libsodium-dev

# Install secp256k1 libs:
cd ~/src
rm -rf secp256k1
git clone https://github.com/bitcoin-core/secp256k1 secp256k1
cd secp256k1
git checkout ac83be33
./autogen.sh
./configure --enable-module-schnorrsig --enable-experimental
make
sudo make install

# Install Install libsodium fork from IO repositories:
cd ~/src
rm -rf libsodium
git clone https://github.com/input-output-hk/libsodium libsodium
cd libsodium
git checkout dbb48cc
./autogen.sh
./configure
make
make check
sudo make install

# Install BLST
cd ~/src
git clone https://github.com/supranational/blst blst2
cd blst2
git checkout v0.3.10
./build.sh
cat > libblst.pc << EOF
prefix=/usr/local
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
includedir=\${prefix}/include

Name: libblst
Description: Multilingual BLS12-381 signature library
URL: https://github.com/supranational/blst
Version: 0.3.10
Cflags: -I\${includedir}
Libs: -L\${libdir} -lblst
EOF
sudo cp libblst.pc /usr/local/lib/pkgconfig/
sudo cp bindings/blst_aux.h bindings/blst.h bindings/blst.hpp  /usr/local/include/
sudo cp libblst.a /usr/local/lib
sudo chmod u=rw,go=r /usr/local/{lib/{libblst.a,pkgconfig/libblst.pc},include/{blst.{h,hpp},blst_aux.h}}

# Download and configure Guild deploy script:
cd ~/src
curl -sS -o guild-deploy.sh https://raw.githubusercontent.com/cardano-community/guild-operators/master/scripts/cnode-helper-scripts/guild-deploy.sh
chmod 755 guild-deploy.sh

case "$MODE" in
'RELAY')
# RELAY
echo "1. Setting up $MODE on $NETWORK"
./guild-deploy.sh -n "$NETWORK"
;;
'NODE')
# NODE - INSTALLS CNCLI
echo "2. Setting up $MODE on $NETWORK"
# Install CNCLI Libs:
cd ~/src
git clone --recurse-submodules https://github.com/cardano-community/cncli
cd cncli
git checkout v5.3.2
cargo install --path . --force
cncli --version
# Run Guild deploy script:
cd ~/src
./guild-deploy.sh -n "$NETWORK" -s f,c
;;
*)
echo "MODE: RELAY|NODE \n NETWORK: mainnet|preprod"
;;
esac

. "${HOME}/.bashrc"

echo 'Run [ source ~/.bashrc ] on the terminal before proceeding to next step.'
