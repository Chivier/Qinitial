#!/bin/bash

QINDIR=`pwd`
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
if [[ ! -e $HOME/.ssh/config ]]; then
    cd $HOME/.ssh
    touch config
fi
cp $HOME/.ssh/config $HOME/.ssh/config_bakup
scp root@bastion.chivier.site:.ssh/config $HOME/.ssh/config

# Basic things
sudo apt install -y ccls vim git zsh tmux silversearcher-ag htop

# Extended things
sudo apt install -y fd-find bat

if [[ ! -e /usr/bin/lazygit ]]; then
    sudo add-apt-repository ppa:lazygit-team/release
    sudo apt-get update
    sudo apt-get install lazygit
fi

# GNU Compilers
sudo apt install -y gcc-10 g++-10 gcc-9 g++-9 gcc-8 g++-8 gdb
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
if [[ ! -e $HOME/opt/llvm/chver ]]; then
    cd $HOME/opt/llvm/llvm14
    tar xf clang+llvm-14.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz
    ln -s $HOME/opt/llvm/llvm14/clang+llvm-14.0.0-x86_64-linux-gnu-ubuntu-18.04 $HOME/opt/llvm/chver
fi

# Install OneAPI
if [[ ! -e /opt/intel/oneapi/setvars.sh ]]; then
    cd $HOME/opt/oneapi
    sudo bash ./l_BaseKit_p_2022.1.2.146_offline.sh
    sudo bash ./l_HPCKit_p_2022.1.2.117_offline.sh
fi

# Install CMake
if [[ ! -e $HOME/opt/cmake/chver ]]; then
    cd $HOME/opt/cmake
    tar xf cmake-3.23.0-rc4-linux-x86_64.tar.gz
    ln -s $HOME/opt/cmake/cmake-3.23.0-rc4-linux-x86_64 $HOME/opt/cmake/chver
fi

# Rust
if [[ ! -e $HOME/.cargo ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# Python
sudo apt install -y python-is-python3
sudo apt install -y python3.9

# Pyenv
if [[ ! -e $HOME/.pyenv ]]; then
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    cd ~/.pyenv && src/configure && make -C src
fi

# MPICH
if [[ ! -e $HOME/opt/mpich ]]; then
    cd $HOME/opt
    mkdir mpich
    cd mpich
    wget https://www.mpich.org/static/downloads/4.0.2/mpich-4.0.2.tar.gz
    tar xf mpich-4.0.2.tar.gz
    cd mpich-4.0.2
    ./configure --prefix=$HOME/opt/mpich/chver
    make -j4
    sudo make install
fi

# Bookmarks
if [[ ! -e $HOME/opt/bashmarks ]]; then
    cd $HOME/opt
    git clone https://github.com/huyng/bashmarks.git
    cd bashmarks
    make install
    source ~/.local/bin/bashmarks.sh
fi

# fzf
if [[ ! -e $HOME/.fzf.zsh ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
fi

# vimrc
if [[ ! -e $HOME/.vim_runtime ]]; then
    git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_basic_vimrc.sh
fi

# tmux
cd
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .

# zsh
cd $QINDIR
tar xf zsh.tar

if [[ ! -e $HOME/.oh-my-zsh ]]; then
    mv .oh-my-zsh ..
else
    rm -rf .oh-my-zsh
fi

if [[ ! -e $HOME/.zinit ]]; then
    mv .zinit ..
else
    rm -rf .zinit
fi

cp zshrc ../.zshrc

cd
sudo chown -R $USER .oh-my-zsh
sudo chown -R $USER .zinit
sudo chown -R $USER .zshrc

cd
cd .oh-my-zsh/custom/plugins
rm -rf zenplash
git clone https://github.com/Chivier/zenplash.git

cd
mkdir Projects

