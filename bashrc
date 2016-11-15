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
  b=`git symbolic-ref --short HEAD 2> /dev/null || git rev-parse --short HEAD`;\
  [ -n "$b" ] && printf " $b"\
)\[\e[m\] \
\[\e[1;32m\]\$\[\e[m\] '

# Makes completion work with aliases
set_complete() {
  if type "_completion_loader" &> /dev/null; then
    _completion_loader "$2"
    complete -o default -o nospace -F "$3" "$1"
  fi
}

# Let aliases work with sudo
alias sudo='sudo '

# Git alias
alias g='git'
set_complete g git _git

# Docker alias
alias d='sudo docker'
set_complete d docker _docker

# Docker-compose/fig alias
alias fig='sudo docker-compose'

# Change directory using ranger
ranger-cd() {
  /usr/bin/ranger --choosedir=/tmp/chosendir "$PWD"
  [[ "$(cat /tmp/chosendir)" != "$PWD" ]] && cd $(cat /tmp/chosendir)
  rm -f /tmp/chosendir
}
bind '"\C-o":"\C-u\C-a\C-kranger-cd\C-m"'

# Configure fzf
export FZF_TMUX=0
export FZF_DEFAULT_OPTS='-e'
