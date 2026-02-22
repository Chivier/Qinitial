#!/bin/bash
# Qinitial - Main Setup (no sudo required)
# Run after req.sh (or on a system with packages already installed)

set -e

QINDIR="$(cd "$(dirname "$0")" && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; exit 1; }
step()  { echo -e "\n${BLUE}==>${NC} $1"; }

# ── Directories ──────────────────────────────────────────────────────────────
step "Setting up directories"
mkdir -p "$HOME/.local/"{bin,lib,share}
mkdir -p "$HOME/opt"
mkdir -p "$HOME/Projects"
info "Directories ready"

# ── Oh My Zsh ────────────────────────────────────────────────────────────────
step "Oh My Zsh"
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    # KEEP_ZSHRC=yes: don't overwrite existing .zshrc
    # RUNZSH=no: don't start zsh after install
    # CHSH=no: don't change default shell automatically
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
        sh -c "$(wget -O- https://install.ohmyz.sh/)"
    info "Oh My Zsh installed"
else
    warn "Oh My Zsh already installed, skipping"
fi

# chivier theme
step "Chivier zsh theme"
mkdir -p "$HOME/.oh-my-zsh/custom/themes"
cp "$QINDIR/chivier.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/chivier.zsh-theme"
info "Chivier theme installed"

# zenplash plugin
step "Zenplash plugin"
mkdir -p "$HOME/.oh-my-zsh/custom/plugins"
rm -rf "$HOME/.oh-my-zsh/custom/plugins/zenplash"
git clone https://github.com/Chivier/zenplash.git \
    "$HOME/.oh-my-zsh/custom/plugins/zenplash"
info "Zenplash plugin installed"

# ── Zinit ────────────────────────────────────────────────────────────────────
step "Zinit plugin manager"
ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    info "Zinit installed"
else
    warn "Zinit already installed, skipping"
fi

# ── zshrc ────────────────────────────────────────────────────────────────────
step "Zsh configuration"
if [[ ! -e "$HOME/.zshrc" ]]; then
    cp "$QINDIR/zshrc" "$HOME/.zshrc"
    info "zshrc installed"
else
    warn "~/.zshrc already exists — skipping automatic install"
    echo "  To reinstall: cp $QINDIR/zshrc ~/.zshrc"
fi

# ── Rust ─────────────────────────────────────────────────────────────────────
step "Rust (rustup)"
if [[ ! -d "$HOME/.cargo" ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    info "Rust installed"
else
    warn "Rust already installed, skipping"
fi

# ── uv ───────────────────────────────────────────────────────────────────────
step "uv (Python package manager)"
if ! command -v uv &>/dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    info "uv installed"
else
    warn "uv already installed, skipping"
fi

# ── Vim ──────────────────────────────────────────────────────────────────────
step "Vim runtime (amix/vimrc)"
if [[ ! -d "$HOME/.vim_runtime" ]]; then
    git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_basic_vimrc.sh
    info "Vim runtime installed"
else
    warn "Vim runtime already installed, skipping"
fi

# ── Neovim ───────────────────────────────────────────────────────────────────
step "Neovim"
if [[ ! -e "$HOME/.local/bin/nvim" ]]; then
    ARCH=$(uname -m)
    case "$ARCH" in
        x86_64)  NVIM_PKG="nvim-linux-x86_64" ;;
        aarch64) NVIM_PKG="nvim-linux-arm64"  ;;
        *)        error "Unsupported architecture: $ARCH" ;;
    esac
    cd "$HOME/opt"
    wget -q "https://github.com/neovim/neovim/releases/download/stable/${NVIM_PKG}.tar.gz"
    tar xf "${NVIM_PKG}.tar.gz"
    rsync -avhu "${NVIM_PKG}/bin/"   "$HOME/.local/bin/"
    rsync -avhu "${NVIM_PKG}/lib/"   "$HOME/.local/lib/"
    rsync -avhu "${NVIM_PKG}/share/" "$HOME/.local/share/"
    rm -rf "${NVIM_PKG}" "${NVIM_PKG}.tar.gz"
    cd "$QINDIR"
    info "Neovim installed"
else
    warn "Neovim already installed, skipping"
fi

if [[ -d "$HOME/.config/nvim" && ! -L "$HOME/.config/nvim" ]]; then
    mv "$HOME/.config/nvim" "$HOME/.config/nvim_backup_$(date +%Y%m%d_%H%M%S)"
    warn "Existing nvim config backed up"
