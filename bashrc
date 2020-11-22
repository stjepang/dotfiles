# Basic environment variables
export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTIGNORE='rm *:sudo rm*'
export HISTCONTROL=ignoreboth:erasedups
export EDITOR=vim

# Basic aliases
if [ "$(uname)" == "Darwin" ]; then
  alias ls='ls -G'
  alias rm='rm -i'
else
  alias ls='ls --color=auto'
  alias rm='rm -I'
fi
alias ll='ls -l'
alias la='ls -la'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'

# Let aliases work with sudo
alias sudo='sudo '

# Other aliases
alias g='git'
alias c='cargo'

# Command line format
export PS1='\
\[\e[1;34m\]\W\[\e[m\]\
\[\e[0;33m\]\
$(\
  b=`git symbolic-ref --short HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null`;\
  [ -n "$b" ] && printf " $b"\
)\[\e[m\] \
\[\e[1;32m\]\$\[\e[m\] '

# Change directory using ranger
if [ -x "$(command -v ranger)" ]; then
  ranger-cd() {
    ranger --choosedir=/tmp/chosendir "$PWD"
    [[ "$(cat /tmp/chosendir)" != "$PWD" ]] && cd "$(cat /tmp/chosendir)"
    rm -f /tmp/chosendir
  }
  bind '"\C-o":"\C-u\C-a\C-kranger-cd\C-m\C-l"'
fi

# Don't discard Ctrl-O keypresses
[ "$(uname)" == "Darwin" ] && stty discard undef

# FZF options
export FZF_TMUX=0
export FZF_DEFAULT_OPTS='-e --preview-window=up:50% --bind=ctrl-/:toggle-preview'

# Color theme
if [ "$(tput colors)" == "256" ]; then
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  source "$DIR/base16-shell/scripts/base16-tomorrow-night.sh"
fi
