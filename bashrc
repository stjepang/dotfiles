# Basic environment variables
export HISTSIZE=100000
export HISTFILESIZE=100000
export EDITOR=vim

# Basic aliases
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -la'
alias rm='rm -I'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'

# Command line format
export PS1='\
\[\e[1;34m\]\W\[\e[m\]\
\[\e[0;33m\]\
$(\
  b=`git symbolic-ref --short HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null`;\
  [ -n "$b" ] && printf " $b"\
)\[\e[m\] \
\[\e[1;32m\]\$\[\e[m\] '

# Let aliases work with sudo
alias sudo='sudo '

# Git alias
alias g='git'
if type "_completion_loader" &> /dev/null; then
  _completion_loader git
  complete -o default -o nospace -F _git g
fi

# Change directory using ranger
ranger-cd() {
  ranger --choosedir=/tmp/chosendir "$PWD"
  [[ "$(cat /tmp/chosendir)" != "$PWD" ]] && cd $(cat /tmp/chosendir)
  rm -f /tmp/chosendir
}
bind '"\C-o":"\C-u\C-a\C-kranger-cd\C-m"'

# FZF options
export FZF_TMUX=0
export FZF_DEFAULT_OPTS='-e'
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
