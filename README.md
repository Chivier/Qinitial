# Qinitial

Quick initial setup for a fresh Linux environment.

## Usage

```bash
# 1. Install system dependencies (requires sudo)
bash sudo_install.sh

# 2. Install user environment (no sudo)
bash install.sh
```

## What gets installed

### `sudo_install.sh` (system packages)

| Package | Description |
|---------|-------------|
| zsh | Z shell |
| wget / curl | Download utilities |
| git | Version control |
| build-essential | GCC, make, etc. |
| rsync | File sync utility |
| vim / tmux / htop | Terminal tools |
| silversearcher-ag | Fast code search (ag) |
| fd-find | Fast file finder (fd) |
| bat | Better cat |
| GitHub CLI (`gh`) | GitHub CLI tool |
| libssl / libbz2 / libreadline / etc. | Python build dependencies |

### `install.sh` (user environment)

| Tool | Description |
|------|-------------|
| [Pyenv](https://github.com/pyenv/pyenv) | Python version manager |
| [uv](https://github.com/astral-sh/uv) | Fast Python package manager |
| [amix/vimrc](https://github.com/amix/vimrc) | Vim configuration |
| [Neovim](https://neovim.io) | Neovim + ChivierLazyNvim config |
| [gpakosz/.tmux](https://github.com/gpakosz/.tmux) | tmux configuration |
| [Oh My Zsh](https://ohmyz.sh) | Zsh framework |
| chivier.zsh-theme | Custom zsh theme |
| [zenplash](https://github.com/Chivier/zenplash) | Custom zsh plugin |
| [Zinit](https://github.com/zdharma-continuum/zinit) | Zsh plugin manager |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder |
| [zellij](https://zellij.dev) | Terminal multiplexer |
| [lazygit](https://github.com/jesseduffield/lazygit) | Git TUI (installed as `lg`) |
| [NVM](https://github.com/nvm-sh/nvm) | Node version manager |
| Node.js LTS | via `nvm install --lts` |
| [@openai/codex](https://www.npmjs.com/package/@openai/codex) | OpenAI Codex CLI |
| [@google/gemini-cli](https://www.npmjs.com/package/@google/gemini-cli) | Google Gemini CLI |
| [task-master-ai](https://www.npmjs.com/package/task-master-ai) | AI task management CLI |
| [claudecodeui](https://github.com/siteboon/claudecodeui) | Claude Code web UI |
| [Claude Code](https://claude.ai) | Anthropic Claude CLI |

## Files

| File | Description |
|------|-------------|
| `sudo_install.sh` | System package installer (requires sudo) |
| `install.sh` | User environment installer (no sudo) |
| `zshrc` | Zsh configuration template |
| `chivier.zsh-theme` | Custom Oh My Zsh theme |
