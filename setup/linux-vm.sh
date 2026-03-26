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

# ── 1Password CLI ────────────────────────────────────────────────────────────

echo ""
echo "→ Installing 1Password CLI..."
if ! command -v op &>/dev/null; then
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
    sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
    sudo tee /etc/apt/sources.list.d/1password.list
  sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
  curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
    sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
  sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
    sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
  sudo apt update -qq && sudo apt install -y 1password-cli
fi

# ── Shell Color Scripts ──────────────────────────────────────────────────────

echo ""
echo "→ Installing shell-color-scripts..."
if ! command -v colorscript &>/dev/null; then
  git clone https://gitlab.com/dwt1/shell-color-scripts.git /tmp/shell-color-scripts
  cd /tmp/shell-color-scripts
  sudo make install
  cd -
  rm -rf /tmp/shell-color-scripts
fi

# ── Fonts ────────────────────────────────────────────────────────────────────

echo ""
echo "→ Installing Meslo Nerd Font..."
oh-my-posh font install meslo

# ── Playwright ────────────────────────────────────────────────────────────────

echo ""
echo "→ Installing Playwright browser dependencies..."
npx playwright install chromium 2>/dev/null || true
sudo npx playwright install-deps chromium 2>/dev/null || true

# ── Auto-updates ─────────────────────────────────────────────────────────────

echo ""
echo "→ Setting up automatic updates..."

# apt: unattended-upgrades for system packages
sudo apt install -y unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades

# mise: nightly cron job for mise self-update + tool upgrades
MISE_CRON="0 3 * * * $HOME/.local/bin/mise self-update --yes 2>/dev/null; $HOME/.local/bin/mise upgrade --yes 2>/dev/null"
(crontab -l 2>/dev/null | grep -v "mise"; echo "$MISE_CRON") | crontab -

# ── Set zsh as default shell ─────────────────────────────────────────────────

echo ""
echo "→ Setting zsh as default shell..."
ZSH_PATH="$(which zsh)"
if ! grep -q "$ZSH_PATH" /etc/shells; then
  echo "$ZSH_PATH" | sudo tee -a /etc/shells
fi
chsh -s "$ZSH_PATH"

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
