export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
alias ls="ls -G"

export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:"$HOME/.local/bin"

# Quieten down homebrew
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ENV_HINTS=1

export BASH_SILENCE_DEPRECATION_WARNING=1

# Don't save commands containing secrets to history
export HISTCONTROL=ignoreboth
export HISTIGNORE="*SECRET=*:*PASSWORD=*:*TOKEN=*:*KEY=*:*_PASS=*"

eval "$(/opt/homebrew/bin/brew shellenv)"

# sweeney@machine:dir (master)$
function parse_git_branch {
       git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/' 
}

export PS1="\u@\h:\W \$(parse_git_branch)$ "

mkcd () {
  [ -z "$1" ] && echo "Usage: mkcd <dir>" && return 1
  mkdir -p "$1" && cd "$1"
}

# screen / tmux session helpers
[ -f ~/.screen.bash ] && source ~/.screen.bash
[ -f ~/.tmux.bash ] && source ~/.tmux.bash

# Guard against accidentally killing a screen/tmux session by typing `exit`
exit() {
  if [ -n "$TMUX" ]; then
    echo "You're inside a tmux session ($(tmux display-message -p '#S'))."
    echo "Detach with Ctrl-a d, or type 'realexit' to exit anyway."
    return 1
  fi
  if [ -n "$STY" ]; then
    echo "You're inside a screen session ($STY)."
    echo "Detach with Ctrl-a d, or type 'realexit' to exit anyway."
    return 1
  fi
  builtin exit "$@"
}
realexit() { builtin exit "$@"; }

# give each machine a .bashrc.local file if they want it
[ -f ~/.bashrc.local ] && source ~/.bashrc.local

# support direnv if we have it
command -v direnv &>/dev/null && eval "$(direnv hook bash)"
