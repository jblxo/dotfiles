# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME not needed - using Powerlevel10k sourced directly below
CASE_SENSITIVE="true"
ENABLE_CORRECTION="false"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  docker
  npm
  macos
)

source $ZSH/oh-my-zsh.sh

# -------
# Aliases
# -------
alias l="ls" # List files in current directory
alias ll="ls -al" # List all files in current directory in long list format
alias o="open ." # Open the current directory in Finder

# Safety aliases
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

# ----------------------
# Git Aliases
# ----------------------
alias gaa='git add .'
alias gcm='git commit -m'
alias gpsh='git push'
alias gss='git status -s'
alias gs='echo ""; echo "*********************************************"; echo -e "   DO NOT FORGET TO PULL BEFORE COMMITTING"; echo "*********************************************"; echo ""; git status'

# nvm - lazy loaded for faster shell startup
lazy_nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}
nvm() { lazy_nvm; nvm "$@"; }
node() { lazy_nvm; node "$@"; }
npm() { lazy_nvm; npm "$@"; }
npx() { lazy_nvm; npx "$@"; }

# JAVA
# ----------------------
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home

# Android Studio
# ----------------------
export ANDROID_HOME=$HOME/Library/Android/sdk

# Lazygit
# ----------------------
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

HISTFILE=$HOME/.zhistory
SAVEHIST=50000
HISTSIZE=50000
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify

# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ---- Eza (better ls) -----
alias ls="eza --icons=always"

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"

alias cd="z"

# ---- FutureLife ------
alias fdb="ssh -L 3306:fl-inf-dev-euw1-rds-01.c3wuypq7olkk.eu-west-1.rds.amazonaws.com:3306 ubuntu@54.155.32.133"
alias smx="ssh -L 5034:10.11.22.5:8081 ubuntu@54.155.32.133"
alias futurelife-dev='ssh -L 3306:fl-inf-dev-euw1-rds-01.c3wuypq7olkk.eu-west-1.rds.amazonaws.com:3306 -L 5034:10.11.22.5:8081 ubuntu@54.155.32.133'

# ---- Python ------
alias python="python3"
alias pip="pip3"

# pnpm
export PNPM_HOME="/Users/ondrejhliba/Library/pnpm"
# pnpm end

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
eval "$(rbenv init - zsh)"
export LC_ALL=en_US.UTF-8

# DBngin exports
export MYSQL_UNIX_PORT=/tmp/mysql_3306.sock

# ----------------------
# Functions
# ----------------------
# Create directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1"; }

export EDITOR="zed --wait"

# ----------------------
# Consolidated PATH
# ----------------------
path=(
  $PNPM_HOME
  $ANDROID_HOME/emulator
  $ANDROID_HOME/platform-tools
  /usr/local/opt/go/libexec/bin
  ~/go/bin
  /Users/Shared/DBngin/mysql/8.0.33/bin
  "/Users/ondrejhliba/.antigravity/antigravity/bin"
  $path
)
