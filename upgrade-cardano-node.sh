#!/bin/bash

### Cardano Node/Relay upgrade FROM source: 1 OF 2 ###
### Run first update-genesis-files.sh script. ###
### Run second upgrade-cardano-node.sh script. ###

CNODE_VERSION="8.9.0"


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

# Build Cardano node from source
cd ~/src
git clone https://github.com/input-output-hk/cardano-node.git cardano-node2
cd cardano-node2/
git fetch --all --recurse-submodules --tags
git checkout tags/$CNODE_VERSION

# Prepare compiler env
cabal update
cabal configure -O0 -w ghc-8.10.7
echo -e "package cardano-crypto-praos\n flags: -external-libsodium-vrf" >> cabal.project.local

# Build release command
cabal build all
cabal build cardano-cli
cabal build cardano-node

# Deploy upgraded node
sudo systemctl stop cnode

mkdir -p ~/.local/bin
cp -p "$(./scripts/bin-path.sh cardano-node)" ~/.local/bin/
cp -p "$(./scripts/bin-path.sh cardano-cli)" ~/.local/bin/

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

sudo systemctl start cnode

echo 'END'
