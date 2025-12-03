# shellcheck disable=SC1091
if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
  echo "[dotfiles] zsh-syntax-highlighting not found; install via Homebrew."
fi
