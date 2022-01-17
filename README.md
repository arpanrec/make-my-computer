# dotfiles

## RUN
```bash
curl https://raw.githubusercontent.com/arpanrec/dotfiles/init/.dotfiles/setup.sh | bash
```

```sh
mkdir -p ${HOME}/.dotfiles && \
rm -rf ${HOME}/.dotfiles/bare && \
git clone https://github.com/arpanrec/dotfiles.git --bare $HOME/.dotfiles/bare && \
alias config="git --git-dir=$HOME/.dotfiles/bare --work-tree=$HOME" && \
config config status.showUntrackedFiles no && \
rm -rf $HOME/.bash_it && \
git clone https://github.com/arpanrec/bash-it ~/.bash_it
```
