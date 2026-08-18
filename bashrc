# Read by BSD ls only; GNU ignores it in favour of LS_COLORS.
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
# GNU ls colours with --color, BSD with -G. Test for GNU by --version rather
# than probing --color: BSD ls accepts --color, exits 0, and ignores it.
if ls --version 2>/dev/null | grep -q GNU; then
  alias ls="ls --color=auto"
else
  alias ls="ls -G"
fi

export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:"$HOME/.local/bin"

# Quieten down homebrew
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ENV_HINTS=1

export BASH_SILENCE_DEPRECATION_WARNING=1

# Keep obvious secrets out of history. Case-sensitive, and ':' is the separator
# so no pattern may contain one — a stray ':' leaves a bare '*' that matches
# everything. Leading space (via ignoreboth) is the habit that actually works.
export HISTCONTROL=ignoreboth
export HISTIGNORE='*SECRET=*:*secret=*:*PASSWORD=*:*password=*:*TOKEN=*:*token=*:*KEY=*:*key=*:*_PASS=*:*--password*:*--token*'

# Defaults are 500 lines, and without histappend the last shell to exit
# overwrites the file — so in a multi-pane tmux session most of it is lost.
HISTSIZE=100000
HISTFILESIZE=200000
shopt -s histappend

# Homebrew, if present. Prefix varies by platform, and shellenv is what puts
# brew on PATH, so probe rather than `command -v`.
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  if [ -x "$_brew" ]; then
    eval "$("$_brew" shellenv)"
    break
  fi
done
unset _brew

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

# The guards above are `cond && action`, so a false last one makes sourcing
# this file report failure. Keep `true` last.
true
