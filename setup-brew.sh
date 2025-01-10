#!/bin/bash

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to both .bashrc and .zshrc
BREW_ENV='eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'

# Add to .bashrc if it exists and doesn't already have brew
if [ -f "$HOME/.bashrc" ] && ! grep -q "brew shellenv" "$HOME/.bashrc"; then
    echo "$BREW_ENV" >> "$HOME/.bashrc"
fi

# Add to .zshrc if it exists and doesn't already have brew
if [ -f "$HOME/.zshrc" ] && ! grep -q "brew shellenv" "$HOME/.zshrc"; then
    echo "$BREW_ENV" >> "$HOME/.zshrc"
fi

# Evaluate Homebrew environment in current session
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Verify brew is now in path
if ! command -v brew &> /dev/null; then
    echo "Error: brew is still not available in PATH after sourcing"
    exit 1
fi

# Install build essentials
sudo apt-get install build-essential

# Install gcc through brew
brew install gcc
