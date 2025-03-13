#!/usr/bin/env bash

# Exit on error
set -e

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


#current shell
current_shell=$(basename "$SHELL")
echo "Current shell: $current_shell"


#devbox setup
echo "installing devbox packages..."
devbox global add _1password git go-task jq lsd neovim oh-my-posh python@3.13 stow zellij 
#non mac
devbox global add xclip zsh --exclude-platform aarch64-darwin,x86_64-darwin
#update/install devbox packages
devbox global install
devbox global update

#refresh-global
echo "running refresh-global"
eval "$(devbox global shellenv --preserve-path-stack -r)" && hash -r

#list installed global packages
echo "devbox global packages:"
devbox global list

#stow setup
echo "check if stow avaiable"
which stow

#stow files
echo "setting up symlinks with stow..."
cd symlinks/
stow --restow --adopt --target ~ --verbose --no-folding */
git restore .
cd ..

#posh setup
echo "installing fonts..."
oh-my-posh font install meslo

#source .shellrc from .zshrc
echo "adding ~/.shellrc to zsh and bash rc files..."
touch ~/.zshrc
if ! grep -q "\[ -f ~/.shellrc \] && source ~/.shellrc" ~/.zshrc; then
    echo "Adding source line to ~/.zshrc"
    echo "" >> ~/.zshrc
    echo '[ -f ~/.shellrc ] && source ~/.shellrc' >> ~/.zshrc
fi

#source .shellrc from .bashrc
touch ~/.bashrc
if ! grep -q "\[ -f ~/.shellrc \] && source ~/.shellrc" ~/.bashrc; then
   echo "Adding source line to ~/.bashrc"
   echo "" >> ~/.bashrc
   echo '[ -f ~/.shellrc ] && source ~/.shellrc' >> ~/.bashrc
fi

#set git ssh to 1password in wsl
if [ "$current_os" = "wsl" ]; then
	echo 'setting ssh to 1password in wsl'
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
