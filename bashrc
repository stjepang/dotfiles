# Basic environment variables.
export HISTSIZE=100000
export HISTFILESIZE=100000
export EDITOR=vi

# Basic aliases.
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -la'
alias rm='rm -I'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'

# Command line format.
ps1_branch() { git symbolic-ref --short HEAD 2> /dev/null; }
export PS1='\
\[\e[1;34m\]\W\[\e[m\]\
\[\e[0;33m\]$(b=`ps1_branch`; [ -n "$b" ] && printf " $b")\[\e[m\] \
\[\e[1;32m\]\$\[\e[m\] '

# Returns zero if the command exists.
is_cmd() { type "$1" &> /dev/null; }

# Make aliases work with sudo.
is_cmd sudo && alias sudo='sudo '

# Configure ssh-agent.
if is_cmd ssh-agent; then
  pgrep -u $USER ssh-agent > /dev/null || ssh-agent > ~/.ssh-agent-thing
  [[ "$SSH_AGENT_PID" == "" ]] && eval $(<~/.ssh-agent-thing) > /dev/null
  ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'
fi

# Git alias.
if is_cmd git; then
  alias g='git'
  if is_cmd _completion_loader; then
    _completion_loader git
    complete -o default -o nospace -F _git g
  fi
fi

# Docker alias.
if is_cmd docker && is_cmd sudo; then
  alias d='sudo docker'
  if is_cmd _completion_loader; then
    _completion_loader docker
    complete -o default -o nospace -F _docker d
  fi
fi

# Change directory using ranger.
if is_cmd ranger; then
  ranger-cd() {
    /usr/bin/ranger --choosedir=/tmp/chosendir "$PWD"
    [[ "$(cat /tmp/chosendir)" != "$PWD" ]] && cd $(cat /tmp/chosendir)
    rm -f /tmp/chosendir
  }
  bind '"\C-o":"\C-u\C-a\C-kranger-cd\C-m"'
fi

# Set up fzf.
if source ~/.fzf.bash 2> /dev/null; then
  export FZF_TMUX=0
  export FZF_DEFAULT_OPTS='-e'
fi
