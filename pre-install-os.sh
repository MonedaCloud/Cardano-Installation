#!/bin/bash

### Pre Cardano Node OS Install/Upgrade FROM source: 1 OF 3 ###

sudo apt update
sudo apt upgrade -y
sudo apt install vim htop inetutils-ping -y
sudo apt autoremove -y

sudo apt-get install automake build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ tmux git jq wget libncursesw5 libtool autoconf liblmdb-dev musl-tools -y

sudo apt-get install curl libffi7 libgmp10 libncurses-dev libncurses5 libtinfo5 sqlite3 -y

curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

. "${HOME}/.bashrc"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

source $HOME/.cargo/env

rustup install stable

rustup default stable

rustup update

rustup component add clippy rustfmt

rustup target add x86_64-unknown-linux-musl

echo 'Run [ source ~/.bashrc ] on the terminal before proceeding to next step.'
