# Dotfiles

My personal dotfiles for macOS. Includes configurations for:

- **Zsh** with Oh My Zsh, Powerlevel10k, and Homebrew-managed plugins
- **Git** settings
- **SSH** config
- **Zed** editor
- **GitHub CLI**
- **Homebrew** packages and casks

## Quick Start

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
```
# Run the install script
cd ~/dotfiles
./install.sh
```

## What's Included

| Directory | Description |
|-----------|-------------|
| `zsh/` | Zsh configuration with aliases, plugins, and Powerlevel10k |
| `git/` | Git config with user settings and LFS |
| `ssh/` | SSH client configuration |
| `zed/` | Zed editor settings and keybindings |
| `gh/` | GitHub CLI configuration |
| `Brewfile` | Homebrew packages, casks, and VS Code extensions |

## Manual Steps After Install

1. Generate SSH keys: `ssh-keygen -t ed25519 -C "your@email.com"`
2. Add SSH key to GitHub: `gh ssh-key add ~/.ssh/id_ed25519.pub`
3. Update API keys in `~/.config/zed/settings.json`
4. Ensure Homebrew installs `zsh-autosuggestions` and `zsh-syntax-highlighting` (already listed in the Brewfile)
5. Sign into apps (Raycast, 1Password, etc.)

## Updating

To update the Brewfile after installing new packages:

```bash
brew bundle dump --file=~/dotfiles/Brewfile --force
```

## Key Features

- **Lazy-loaded NVM** for faster shell startup
- **Zoxide** for smarter directory navigation (`z` instead of `cd`)
- **Eza** for better `ls` output with icons
- **Powerlevel10k** Pure-style prompt
- **Safety aliases** for `rm`, `mv`, `cp` (interactive mode)
