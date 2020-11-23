#!/usr/bin/env bash

# Clone: https://raw.githubusercontent.com/stjepang/dotfiles/master/install.sh

if [ ! -n "$BASH" ]; then
  echo 'Error: current shell is not bash.' >&2
  exit 1
fi

cd "$HOME"
export GIT_TERMINAL_PROMPT=0

if ! [ -x "$(command -v git)" ]; then
  echo 'Error: git is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v vim)" ]; then
  echo 'Error: vim is not installed.' >&2
  exit 1
fi

if ! [ -d "$HOME/dotfiles" ]; then
  git clone --depth 1 \
    https://github.com/stjepang/dotfiles.git ~/dotfiles || exit 1
fi
echo "OK: $HOME/dotfiles"

append_lines() {
  for line in "${@:2}"; do
    if [ ! -f "$1" ] || ! grep -F "$line" "$1" >/dev/null; then
      echo "$line" >> "$1"
    fi
  done
  echo "OK: $1"
}
append_lines ~/.bashrc 'source ~/dotfiles/bashrc'
append_lines ~/.gitconfig '[include] path = ~/dotfiles/gitconfig'
append_lines ~/.vimrc 'source ~/dotfiles/vimrc'
append_lines ~/.tmux.conf \
  'DOTFILES=/Users/stjepan/dotfiles' \
  'source "$DOTFILES/tmux.conf"'

if ! [ -d "$HOME/.fzf" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf || exit 1
  ~/.fzf/install --all --no-zsh --no-fish || exit 1
fi
echo "OK: $HOME/.fzf"

if ! [ -x "$(command -v ag)" ]; then
  echo "Note: ag (the_silver_searcher) is not installed."
fi

if ! [ -x "$(command -v rg)" ]; then
  echo "Note: rg (ripgrep) is not installed."
fi

if ! [ -x "$(command -v ranger)" ]; then
  echo "Note: ranger is not installed."
fi

if ! [ -x "$(command -v cargo)" ]; then
  echo "Note: cargo is not installed."
  echo "  Hint: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
fi
