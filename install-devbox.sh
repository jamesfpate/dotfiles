#!/usr/bin/env bash

# Exit on error
set -e

# Detect OS
echo "detect os"
current_os=""
if [ -n "$WSL_DISTRO_NAME" ]; then
	current_os="wsl"
elif [ "$(uname)" = "Darwin" ]; then
	current_os="mac"
elif [ "$(uname)" = "Linux" ]; then
	current_os="linux"
else
	echo "current os not wsl/mac/linux existing..."
	exit 0
fi
echo "current os is $current_os"

#current shell
current_shell=$(basename "$SHELL")
echo "Current shell: $current_shell"

#install devbox
if command -v devbox &> /dev/null; then
    echo "devbox is installed"
    devbox version
else
    echo "installing devbox"
    curl -fsSL https://get.jetify.com/devbox | bash
fi

#add devbox shell hooks
echo "adding devbox shell hooks"
# For .zshrc
touch ~/.zshrc
if [[ $(head -n1 ~/.zshrc 2>/dev/null) != 'eval "$(devbox global shellenv --init-hook)"' ]]; then
    echo 'eval "$(devbox global shellenv --init-hook)"' | cat - ~/.zshrc > temp && mv temp ~/.zshrc
fi

#refresh-global
echo "running refresh-global"
eval "$(devbox global shellenv --preserve-path-stack -r)" && hash -r

echo "devbox installed. Restart your shell and then run: bash setup.sh"
