# dotfiles

## RUN

### Get resources
```sh
mkdir -p ${HOME}/.dotfiles && \
rm -rf ${HOME}/.dotfiles/bare && \
git clone --single-branch --branch bash-zsh https://github.com/arpanrec/dotfiles.git --bare $HOME/.dotfiles/bare && \
rm -rf $HOME/.bash_it && git clone --depth=1 https://github.com/arpanrec/bash-it $HOME/.bash_it && \
rm -rf $HOME/.oh-my-zsh && git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git $HOME/.oh-my-zsh && \
rm -rf $HOME/.fzf && git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && \
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && \
git clone --depth=1 https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions && \
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
rm -rf $HOME/.zsh-syntax-highlighting && git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh-syntax-highlighting
```

### Activate

```sh
git --git-dir=$HOME/.dotfiles/bare --work-tree=$HOME config status.showUntrackedFiles no
git --git-dir=$HOME/.dotfiles/bare --work-tree=$HOME branch --set-upstream-to origin bash-zsh
alias config="git --git-dir=$HOME/.dotfiles/bare --work-tree=$HOME"
config reset --hard HEAD
```
