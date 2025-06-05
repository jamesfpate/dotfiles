# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository that manages personal configuration files across Mac, Linux, and WSL environments using GNU Stow for symlink management and Devbox for package management.

## Key Commands

### Initial Setup
```bash
# Install devbox (if not already installed)
./install-devbox.sh

# Run full setup
./setup.sh
```

### Common Development Tasks
```bash
# Update symlinks after modifying configuration files
task stow
# Or manually:
cd symlinks && stow --restow --adopt --target ~ --verbose --no-folding */ && git restore . && cd ..

# Update devbox packages
devbox global update

# Refresh devbox environment
eval "$(devbox global shellenv --preserve-path-stack -r)" && hash -r
```

## Architecture

### Structure
- `symlinks/` - Contains all configuration directories to be symlinked to home directory
  - Each subdirectory represents a tool/application configuration
  - Uses GNU Stow with `--no-folding` to create individual file symlinks
  - The `--adopt` flag ensures existing files are preserved during setup

### Key Components
1. **Devbox Global Packages** - Development tools managed at system level including:
   - Core tools: neovim, zellij, lsd, lazygit
   - Language servers: basedpyright, lua-language-server, gopls, typescript-language-server
   - Shell: zsh (non-Mac), oh-my-posh for prompt theming

2. **Shell Configuration** - Universal `.shellrc` sourced by both bash and zsh
   - Handles brew setup (Linux)
   - npm global package path configuration
   - Custom aliases for lsd, 1password integration
   - Project-specific zellij sessions

3. **Platform Detection** - Automatic detection and configuration for:
   - WSL: Special 1password CLI setup, git SSH configuration
   - Mac: Native shell usage
   - Linux: Devbox zsh as default shell

### Important Notes
- Always run `git restore .` after stow operations to prevent unintended modifications
- The setup script uses `--adopt` flag which can modify files in the repository
- 1Password integration requires manual signin for security
