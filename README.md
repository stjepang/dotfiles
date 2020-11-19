#### Basics

1. bash
2. git
3. vim

#### Get dotfiles

```
git clone https://github.com/stjepang/dotfiles.git
```

#### Add to ~/.bashrc

```
source ~/dotfiles/bashrc
```

#### Add to ~/.gitconfig

```
[include] path = ~/dotfiles/gitconfig
```

#### Add to ~/.vimrc

```
source ~/dotfiles/vimrc
```

#### Install fzf

```
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf &&
~/.fzf/install --all --no-zsh --no-fish
```

# TODO script (only 1 step: curl | run script)
check if there's bash || die
check if there's git || die
check if there's vim 8 || die
check if there's ~/.fzf && install
check if there's dotfiles && clone
grep bashrc and install
grep gitconfig and install
grep vimrc and install
if there's no ag or rg, advise installing rg (ripgrep) or ag (the_silver_searcher)
if there's no ranger, advise installing ranger
if there's no rust, advise installing it (Hint: suggest command)
if there's no rust-analyzer, advise installing it
if there's no golang, advise installing it
if there's no gopls, advise installing it
