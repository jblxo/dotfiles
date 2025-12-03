# shellcheck disable=SC1091
if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
else
  echo "[dotfiles] zsh-autosuggestions not found; install via Homebrew."
fi
