#!/usr/bin/env bash

# Exit on error
set -eu

# Detect OS
current_os=""
if [ -n "$WSL_DISTRO_NAME" ]; then
	current_os="wsl"
elif [[ "$(uname)" = "Darwin" ]]; then
	current_os="mac"
elif [ "$(uname)" = "Linux" ]; then
	current_os="linux"
else
	echo "current os not wsl/mac/linux existing..."
	exit 0
fi
echo "current os is $current_os"

#install devbox
if command -v devbox &> /dev/null; then
    echo "devbox is installed"
    devbox version
else
    echo "installing devbox"
    curl -fsSL https://get.jetify.com/devbox | bash
    eval "$(devbox global shellenv)"
fi

#devbox setup
echo "installing devbox packages..."
devbox global add _1password git go-task jq lsd neovim oh-my-posh python@3.11 stow zellij 
devbox global add xclip zsh --exclude-platform aarch64-darwin,x86_64-darwin
if [ "$current_os" != "wsl" ]; then
	devbox global add ghostty
fi
devbox global install
devbox global update

#stow files
echo "setting up symlinks with stow..."
stow --adopt */
git restore .

#posh setup
oh-my-posh font install meslo

#source .inboundrc from .zshrc
echo "adding ~/.shellrc to zsh and bash rc files..."
touch ~/.zshrc
if ! grep -q "\[ -f ~/.shellrc \] && source ~/.shellrc" ~/.zshrc; then
    echo "Adding source line to ~/.zshrc"
    echo '[ -f ~/.shellrc ] && source ~/.shellrc' >> ~/.zshrc
fi

#source .inboundrc from .bashrc
touch ~/.bashrc
if ! grep -q "\[ -f ~/.shellrc \] && source ~/.shellrc" ~/.bashrc; then
   echo "Adding source line to ~/.bashrc"
   echo '[ -f ~/.shellrc ] && source ~/.shellrc' >> ~/.bashrc
fi

#restart shell
echo 'sourcing shell config...'
if [ -n "$ZSH_VERSION" ]; then
	source ~/.zshrc
elif [ -n "$BASH_VERSION" ]; then
	source ~/.bashrc
else
    echo "Unknown shell. may not work outside zsh and bash. restart to try."
fi

#set git ssh to 1password in wsl
echo 'setting ssh to 1password in wsl'
if [ "$current_os" = "wsl" ]; then
	git config --global core.sshCommand ssh.exe
fi

#zsh setup
if [ "$current_os" != "mac" ]; then
	#add devbox to shell list
	DEVBOX_ZSH=$(which zsh)
	if ! grep -q "$DEVBOX_ZSH" /etc/shells; then
		echo "$DEVBOX_ZSH" | sudo tee -a /etc/shells
	fi
	# Set devbox's zsh as default shell
	chsh -s "$DEVBOX_ZSH"
fi

#setup 1password cli
if [ "$current_os" = "wsl" ]; then
    echo "setting up 1password in wsl..."
    if ! op account list | grep -q "my.1password.com" 2>/dev/null; then
        echo "setting up 1password account"
        if ! op account add --address my.1password.com --signin; then
            echo "Failed to add 1Password account"
            exit 1
        fi
    else
        echo "1Password account already set up"
    fi
else
    op vault list || echo "Error: Could not list 1Password vaults"
fi
