#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Symlink, moving aside anything real that's already there. An existing symlink
# is ours from a previous run, so it's replaced without a backup.
link() {
  if [ -e "$2" ] && [ ! -L "$2" ]; then
    mv "$2" "$2.bak.$(date +%Y%m%d%H%M%S)"
    echo "backed up $2"
  fi
  ln -sf "$1" "$2"
}

link "$DOTFILES_DIR/bash_profile" ~/.bash_profile
link "$DOTFILES_DIR/bashrc" ~/.bashrc
link "$DOTFILES_DIR/gitconfig" ~/.gitconfig
link "$DOTFILES_DIR/plan" ~/.plan
link "$DOTFILES_DIR/vimrc" ~/.vimrc

link "$DOTFILES_DIR/tmux.conf" ~/.tmux.conf
link "$DOTFILES_DIR/screen.bash" ~/.screen.bash
link "$DOTFILES_DIR/tmux.bash" ~/.tmux.bash

mkdir -p ~/.ssh
chmod 700 ~/.ssh
link "$DOTFILES_DIR/ssh/config" ~/.ssh/config

# No longer used. This pulled the GitHub-published public keys onto the host so
# a fresh remote box would accept our key without pasting it by hand. If revived,
# the curl needs -f: without it a failed fetch appends the error body and exits 0.

# curl -s https://github.com/sweeney.keys >> ~/.ssh/authorized_keys
# sort -u ~/.ssh/authorized_keys -o ~/.ssh/authorized_keys
# chmod 600 ~/.ssh/authorized_keys
