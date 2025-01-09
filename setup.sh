#!/bin/bash

# Install devbox
curl -fsSL https://get.jetify.com/devbox | bash

# Stow dotfiles to home directory
brew install stow
stow */
git restore .

# Apply devbox global config
devbox global install
devbox global update

# Source based on current shell to get devbox in PATH
source ~/.bashrc

#setup git in wsl
if [ -d /mnt/c ]; then
	echo "WSL detected - configuring Git to use Windows SSH..."
	git config --global core.sshCommand ssh.exe
fi

#posh setup
oh-my-posh font install meslo

# Now we can get devbox's zsh path and add to /etc/shells
DEVBOX_ZSH=$(which zsh)
if ! grep -q "$DEVBOX_ZSH" /etc/shells; then
	echo "$DEVBOX_ZSH" | sudo tee -a /etc/shells
fi

# Set devbox's zsh as default shell
chsh -s "$DEVBOX_ZSH"

# Replace current shell with zsh
exec "$DEVBOX_ZSH"

