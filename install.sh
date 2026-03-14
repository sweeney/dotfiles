#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -sf "$DOTFILES_DIR/bash_profile" ~/".bash_profile"
ln -sf "$DOTFILES_DIR/bashrc" ~/".bashrc"
ln -sf "$DOTFILES_DIR/gitconfig" ~/".gitconfig"
ln -sf "$DOTFILES_DIR/plan" ~/".plan"
ln -sf "$DOTFILES_DIR/vimrc" ~/".vimrc"

ln -sf "$DOTFILES_DIR/tmux.conf" ~/".tmux.conf"

mkdir -p ~/.ssh
chmod 700 ~/.ssh
ln -sf "$DOTFILES_DIR/ssh/config" ~/.ssh/config

curl -s https://github.com/sweeney.keys >> ~/.ssh/authorized_keys
sort -u ~/.ssh/authorized_keys -o ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
