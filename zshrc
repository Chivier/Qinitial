# Stop auto update
DISABLE_AUTO_UPDATE="true"

# ── Path ─────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/.local/lib:/usr/local/lib:$LD_LIBRARY_PATH"

# ── Oh My Zsh ────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

ZSH_THEME="chivier"
plugins=(git colored-man-pages vi-mode zenplash docker docker-compose)
source "$ZSH/oh-my-zsh.sh"

# ── Zinit ────────────────────────────────────────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME/.git" ]]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl

zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit load zdharma-continuum/history-search-multi-word
zinit load zsh-users/zsh-history-substring-search

# ── Aliases ──────────────────────────────────────────────────────────────────
alias lll="cd ~/Projects"

# ── Vim mode ─────────────────────────────────────────────────────────────────
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^[OQ" edit-command-line
export EDITOR=/usr/bin/vim

# ── Pyenv ────────────────────────────────────────────────────────────────────
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
if command -v pyenv &>/dev/null; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# ── NVM ──────────────────────────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ]             && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ]    && \. "$NVM_DIR/bash_completion"

# ── uv ───────────────────────────────────────────────────────────────────────
if command -v uv &>/dev/null; then
    eval "$(uv generate-shell-completion zsh)"
    eval "$(uvx --generate-shell-completion zsh)"
fi
