# Dotfiles

Personal dotfiles managed with [Chezmoi](https://chezmoi.io) and [Mise](https://mise.jdx.dev).

## Quick Start

### Linux VM

```bash
./setup/linux-vm.sh
```

### Mac

```bash
# Install mise
curl https://mise.run | sh

# Install chezmoi
~/.local/bin/mise use -g chezmoi@latest

# Apply dotfiles
eval "$(~/.local/bin/mise activate bash)"
chezmoi init --source .
chezmoi apply
```

## What's Included

### Tools (via Mise)

- **Languages:** node, python, go
- **Editor:** neovim
- **Terminal:** zellij, oh-my-posh, lsd, fzf, zoxide
- **Dev tools:** lazygit, ripgrep, jq, go-task

### Configs

- `nvim` - Neovim config with LSP (Mason-managed)
- `zellij` - Terminal multiplexer
- `git` - Git config (personal + work profiles)
- `lsd` - ls replacement with colors
- `omp` - Oh My Posh prompt theme
- `ghostty` - Terminal emulator

### Shell

- Zsh with Antidote plugin manager
- Plugins: zsh-autosuggestions, zsh-syntax-highlighting, fzf-tab

## 1Password Integration

### Project Secrets (Service Account)

For automatic env var loading in projects:

```bash
# Store service account token (once, not in git)
mkdir -p ~/.config/op
echo "your-token" > ~/.config/op/service-account-token
chmod 600 ~/.config/op/service-account-token
```

In your project, create `.env.op`:

```
DATABASE_URL=op://Vault/Database/url
API_KEY=op://Vault/Service/key
```

And `.mise.toml`:

```toml
[env]
_.source = "op inject -i .env.op"
```

Secrets load automatically when you `cd` into the project.

### Personal Vault (Interactive)

```bash
1l  # Sign in to 1Password
1i  # Inject env vars from ~/.1password-personal
```

## Structure

```
dotfiles/
├── .chezmoi.toml.tmpl    # OS detection (mac/linux)
├── .mise.toml            # Global tool versions
├── home/                 # Chezmoi source (maps to ~/)
│   ├── dot_shellrc       # → ~/.shellrc
│   ├── dot_config/       # → ~/.config/
│   └── run_once_*.sh     # Setup scripts
└── setup/
    └── linux-vm.sh       # Linux bootstrap
```

## Common Commands

```bash
# Apply dotfile changes
chezmoi apply

# Preview changes
chezmoi diff

# Add a new config file
chezmoi add ~/.config/newapp/config

# Update tools
mise install

# See installed tools
mise current
```
