#!/usr/bin/env bash

# curl -sSf https://raw.githubusercontent.com/stjepang/dotfiles/master/install.sh | bash

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

if ! [ -d "$HOME/.fzf" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf || exit 1
  ~/.fzf/install --all --no-zsh --no-fish || exit 1
fi

if ! [ -d "$HOME/dotfiles" ]; then
  git clone --depth 1 \
    https://github.com/stjepang/dotfiles.git ~/dotfiles || exit 1
fi
echo "OK: $HOME/dotfiles"

append_line() {
  if [ ! -f "$1" ] || ! grep -F "$2" "$1" >/dev/null; then
    echo "$2" >> "$1"
  fi
  echo "OK: $1"
}
append_line ~/.bashrc 'source ~/dotfiles/bashrc'
append_line ~/.gitconfig '[include] path = ~/dotfiles/gitconfig'
append_line ~/.vimrc 'source ~/dotfiles/vimrc'

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
