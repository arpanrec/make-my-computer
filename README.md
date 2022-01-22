# dotfiles

## RUN

### Get resources
```sh
mkdir -p ${HOME}/.dotfiles && \
rm -rf ${HOME}/.dotfiles/bare && \
git clone --single-branch --branch bash-zsh https://github.com/arpanrec/dotfiles.git --bare $HOME/.dotfiles/bare && \
rm -rf $HOME/.bash_it && git clone --depth=1 https://github.com/arpanrec/bash-it $HOME/.bash_it
```

### Activate

```sh
git --git-dir=$HOME/.dotfiles/bare --work-tree=$HOME config status.showUntrackedFiles no
git --git-dir=$HOME/.dotfiles/bare --work-tree=$HOME pull --set-upstream origin bash-zsh
alias config="git --git-dir=$HOME/.dotfiles/bare --work-tree=$HOME"
config reset --hard HEAD
```
