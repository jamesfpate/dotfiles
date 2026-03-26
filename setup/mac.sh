#!/usr/bin/env bash

set -e

echo "================================"
echo " Mac Bootstrap"
echo "================================"

# Derive dotfiles root from script location (this script lives in setup/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
echo "Dotfiles: $DOTFILES_DIR"

# ── Mise ─────────────────────────────────────────────────────────────────────

echo ""
echo "→ Installing mise..."
if ! command -v mise &>/dev/null; then
  curl https://mise.run | sh
fi

export PATH="$HOME/.local/bin:$PATH"
eval "$(mise activate bash)"

# ── Chezmoi + dotfiles ───────────────────────────────────────────────────────

echo ""
echo "→ Installing chezmoi..."
if ! command -v chezmoi &>/dev/null; then
  mise use -g chezmoi@latest
  eval "$(mise activate bash)"
fi

echo "→ Applying dotfiles from $DOTFILES_DIR..."
chezmoi init --apply --source "$DOTFILES_DIR"

# Install node first (needed for npm-based tools like claude-code)
echo ""
echo "→ Installing node..."
mise install node
eval "$(mise activate bash)"

# Install remaining mise tools
echo ""
echo "→ Installing mise tools..."
mise install

# ── Homebrew ─────────────────────────────────────────────────────────────────

echo ""
echo "→ Installing Homebrew..."
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ── 1Password CLI ────────────────────────────────────────────────────────────

echo ""
echo "→ Installing 1Password CLI..."
if ! command -v op &>/dev/null; then
  brew install --cask 1password-cli
fi

# ── Shell Color Scripts ──────────────────────────────────────────────────────

echo ""
echo "→ Installing shell-color-scripts..."
if ! command -v colorscript &>/dev/null; then
  git clone --depth=1 https://gitlab.com/dwt1/shell-color-scripts.git /tmp/shell-color-scripts || \
    git clone --depth=1 https://github.com/Misairuzame/shell-color-scripts.git /tmp/shell-color-scripts
  cd /tmp/shell-color-scripts
  sudo make install
  cd -
  rm -rf /tmp/shell-color-scripts
fi

# ── Fonts ────────────────────────────────────────────────────────────────────

echo ""
echo "→ Installing Meslo Nerd Font..."
oh-my-posh font install meslo

# ── Done ─────────────────────────────────────────────────────────────────────

echo ""
echo "================================"
echo " Setup complete!"
echo "================================"
echo ""
echo "Next steps:"
echo "  1. Open a new terminal (or: exec zsh)"
echo ""
echo "Installed:"
mise current
