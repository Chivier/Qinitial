#!/bin/bash
# Qinitial - Prerequisites (requires sudo)
# Run this first on a fresh system

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; exit 1; }
step()  { echo -e "\n${BLUE}==>${NC} $1"; }

if [[ $EUID -eq 0 ]]; then
    SUDO=""
else
    SUDO="sudo"
    command -v sudo &>/dev/null || error "sudo not found. Run as root or install sudo."
fi

step "Updating apt"
$SUDO apt-get update -y

step "Installing base packages"
$SUDO apt-get install -y \
    zsh wget curl git build-essential rsync \
    vim tmux htop silversearcher-ag

step "Installing extended tools"
$SUDO apt-get install -y \
    fd-find bat \
    libssl-dev libbz2-dev libreadline-dev \
    libsqlite3-dev liblzma-dev libffi-dev

step "Installing GitHub CLI"
if ! command -v gh &>/dev/null; then
    $SUDO mkdir -p -m 755 /etc/apt/keyrings
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | $SUDO tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
    $SUDO chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] \
https://cli.github.com/packages stable main" \
        | $SUDO tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    $SUDO apt-get update -y
    $SUDO apt-get install -y gh
    info "GitHub CLI installed"
else
    warn "GitHub CLI already installed, skipping"
fi

info "All prerequisites installed. Run basic.sh next."
