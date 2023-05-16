#!/bin/bash

QINDIR=$(pwd)
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

# Pyenv
if [[ ! -e $HOME/.pyenv ]]; then
	curl https://pyenv.run | bash
fi

if [[ ! -e $HOME/opt ]]; then
	mkdir -p $HOME/opt
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
rsync -avhu bin/* $HOME/.local/bin/
rsync -avhu lib/* $HOME/.local/lib/
rsync -avhu share/* $HOME/.local/share/
git clone https://github.com/Chivier/ChivierLazyNvim.git ~/.config/nvim

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
chown -R $USER .oh-my-zsh
chown -R $USER .zinit
chown -R $USER .zshrc

cd
cd .oh-my-zsh/custom/plugins
rm -rf zenplash
git clone https://github.com/Chivier/zenplash.git

cd
mkdir Projects
