export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
alias ls="ls -G"

export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin

export HOMEBREW_NO_ANALYTICS=1

####################################################

function parse_git_branch {
       git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/' 
}

export PS1="\u@\h:\W \$(parse_git_branch)$ "
