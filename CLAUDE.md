# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository that manages personal configuration files across Mac and Linux environments using Chezmoi for dotfile management and Mise for package/tool management.

## Key Commands

### Initial Setup (Linux)
```bash
# Run full setup on Linux VM
./setup/linux-vm.sh
```

### Initial Setup (Mac)
```bash
# Install mise
curl https://mise.run | sh

# Install chezmoi via mise
mise use -g chezmoi@latest

# Apply dotfiles
chezmoi init --source .
chezmoi apply
```

### Common Development Tasks
```bash
# Apply dotfile changes
chezmoi apply

# Preview changes before applying
chezmoi diff

# Add a new file to chezmoi
chezmoi add ~/.config/newapp/config

# Edit a managed file
chezmoi edit ~/.config/nvim/init.lua

# Update mise tools
mise install

# See installed tools
mise current
```

## Architecture

### Structure
- `home/` - Chezmoi source directory (marked by `.chezmoiroot`)
  - `dot_*` - Files that map to `~/.filename`
  - `dot_config/` - Maps to `~/.config/`
  - `private_*` - Files with restricted permissions
  - `run_once_*` - Scripts that run once on first apply
- `.chezmoi.toml.tmpl` - Chezmoi config with OS detection
- `.chezmoiignore` - Platform-specific file ignores
- `.mise.toml` - Global tool versions managed by mise

### Key Components
1. **Mise Tools** - Development tools managed at system level:
   - Core tools: neovim, zellij, lsd, lazygit, oh-my-posh
   - Languages: node, python, go
   - Utilities: ripgrep, fzf, zoxide, jq, go-task

2. **Shell Configuration** - Universal `.shellrc` sourced by both bash and zsh
   - Mise activation
   - Antidote plugin manager (zsh-autosuggestions, zsh-syntax-highlighting, fzf-tab)
   - Handles brew setup (Linux)
   - npm global package path configuration
   - Custom aliases for lsd, 1password integration
   - Project-specific zellij sessions

3. **LSPs** - Managed by Mason.nvim (not mise)
   - Run `:Mason` in nvim to install/manage language servers

4. **Platform Detection** - Automatic detection via `.chezmoi.toml.tmpl`:
   - Mac: `ostype = "mac"`
   - Linux: `ostype = "linux"`
   - Used in `.chezmoiignore` and templates

### Important Notes
- LSPs are managed by Mason.nvim, not mise
- Zsh plugins are managed by Antidote (auto-installs on first zsh load)
- 1Password integration requires manual signin for security
- Never commit changes automatically — always let the user commit manually

---

## Legacy (Stow/Devbox) - Deprecated

The old stow/devbox setup is preserved in `symlinks/` for reference.

### Legacy Commands
```bash
# Update symlinks after modifying configuration files
cd symlinks && stow --restow --adopt --target ~ --verbose --no-folding */ && git restore . && cd ..

# Update devbox packages
devbox global update

# Refresh devbox environment
eval "$(devbox global shellenv --preserve-path-stack -r)" && hash -r
```
