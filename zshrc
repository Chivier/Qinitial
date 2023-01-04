# Stop auto update
DISABLE_AUTO_UPDATE="true"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export LD_LIBRARY_PATH=$HOME/.local/lib:/usr/local/lib:$LD_LIBRARY_PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export LANG="en_US.utf8"
export LC_CTYPE="zh_CN.utf8"
export LC_ALL="en_US.utf8"

# local env variables
# THEME
ZSH_THEME="chivier"
plugins=(git colored-man-pages vi-mode zshmarks zenplash)
source $ZSH/oh-my-zsh.sh

# Intel Compilers
alias sourceintel='source /opt/intel/oneapi/setvars.sh'

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-bin-gem-node

zinit light zsh-users/zsh-autosuggestions
zinit light zdharma/fast-syntax-highlighting

# Plugin history-search-multi-word loaded with investigating.
zinit load zdharma/history-search-multi-word
zinit load zsh-users/zsh-history-substring-search

# A glance at the new for-syntax – load all of the above
# plugins with a single command. For more information see:
# https://zdharma.org/zinit/wiki/For-Syntax/
zinit for \
    light-mode  zsh-users/zsh-autosuggestions \
    light-mode  zdharma/fast-syntax-highlighting \
                zdharma/history-search-multi-word 
### End of Zinit's installer chunk

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

# My aliases

#Frequently used files or folders
alias lll="cd ~/Projects"

# Quick Update & Upgrade
alias update="sudo apt update"
alias upgrade="sudo apt-get upgrade"
alias upug="update && upgrade"

# Better color theme
# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
# Man Pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# Vim mode
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^[OQ" edit-command-line
export EDITOR=/usr/bin/vim

# Pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH=$PYENV_ROOT/shims:$PATH
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Cmake
export PATH="$HOME/opt/cmake/chver/bin:$PATH"

# LLVM
export PATH="$HOME/opt/llvm/chver/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/opt/llvm/chver/lib:$LD_LIBRARY_PATH"
export LLVM_INCLUDE_PATH="$HOME/opt/llvm/chver/include"

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Lazygit
alias lg="lazygit"

# ShowMarks
alias g="jump"
# alias s="bookmark"
# alias d="deletemark"
alias p="showmarks"

