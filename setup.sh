#!/usr/bin/env bash

# Exit on error
set -e

# Detect OS
current_os = ""
if [ -n "$WSL_DISTRO_NAME" ]; then
	current_os = "wsl"
elif [[ $(uname) = "Darwin" ]]; then
	current_os = "mac"
elif [ "$(uname)" = "Linux" ]; then
	current_os="linux"
else
	echo "current os not wsl/mac/linux existing..."
	exit 0
fi
echo "current os is $(current_os)"

#install devbox
export 
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
devbox global add xclip zsh --exclude-platform aarch64-darwin,aarch-64-linux
if [ "$current_os" != "wsl" ];
	devbox global add ghostty
fi
devbox global install
devbox global update

#stow files
echo "setting up symlinks with stow..."
stow --adopt */
git restore .

#source .inboundrc from .zshrc
echo "adding ~/.ibmshellrc to zsh and bash rc files..."
touch ~/.zshrc
if ! grep -q "\\[ -f ~/.ibmshellrc \\] && source ~/.ibmshellrc" ~/.zshrc; then
    echo "Adding source line to ~/.zshrc"
    echo '[ -f ~/.ibmshellrc ] && source ~/.ibmshellrc' >> ~/.zshrc
fi

#source .inboundrc from .bashrc
touch ~/.bashrc
if ! grep -q "\\[ -f ~/.ibmshellrc \\] && source ~/.ibmshellrc" ~/.bashrc; then
   echo "Adding source line to ~/.bashrc"
   echo '[ -f ~/.ibmshellrc ] && source ~/.ibmshellrc' >> ~/.bashrc
fi

#restart shell
echo 'restarting shell...'
if [ -n "$ZSH_VERSION" ]; then
    exec zsh
elif [ -n "$BASH_VERSION" ]; then
    exec bash
else
    echo "Unknown shell. may not work outside zsh and bash. restart to try."
fi

#set git in wsl to use windows ssh for 1password
if [ "$current_os" = "wsl" ]; then
	git config --global core.sshCommand ssh.exe
fi

#posh setup
oh-my-posh font install meslo

#zsh setup
if [ "$current_os" != "osx" ]; then
	#add devbox to shell list
	DEVBOX_ZSH=$(which zsh)
	if ! grep -q "$DEVBOX_ZSH" /etc/shells; then
		echo "$DEVBOX_ZSH" | sudo tee -a /etc/shells
	fi
	# Set devbox's zsh as default shell
	chsh -s "$DEVBOX_ZSH"
	# launch zsh
	exec "$DEVBOX_ZSH"
fi

#setup 1password cli
if [ -n "$WSL_DISTRO_NAME" ]; then
    echo "WSL detected..."
    if [ $(op account list 2>/dev/null | wc -l) -eq 0 ]; then
        echo "setting up 1password account"
	op account add --address my.1password.com --signin
    else
        echo "1Password account already set up"
    fi
else
    op vault list 	
fi

