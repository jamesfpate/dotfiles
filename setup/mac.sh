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

# Re-activate mise to pick up tools installed by chezmoi run_once scripts
eval "$(mise activate bash)"

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
