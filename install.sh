#!/bin/bash
# Dotfiles installation script
# Creates symbolic links for all configuration files
#
# Usage:
#   ./install.sh          # Install all
#   ./install.sh nvim     # Install only nvim
#   ./install.sh tmux bash # Install tmux and bash

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Backup existing files
backup_if_exists() {
    if [ -e "$1" ] && [ ! -L "$1" ]; then
        echo -e "  ${YELLOW}Backing up${NC} $1 -> $1.backup"
        mv "$1" "$1.backup"
    elif [ -L "$1" ]; then
        echo -e "  ${YELLOW}Removing symlink${NC} $1"
        rm "$1"
    fi
}

# Copy template if target doesn't exist
copy_template() {
    if [ ! -f "$2" ]; then
        echo -e "  ${GREEN}Creating${NC} $2 from template"
        cp "$1" "$2"
    else
        echo -e "  ${YELLOW}Skipping${NC} $2 (already exists)"
    fi
}

# Install functions
install_nvim() {
    echo -e "${GREEN}[nvim]${NC} Installing Neovim config..."
    mkdir -p ~/.config
    backup_if_exists ~/.config/nvim
    ln -sf "$DOTFILES_DIR/nvim" ~/.config/nvim
    echo "  Linked: ~/.config/nvim"
}

install_tmux() {
    echo -e "${GREEN}[tmux]${NC} Installing tmux config..."
    mkdir -p ~/.config
    backup_if_exists ~/.config/tmux
    ln -sf "$DOTFILES_DIR/tmux" ~/.config/tmux
    echo "  Linked: ~/.config/tmux"
}

install_bash() {
    echo -e "${GREEN}[bash]${NC} Installing bash config..."
    backup_if_exists ~/.bashrc
    backup_if_exists ~/.bash_profile
    backup_if_exists ~/.bash_aliases
    ln -sf "$DOTFILES_DIR/bash/bashrc" ~/.bashrc
    ln -sf "$DOTFILES_DIR/bash/bash_profile" ~/.bash_profile
    ln -sf "$DOTFILES_DIR/bash/bash_aliases" ~/.bash_aliases
    echo "  Linked: ~/.bashrc, ~/.bash_profile, ~/.bash_aliases"

    # Environment variables template
    copy_template "$DOTFILES_DIR/bash/env.template" ~/.env.local
}

install_git() {
    echo -e "${GREEN}[git]${NC} Installing git config..."
    backup_if_exists ~/.gitconfig
    ln -sf "$DOTFILES_DIR/git/gitconfig" ~/.gitconfig
    copy_template "$DOTFILES_DIR/git/gitconfig.local.template" ~/.gitconfig.local
    echo "  Linked: ~/.gitconfig"
}

install_ssh() {
    echo -e "${GREEN}[ssh]${NC} SSH config template..."
    echo "  Template: $DOTFILES_DIR/ssh/config.template"
    echo "  Run: cp $DOTFILES_DIR/ssh/config.template ~/.ssh/config"
}

install_fzf() {
    echo -e "${GREEN}[fzf]${NC} Installing fzf..."

    # Install fzf if not installed
    if ! command -v fzf &> /dev/null; then
        read -p "  fzf is not installed. Install now? [y/N] " answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            if [ ! -d ~/.fzf ]; then
                echo "  Cloning fzf..."
                git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
            fi
            echo "  Running fzf installer..."
            ~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-zsh --no-fish
        else
            echo "  Skipped fzf installation"
        fi
    else
        echo "  fzf already installed"
    fi

    # Install zoxide if not installed
    if ! command -v zoxide &> /dev/null; then
        read -p "  zoxide is not installed. Install now? [y/N] " answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            echo "  Installing zoxide..."
            curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
        else
            echo "  Skipped zoxide installation"
        fi
    else
        echo "  zoxide already installed"
    fi

    # Link config
    mkdir -p ~/.config/fzf
    backup_if_exists ~/.config/fzf/fzf.bash
    ln -sf "$DOTFILES_DIR/fzf/fzf.bash" ~/.config/fzf/fzf.bash
    echo "  Linked: ~/.config/fzf/fzf.bash"
}

check_tools() {
    echo -e "${GREEN}[check]${NC} Checking required tools..."
    local missing=0
    check_tool() {
        if command -v "$1" &> /dev/null; then
            echo -e "  ${GREEN}[OK]${NC} $1"
        else
            echo -e "  ${RED}[MISSING]${NC} $1 - $2"
            missing=1
        fi
    }
    check_tool "nvim" "https://neovim.io/"
    check_tool "tmux" "sudo apt install tmux"
    check_tool "rg" "sudo apt install ripgrep"
    check_tool "fdfind" "sudo apt install fd-find"
    check_tool "fzf" "git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install"
    check_tool "zoxide" "curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh"
    return $missing
}

show_help() {
    echo "Usage: $0 [component...]"
    echo ""
    echo "Components:"
    echo "  nvim    Neovim configuration"
    echo "  tmux    tmux configuration"
    echo "  bash    Bash configuration (bashrc, bash_profile, bash_aliases, env)"
    echo "  git     Git configuration"
    echo "  ssh     SSH configuration template"
    echo "  fzf     fzf configuration"
    echo "  check   Check required tools"
    echo "  all     Install all components (default)"
    echo ""
    echo "Examples:"
    echo "  $0              # Install all"
    echo "  $0 nvim         # Install only nvim"
    echo "  $0 nvim tmux    # Install nvim and tmux"
    echo "  $0 check        # Check tools only"
}

# Main
echo "=== Dotfiles Installation ==="
echo "Source: $DOTFILES_DIR"
echo ""

# Parse arguments
if [ $# -eq 0 ]; then
    components="all"
else
    components="$*"
fi

# Handle help
if [[ "$components" == *"help"* ]] || [[ "$components" == *"-h"* ]]; then
    show_help
    exit 0
fi

# Install requested components
for component in $components; do
    case $component in
        nvim)  install_nvim ;;
        tmux)  install_tmux ;;
        bash)  install_bash ;;
        git)   install_git ;;
        ssh)   install_ssh ;;
        fzf)   install_fzf ;;
        check) check_tools ;;
        all)
            install_nvim
            install_tmux
            install_bash
            install_git
            install_ssh
            install_fzf
            check_tools
            ;;
        *)
            echo -e "${RED}Unknown component:${NC} $component"
            show_help
            exit 1
            ;;
    esac
    echo ""
done

echo "=== Done ==="
echo ""
echo "Next steps:"
echo "  1. Edit ~/.env.local (environment variables)"
echo "  2. Edit ~/.gitconfig.local (git user info)"
echo "  3. Restart shell: source ~/.bashrc"
