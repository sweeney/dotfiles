# dotfiles

## Install

Run from anywhere:

```sh
bash /path/to/dotfiles/install.sh
```

This symlinks all dotfiles into `~/`.

## Machine-specific config

Anything that shouldn't be committed (work project IDs, API keys, machine-specific paths) goes in `~/.bashrc.local`. This file is sourced at the end of `.bashrc` if it exists, and is never tracked by this repo.

Example `~/.bashrc.local`:

```bash
export GOOGLE_CLOUD_PROJECT=my-project
export SOME_API_KEY=secret
```
