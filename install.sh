#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -sf "$DOTFILES_DIR/bash_profile" ~/".bash_profile"
ln -sf "$DOTFILES_DIR/bashrc" ~/".bashrc"
ln -sf "$DOTFILES_DIR/gitconfig" ~/".gitconfig"
ln -sf "$DOTFILES_DIR/plan" ~/".plan"
ln -sf "$DOTFILES_DIR/vimrc" ~/".vimrc"

mkdir -p ~/.ssh
chmod 700 ~/.ssh
ln -sf "$DOTFILES_DIR/ssh/config" ~/.ssh/config
