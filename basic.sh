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

# Rust
if [[ ! -e $HOME/.cargo ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# Pyenv
if [[ ! -e $HOME/.pyenv ]]; then
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    cd ~/.pyenv && src/configure && make -C src
fi

if [[ ! -e $HOME/opt ]]; then
    mkdir -p $HOME/opt
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

# nvim
if [[ ! -e $HOME/.config/nvim ]]; then
    mv $HOME/.config/nvim $HOME/.config/nvim_backup
fi
cd $HOME/opt
wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
tar xf nvim-linux64.tar.gz
cd nvim-linux64
sudo rsync -avhu bin/* /usr/local/bin/
sudo rsync -avhu lib/* /usr/local/lib/
sudo rsync -avhu share/* /usr/local/share/
git clone https://github.com/LazyVim/starter ~/.config/nvim

# tmux
cd
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .

# zsh
cd $QINDIR
tar xf zsh.tar

if [[ ! -e $HOME/.oh-my-zsh ]]; then
    mv .oh-my-zsh $HOME
else
    rm -rf .oh-my-zsh
    mv .oh-my-zsh $HOME
fi

if [[ ! -e $HOME/.zinit ]]; then
    mv .zinit $HOME
else
    rm -rf .zinit
    mv .zinit $HOME
fi

cp zshrc $HOME/.zshrc

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

