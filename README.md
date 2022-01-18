# dotfiles

## RUN
```sh
mkdir -p ${HOME}/.dotfiles && \
rm -rf ${HOME}/.dotfiles/bare && \
git clone --single-branch --branch bash-zsh https://github.com/arpanrec/dotfiles.git --bare $HOME/.dotfiles/bare && \
alias config="git --git-dir=$HOME/.dotfiles/bare --work-tree=$HOME" && \
config config status.showUntrackedFiles no && \
config reset --hard HEAD && \
rm -rf $HOME/.bash_it && git clone --depth=1 https://github.com/arpanrec/bash-it $HOME/.bash_it && \
rm -rf $HOME/.oh-my-zsh && git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git $HOME/.oh-my-zsh && \
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```
