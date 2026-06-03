#!/bin/bash

# Configuration directories
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${HOME}/.config"
LOCAL_BIN="${HOME}/.local/bin"

# Create base directories if they don't exist
mkdir -p "${CONFIG_DIR}"
mkdir -p "${LOCAL_BIN}"

echo "🚀 Setting up dotfiles..."

# Function to safely symlink
link_file() {
    local src="$1"
    local dest="$2"
    mkdir -p "$(dirname "$dest")"
    echo "🔗 Linking $(basename "$src") -> $dest"
    ln -sf "$src" "$dest"
}

# Core Configs
link_file "${DOTFILES_DIR}/tmux/tmux.conf" "${HOME}/.tmux.conf"
link_file "${DOTFILES_DIR}/zsh/zshrc" "${HOME}/.zshrc"
link_file "${DOTFILES_DIR}/bash/bashrc" "${HOME}/.bashrc"
link_file "${DOTFILES_DIR}/bash/bash_profile" "${HOME}/.bash_profile"

# Tool Configs in ~/.config/
configs=("alacritty")
for cfg in "${configs[@]}"; do
    if [ -d "${DOTFILES_DIR}/${cfg}" ]; then
        echo "📂 Setting up config for: ${cfg}"
        mkdir -p "${CONFIG_DIR}/${cfg}"
        find "${DOTFILES_DIR}/${cfg}" -maxdepth 1 -not -path "${DOTFILES_DIR}/${cfg}" -exec ln -sf {} "${CONFIG_DIR}/${cfg}/" \;
    fi
done

# Symlink scripts
echo "🔗 Linking scripts..."
for script in "${DOTFILES_DIR}/scripts"/*; do
    if [ -f "$script" ]; then
        script_name=$(basename "$script")
        ln -sf "$script" "${LOCAL_BIN}/${script_name}"
        chmod +x "$script"
    fi
done

echo "✅ Setup complete!"
