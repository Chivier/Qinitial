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

step "Installing Docker"
if ! command -v docker &>/dev/null; then
    $SUDO apt-get install -y ca-certificates curl
    $SUDO install -m 0755 -d /etc/apt/keyrings
    $SUDO curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
        -o /etc/apt/keyrings/docker.asc
    $SUDO chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
        | $SUDO tee /etc/apt/sources.list.d/docker.list >/dev/null
    $SUDO apt-get update -y
    $SUDO apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    $SUDO usermod -aG docker "$USER"
    info "Docker installed (re-login required for group membership)"
else
    warn "Docker already installed, skipping"
fi

step "Installing docker-compose (standalone)"
if ! command -v docker-compose &>/dev/null; then
    COMPOSE_VERSION=$(curl -s "https://api.github.com/repos/docker/compose/releases/latest" \
        | grep -Po '"tag_name": "v\K[^"]*')
    $SUDO curl -SL \
        "https://github.com/docker/compose/releases/download/v${COMPOSE_VERSION}/docker-compose-linux-$(uname -m)" \
        -o /usr/local/bin/docker-compose
    $SUDO chmod +x /usr/local/bin/docker-compose
    info "docker-compose ${COMPOSE_VERSION} installed"
else
    warn "docker-compose already installed, skipping"
fi

info "All prerequisites installed. Run basic.sh next."
