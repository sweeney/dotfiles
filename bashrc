export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
alias ls="ls -G"

export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:"$HOME/.local/bin"

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ENV_HINTS=1

export BASH_SILENCE_DEPRECATION_WARNING=1

# Don't save commands containing secrets to history
export HISTCONTROL=ignoreboth
export HISTIGNORE="*SECRET=*:*PASSWORD=*:*TOKEN=*:*KEY=*:*_PASS=*"

eval "$(/opt/homebrew/bin/brew shellenv)"
####################################################

function parse_git_branch {
       git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/' 
}

export PS1="\u@\h:\W \$(parse_git_branch)$ "

mkcd () {
  [ -z "$1" ] && echo "Usage: mkcd <dir>" && return 1
  mkdir -p "$1" && cd "$1"
}

[ -f ~/.bashrc.local ] && source ~/.bashrc.local

command -v direnv &>/dev/null && eval "$(direnv hook bash)"