fi
if [[ ! -e "$HOME/.config/nvim" ]]; then
    git clone https://github.com/Chivier/ChivierLazyNvim.git ~/.config/nvim
    info "Neovim config (ChivierLazyNvim) installed"
fi

# ── tmux ─────────────────────────────────────────────────────────────────────
step "tmux config (gpakosz/.tmux)"
if [[ ! -d "$HOME/.tmux" ]]; then
    cd "$HOME"
    git clone https://github.com/gpakosz/.tmux.git
    ln -sf .tmux/.tmux.conf .tmux.conf
    cp .tmux/.tmux.conf.local .
    cd "$QINDIR"
    info "tmux config installed"
else
    warn "tmux config already installed, skipping"
fi

# ── fzf ──────────────────────────────────────────────────────────────────────
step "fzf"
if [[ ! -d "$HOME/.fzf" ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-bash --no-fish
    info "fzf installed"
else
    warn "fzf already installed, skipping"
fi

# ── zellij ───────────────────────────────────────────────────────────────────
step "zellij"
if [[ ! -e "$HOME/.local/bin/zellij" ]]; then
    ZELLIJ_VERSION=$(curl -s "https://api.github.com/repos/zellij-org/zellij/releases/latest" \
        | grep -Po '"tag_name": "v\K[^"]*')
    cd "$HOME/opt"
    wget -q "https://github.com/zellij-org/zellij/releases/download/v${ZELLIJ_VERSION}/zellij-x86_64-unknown-linux-musl.tar.gz"
    tar xzf "zellij-x86_64-unknown-linux-musl.tar.gz" zellij
    chmod +x ./zellij
    mv zellij "$HOME/.local/bin/zellij"
    rm "zellij-x86_64-unknown-linux-musl.tar.gz"
    cd "$QINDIR"
    info "zellij installed"
else
    warn "zellij already installed, skipping"
fi

# ── lazygit ──────────────────────────────────────────────────────────────────
step "lazygit"
if [[ ! -e "$HOME/.local/bin/lg" ]]; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
        | grep -Po '"tag_name": "v\K[^"]*')
    cd "$HOME/opt"
    curl -Lo lazygit.tar.gz \
        "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    mv lazygit "$HOME/.local/bin/lg"
    rm lazygit.tar.gz
    cd "$QINDIR"
    info "lazygit installed as 'lg'"
else
    warn "lazygit already installed, skipping"
fi

# ── Symlinks ─────────────────────────────────────────────────────────────────
step "Tool symlinks (fd, bat)"
if [[ ! -e "$HOME/.local/bin/fd" ]] && command -v fdfind &>/dev/null; then
    ln -s "$(which fdfind)" "$HOME/.local/bin/fd"
    info "fd symlink created"
fi
if [[ ! -e "$HOME/.local/bin/bat" ]] && [[ -e /usr/bin/batcat ]]; then
    ln -s /usr/bin/batcat "$HOME/.local/bin/bat"
    info "bat symlink created"
fi

# ── NVM & Node.js ────────────────────────────────────────────────────────────
step "NVM (Node Version Manager)"
if [[ ! -d "$HOME/.nvm" ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    info "NVM installed"
else
    warn "NVM already installed, skipping"
fi

# Load nvm in current shell so we can use it immediately
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

step "Node.js LTS"
nvm install --lts
nvm use --lts
info "Node.js LTS installed: $(node --version)"

# ── Claude Code ──────────────────────────────────────────────────────────────
step "Claude Code"
curl -fsSL https://claude.ai/install.sh | bash
info "Claude Code installed"

# ── NPM Global Packages ──────────────────────────────────────────────────────
step "OpenAI Codex CLI"
npm install -g @openai/codex
info "OpenAI Codex installed"

step "Google Gemini CLI"
npm install -g @google/gemini-cli
info "Google Gemini CLI installed"

step "Task Master AI"
npm install -g task-master-ai
info "Task Master AI installed"

step "Claude Code UI"
npm install -g https://github.com/siteboon/claudecodeui
info "Claude Code UI installed"

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║        Setup complete!                ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════╝${NC}"
echo ""
echo "Next steps:"
echo "  1. Set zsh as default shell: chsh -s \$(which zsh)"
echo "  2. Restart terminal or run:  exec zsh"
echo "  3. On first zsh launch, zinit will auto-install plugins"
