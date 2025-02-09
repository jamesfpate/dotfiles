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


#refresh shell
refresh_shell() {
    if [ "$current_shell" = "zsh" ]; then
	echo "sourcing zsh"
	    source ~/.zshrc
    elif [ "$current_shell" = "bash" ]; then
        echo "sourcing bash"
	    source ~/.bashrc
    else
        echo "Unsupported shell: $current_shell"
        return 1
    fi
}

#install devbox
if command -v devbox &> /dev/null; then
    echo "devbox is installed"
    devbox version
else
    echo "installing devbox"
    curl -fsSL https://get.jetify.com/devbox | bash
fi

#add devbox shell hooks
echo "adding zsh shell hook"
# For .zshrc
touch ~/.zshrc
if [[ $(head -n1 ~/.zshrc 2>/dev/null) != 'eval "$(devbox global shellenv --init-hook)"' ]]; then
    echo 'eval "$(devbox global shellenv --init-hook)"' | cat - ~/.zshrc > temp && mv temp ~/.zshrc
fi
echo "adding bash shell hook"
# For .bashrc
touch ~/.bashrc
if [[ $(head -n1 ~/.bashrc 2>/dev/null) != 'eval "$(devbox global shellenv --init-hook)"' ]]; then
    echo 'eval "$(devbox global shellenv --init-hook)"' | cat - ~/.bashrc > temp && mv temp ~/.bashrc
fi

#refresh shell
echo "refresh shell"
refresh_shell

#devbox setup
echo "installing devbox packages..."
devbox global add _1password git go-task jq lsd neovim oh-my-posh python@3.13 stow zellij 
#non mac
devbox global add xclip zsh --exclude-platform aarch64-darwin,x86_64-darwin
#wsl
if [ "$current_os" != "wsl" ]; then
	devbox global add github:ghostty-org/ghostty
fi
devbox global install
devbox global update
echo "devbox global packages:"
devbox global list

#stow setup
echo "check if stow avaiable"
which stow

#stow files
eval "$(devbox global shellenv --init-hook)"
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
    echo '[ -f ~/.shellrc ] && source ~/.shellrc' >> ~/.zshrc
fi

#source .shellrc from .bashrc
touch ~/.bashrc
if ! grep -q "\[ -f ~/.shellrc \] && source ~/.shellrc" ~/.bashrc; then
   echo "Adding source line to ~/.bashrc"
   echo '[ -f ~/.shellrc ] && source ~/.shellrc' >> ~/.bashrc
fi

#refresh shell
refresh_shell

# Set ghostty as default terminal
echo "checking for linux to configure ghostty..."
if [ -x "$(which ghostty)" ] && [ "$(uname -s)" = "Linux" ]; then
    echo "setting ghostty as default..."
    #gsettings set org.gnome.desktop.default-applications.terminal exec 'ghostty'
    #CUSTOM_KEYS="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
    #gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['$CUSTOM_KEYS/custom0/']"
    #dconf write $CUSTOM_KEYS/custom0/binding "'<Super>t'"
    #dconf write $CUSTOM_KEYS/custom0/command "'ghostty'"
    #dconf write $CUSTOM_KEYS/custom0/name "'Ghostty'"
    #echo "Ghostty has been set as the default terminal with Super+T keybinding"
else
    echo "Ghostty is not installed or this is not a Linux system"
fi

#refresh shell
refresh_shell

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

#refresh shell
refresh_shell

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
