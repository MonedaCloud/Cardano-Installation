#!/bin/bash

### Cardano Node/Relay upgrade FROM binaries: 1 OF 2 ###
### Run first upgrade-genesis-files.sh script. ###
### Run second upgrade-cardano-node.sh script. ###

# Cardano Node Release:
CNODE_VERSION="8.9.0"

# Binary source:
BINARY="https://github.com/IntersectMBO/cardano-node/releases/download/$CNODE_VERSION/cardano-node-$CNODE_VERSION-linux.tar.gz"

### DO NOT EDIT BELOW THS LINE. ###

# Patch OS - Optional
sudo apt update
sudo apt upgrade -y

# Backup
cp ~/.local/bin/cardano-cli ~/.local/bin/cardano-cli-pre
cp ~/.local/bin/cardano-node ~/.local/bin/cardano-node-pre

# Update compiler libs
ghcup upgrade
ghcup install ghc 8.10.7
ghcup install cabal 3.8.1.0
ghcup set ghc 8.10.7
ghcup set cabal 3.8.1.0
cabal update
ghc --version
cabal --version

# Updade libsodium-vrf
cd ~/src
git clone https://github.com/input-output-hk/libsodium libsodium2
cd libsodium2
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

# Download Cardano Node release from GitHub:
mkdir -p ~/src
cd ~/src
rm -rf cardano-node-*
rm -rf bin
rm -rf share
wget $BINARY
tar -xvzf cardano-node*.tar.gz

# Deploy Cardano Node binaries into local bin directory:
mkdir -p ~/.local/bin
cp  ./bin/* ~/.local/bin/
echo 'export PATH="$HOME/.local/bin/:$PATH"' >> ~/.bashrc
export PATH="$HOME/.local/bin/:$PATH"
. "${HOME}/.bashrc"

# Clean up
cd ~/src
rm -rf cardano-node-old
rm -rf libsodium-old
rm -rf blst-old
mv libsodium libsodium-old
mv libsodium2 libsodium
mv blst blst-old
mv blst2 blst
mv cardano-node cardano-node-old
mv cardano-node2 cardano-node

cardano-cli --version
cardano-node --version

sudo systemctl restart cnode

echo 'END'
