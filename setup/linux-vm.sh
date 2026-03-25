#!/usr/bin/env bash

set -e

echo "================================"
echo " Linux VM Bootstrap"
echo "================================"

# Derive dotfiles root from script location (this script lives in setup/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
echo "Dotfiles: $DOTFILES_DIR"

# ── System packages ──────────────────────────────────────────────────────────

echo ""
echo "→ Installing system packages..."
sudo apt update -qq
sudo apt install -y \
  curl \
  git \
  zsh \
  xvfb \
  xclip \
  build-essential

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
chezmoi init --source "$DOTFILES_DIR"
chezmoi apply --force

# Re-activate mise to pick up tools installed by chezmoi run_once scripts
eval "$(mise activate bash)"

# ── Playwright ────────────────────────────────────────────────────────────────

echo ""
echo "→ Installing Playwright browser dependencies..."
npx playwright install chromium 2>/dev/null || true
sudo npx playwright install-deps chromium 2>/dev/null || true

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
