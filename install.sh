#!/bin/bash

# Dotfiles installation script
# This script creates symlinks from the home directory to dotfiles in ~/dotfiles

set -e

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Create backup directory
backup_and_link() {
    local source="$1"
    local target="$2"
    
    if [ -e "$target" ] || [ -L "$target" ]; then
        mkdir -p "$BACKUP_DIR"
        warn "Backing up existing $target to $BACKUP_DIR/"
        mv "$target" "$BACKUP_DIR/"
    fi
    
    # Ensure parent directory exists
    mkdir -p "$(dirname "$target")"
    
    ln -sf "$source" "$target"
    info "Linked $source -> $target"
}

echo ""
echo "=================================="
echo "   Dotfiles Installation Script   "
echo "=================================="
echo ""

# Check if running from dotfiles directory
if [ ! -d "$DOTFILES_DIR" ]; then
    error "Dotfiles directory not found at $DOTFILES_DIR"
    error "Please clone the repository first:"
    echo "  git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles"
    exit 1
fi

# 1. Install Homebrew if not present
echo ""
info "Checking Homebrew..."
if ! command -v brew &> /dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [ -f "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    info "Homebrew already installed"
fi

# 2. Install packages from Brewfile
echo ""
info "Installing packages from Brewfile..."
if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    brew bundle --file="$DOTFILES_DIR/Brewfile" || warn "Some packages may have failed to install"
else
    warn "Brewfile not found, skipping package installation"
fi

# 3. Install Oh My Zsh if not present
echo ""
info "Checking Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    info "Oh My Zsh already installed"
fi

# 4. Install zsh plugins
info "Checking zsh plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

install_plugin_wrapper() {
    local name="$1"
    local source_path="$2"
    local target_dir="$3"

    mkdir -p "$target_dir"

    cat >"$target_dir/$name.plugin.zsh" <<EOF
# shellcheck disable=SC1091
if [ -f $source_path ]; then
  source $source_path
else
  echo "[dotfiles] $name not found; install via Homebrew."
fi
EOF

    info "Installed wrapper for $name"
}

install_plugin_wrapper "zsh-autosuggestions" "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" "$DOTFILES_DIR/zsh/custom/plugins/zsh-autosuggestions"
install_plugin_wrapper "zsh-syntax-highlighting" "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" "$DOTFILES_DIR/zsh/custom/plugins/zsh-syntax-highlighting"

# 5. Create symlinks
echo ""
info "Creating symlinks..."

# Zsh
backup_and_link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
backup_and_link "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"

# Git
backup_and_link "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

# SSH (be careful - don't overwrite keys!)
if [ -f "$DOTFILES_DIR/ssh/config" ]; then
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    backup_and_link "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"
    chmod 600 "$HOME/.ssh/config"
fi

# Zed
if [ -f "$DOTFILES_DIR/zed/settings.json" ]; then
    mkdir -p "$HOME/.config/zed"
    backup_and_link "$DOTFILES_DIR/zed/settings.json" "$HOME/.config/zed/settings.json"
    backup_and_link "$DOTFILES_DIR/zed/keymap.json" "$HOME/.config/zed/keymap.json"
fi

# GitHub CLI
if [ -f "$DOTFILES_DIR/gh/config.yml" ]; then
    mkdir -p "$HOME/.config/gh"
    backup_and_link "$DOTFILES_DIR/gh/config.yml" "$HOME/.config/gh/config.yml"
fi

# 6. Install NVM if not present
echo ""
info "Checking NVM..."
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    info "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
else
    info "NVM already installed"
fi

# 7. Set up macOS defaults (optional)
echo ""
read -p "Would you like to apply macOS defaults? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    info "Applying macOS defaults..."
    
    # Finder: show hidden files
    defaults write com.apple.finder AppleShowAllFiles -bool true
    
    # Finder: show path bar
    defaults write com.apple.finder ShowPathbar -bool true
    
    # Finder: show status bar
    defaults write com.apple.finder ShowStatusBar -bool true
    
    # Disable press-and-hold for keys in favor of key repeat
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
    
    # Set fast key repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 15
    
    # Save screenshots to Downloads
    defaults write com.apple.screencapture location -string "$HOME/Downloads"
    
    # Restart Finder to apply changes
    killall Finder || true
    
    info "macOS defaults applied!"
fi

echo ""
echo "=================================="
echo "   Installation Complete!         "
echo "=================================="
echo ""
info "Please restart your terminal or run: source ~/.zshrc"
echo ""
if [ -d "$BACKUP_DIR" ]; then
    warn "Your old dotfiles were backed up to: $BACKUP_DIR"
fi
echo ""
info "Don't forget to:"
echo "  1. Generate new SSH keys if needed: ssh-keygen -t ed25519"
echo "  2. Update API keys in ~/.config/zed/settings.json"
echo "  3. Log into apps and services"
echo ""
