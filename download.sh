#!/bin/bash

# SSH prepare
if [[ -e $HOME/.ssh/id_rsa && -e $HOME/.ssh/id_rsa.pub ]]; then
    echo "Copy public key"
    cat $HOME/.ssh/id_rsa.pub
else
    echo "Generating public key"
    ssh-keygen
    echo "Copy public key"
    cat $HOME/.ssh/id_rsa.pub
fi

# Download ssh config file
cp .ssh/config .ssh/config_bakup
scp root@bastion.chivier.site:.ssh/config .ssh/config

# Basic things
sudo apt install vim
sudo apt install ccls

# GNU Compilers
sudo apt install gcc-10 g++-10 gcc-9 g++-9 gcc-8 g++-8 gdb
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 8
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 8
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 9
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 9
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 10
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 10


# Download from bastion
if [[ ! -e $HOME/opt ]]; then
    echo "Generating opt directory..."
    mkdir -p $HOME/opt
fi

if [[ ! -e $HOME/opt/llvm ]]; then
    echo "Downloading LLVM..."
    scp -r bastion:share/tools/llvm $HOME/opt
fi

if [[ ! -e $HOME/opt/cmake ]]; then
    echo "Downloading Cmake..."
    scp -r bastion:share/tools/cmake $HOME/opt
fi

if [[ ! -e $HOME/opt/oneapi ]]; then
    echo "Downloading oneapi..."
    scp -r bastion:share/tools/oneapi $HOME/opt
fi

# Install LLVM
if [[ ! -e $HOME/opt/llvm ]]; then
fi

# Install OneAPI

# Install CMake

