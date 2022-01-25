#!/usr/bin/env bash
set -e

pre_pro=( wget unzip tar pip3 g++ make openssl gpg2 )
for prog in "${pre_pro[@]}"
do
if ! hash ${prog} &>/dev/null ; then
	echo ${prog} not Installed
    exit 1
fi
done

TEMP_DOWNLOAD_PATH="$HOME/.tmp"
SOURCE_PACKAGE_PATH="$HOME/.local/src"
PATH_TO_LOCAL_PREFX="$HOME/.local"

BITWARDEN_CLI_VERSION=1.20.0
BITWARDEN_VERSION=1.30.0
MATTERMOST_VERSION=5.0.2
NEOVIM_VERSION=0.6.1
JQ_VERSION=1.6
GO_VERSION=1.17.6
JDK_VERSION=17
MAVEN_VERSION=3.8.4
NODE_JS_VERSION=16.13.2
NCURSES_VERSION=6.3
ZSH_VERSION=5.8
OPENSSL_VERSION=3.0.1

unset BITWARDEN_CLI_DOWNLOAD_URL
unset BITWARDEN_DOWNLOAD_URL
unset MATTERMOST_DOWNLOAD_URL
unset POSTMAN_DOWNLOAD_URL
unset NEOVIM_DOWNLOAD_URL
unset JQ_DOWNLOAD_URL
unset GO_DOWNLOAD_URL
unset JDK_DOWNLOAD_URL
unset MAVEN_DOWNLOAD_URL
unset NODE_JS_DOWNLOAD_URL
unset NCURSES_DOWNLOAD_URL
unset ZSH_DOWNLOAD_URL
unset OPENSSL_DOWNLOAD_URL

if [[  "$(uname -m)" == 'x86_64'  ]]; then

BITWARDEN_CLI_DOWNLOAD_URL="https://github.com/bitwarden/cli/releases/download/v${BITWARDEN_CLI_VERSION}/bw-linux-${BITWARDEN_CLI_VERSION}.zip"
BITWARDEN_DOWNLOAD_URL=""
MATTERMOST_DOWNLOAD_URL="https://releases.mattermost.com/desktop/${MATTERMOST_VERSION}/mattermost-desktop-${MATTERMOST_VERSION}-linux-x64.tar.gz?src=dl"
POSTMAN_DOWNLOAD_URL="https://dl.pstmn.io/download/latest/linux64"
NEOVIM_DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim-linux64.tar.gz"
JQ_DOWNLOAD_URL="https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64"
GO_DOWNLOAD_URL="https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
JDK_DOWNLOAD_URL="https://download.oracle.com/java/${JDK_VERSION}/latest/jdk-${JDK_VERSION}_linux-x64_bin.tar.gz"
MAVEN_DOWNLOAD_URL="https://dlcdn.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz"
NODE_JS_DOWNLOAD_URL="https://nodejs.org/dist/v$NODE_JS_VERSION/node-v$NODE_JS_VERSION-linux-x64.tar.xz"
NCURSES_DOWNLOAD_URL="https://ftp.gnu.org/pub/gnu/ncurses/ncurses-$NCURSES_VERSION.tar.gz"
ZSH_DOWNLOAD_URL="https://onboardcloud.dl.sourceforge.net/project/zsh/zsh/$ZSH_VERSION/zsh-$ZSH_VERSION.tar.xz"
OPENSSL_DOWNLOAD_URL="https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz"

fi

mkdir -p "$HOME/tmp/" "$HOME/.local/bin"

read -n1 -p "Enter \"Y\" to Redownload bash_it, oh-my-zsh and fzf (Press any other key to Skip*) : " redownload_bashit_ohmyzsh_fzf
echo ""

read -n1 -p "Enter \"Y\" to Redownload Dotfiles (Press any other key to Skip*) : " redownload_dotfiles
echo ""

if [[ "$redownload_dotfiles" == "Y" || "$redownload_dotfiles" == "y" ]]; then
echo "All the contents for $HOME directory will be replaced by https://github.com/arpanrec/dotfiles/tree/bash-zsh"
echo "Double check the files present in https://github.com/arpanrec/dotfiles/tree/bash-zsh"
unset redownload_dotfiles
read -n1 -p "Enter \"Y\" to If you still wanna get the contents (Press any other key to Skip*) : " redownload_dotfiles
echo ""
if [[ "$redownload_dotfiles" == "Y" || "$redownload_dotfiles" == "y" ]]; then
read -n1 -p "Enter \"Y\" to create softlink of gitconfig $HOME/.dotfiles/gitconfig => $HOME/.gitconfig (Press any other key to Skip*) : " redownload_dotfiles_link_git_config
echo ""
fi
fi

read -n1 -p "Enter \"Y\" to install Bitwarden Command-line Interface $BITWARDEN_CLI_VERSION (Press any other key to Skip*) : " install_bitwarden_cli
echo ""
read -n1 -p "Enter \"Y\" to install Mattermost $MATTERMOST_VERSION (Press any other key to Skip*) : " install_mattermost
echo ""
read -n1 -p "Enter \"Y\" to install postman (Press any other key to Skip*) : " install_postman
echo ""
read -n1 -p "Enter \"Y\" to install neo vim $NEOVIM_VERSION (Press any other key to Skip*) : " install_neovim
echo ""
read -n1 -p "Enter \"Y\" to install Jq $JQ_VERSION (Press any other key to Skip*) : " install_jq
echo ""
read -n1 -p "Enter \"Y\" to install go $GO_VERSION (Press any other key to Skip*) : " install_go
echo ""
read -n1 -p "Enter \"Y\" to install JDK $JDK_VERSION (Press any other key to Skip*) : " install_jdk
echo ""
read -n1 -p "Enter \"Y\" to install maven $MAVEN_VERSION (Press any other key to Skip*) : " install_maven
echo ""
read -n1 -p "Enter \"Y\" to install node js $NODE_JS_VERSION (Press any other key to Skip*) : " install_node_js
echo ""
read -n1 -p "Enter \"Y\" to install ncurses $NCURSES_VERSION (Press any other key to Skip*) : " install_ncurses
echo ""
read -n1 -p "Enter \"Y\" to install zsh $ZSH_VERSION (Press any other key to Skip*) : " install_zsh
echo ""
read -n1 -p "Enter \"Y\" to install openssl $OPENSSL_VERSION (Press any other key to Skip*) : " install_openssl
echo ""

if [[ "$redownload_bashit_ohmyzsh_fzf" == "Y" || "$redownload_bashit_ohmyzsh_fzf" == "y" ]]; then
echo "# Redownload bash_it, oh-my-zsh and fzf Start"

rm -rf "$HOME/.bash_it" "$HOME/.oh-my-zsh" "$HOME/.fzf"
git clone --depth=1 https://github.com/Bash-it/bash-it "$HOME/.bash_it"
git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone --depth=1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
"$HOME/.fzf/install" --all

echo "# Redownload bash_it, oh-my-zsh and fzf END"
fi

if [[ "$redownload_dotfiles" == "Y" || "$redownload_dotfiles" == "y" ]]; then
echo "# Redownload Dotfiles Start"

redownload_dotfiles_old_backup_dir="${HOME}/.dotfiles/backup/$(date +%s)"

mkdir -p "${redownload_dotfiles_old_backup_dir}"
echo "Backup Old Files to ${redownload_dotfiles_old_backup_dir}"

if [ -f "$HOME/.bashrc" ]; then
cp "$HOME/.bashrc" "${redownload_dotfiles_old_backup_dir}/.bashrc"
fi

if [ -f "$HOME/.zshrc" ]; then
cp "$HOME/.zshrc" "${redownload_dotfiles_old_backup_dir}/.zshrc"
fi

if [ -f "$HOME/.bash_profile" ]; then
cp "$HOME/.bash_profile" "${redownload_dotfiles_old_backup_dir}/.bash_profile"
fi

if [ -f "$HOME/.aliasrc" ]; then
cp "$HOME/.aliasrc" "${redownload_dotfiles_old_backup_dir}/.aliasrc"
fi

if [ -d "$HOME/.ssh" ]; then
cp -R "$HOME/.ssh" "${redownload_dotfiles_old_backup_dir}/"
fi

if [ -f "$HOME/.gitconfig" ]; then
cp -R "$HOME/.gitconfig" "${redownload_dotfiles_old_backup_dir}/.gitconfig"
fi

rm -rf "${HOME}/.dotfiles/bare"
git clone --depth=1 --single-branch --branch bash-zsh https://github.com/arpanrec/dotfiles.git --bare "$HOME/.dotfiles/bare"
git --git-dir=$HOME/.dotfiles/bare --work-tree=$HOME config status.showUntrackedFiles no
git --git-dir=$HOME/.dotfiles/bare --work-tree=$HOME pull --set-upstream origin bash-zsh
git --git-dir=$HOME/.dotfiles/bare --work-tree=$HOME reset --hard HEAD

if [[ "$redownload_dotfiles" == "Y" || "$redownload_dotfiles" == "y" ]]; then
rm -rf "$HOME/.gitconfig"
ln -s "$HOME/.dotfiles/gitconfig" "$HOME/.gitconfig"
fi

echo "# Redownload Dotfiles END"
fi

if [[ "$install_bitwarden_cli" == "Y" || "$install_bitwarden_cli" == "y" ]]; then
echo "# Bitwarden CLI Install Start"

rm -rf "$HOME/.local/bin/bw"

if [ ! -f "$HOME/tmp/bw-linux-$BITWARDEN_CLI_VERSION.zip" ]; then
    wget "$BITWARDEN_CLI_DOWNLOAD_URL" -O "$HOME/tmp/bw-linux-$BITWARDEN_CLI_VERSION.zip"
fi

unzip -o "$HOME/tmp/bw-linux-$BITWARDEN_CLI_VERSION.zip" -d "$HOME/.local/bin/"
chmod +x "$HOME/.local/bin/bw"
echo "# Bitwarden CLI Install END"
fi

if [[ "$install_mattermost" == "Y" || "$install_mattermost" == "y" ]]; then
echo "# Mattermost Desktop Application Start"
mkdir -p "$HOME/.local/share/mattermost-desktop"

if [ ! -f "$HOME/tmp/mattermost-desktop-$MATTERMOST_VERSION.tar.gz" ]; then
wget "$MATTERMOST_DOWNLOAD_URL" -O "$HOME/tmp/mattermost-desktop-$MATTERMOST_VERSION.tar.gz"
fi

tar -zxf "$HOME/tmp/mattermost-desktop-$MATTERMOST_VERSION.tar.gz" -C "$HOME/.local/share/mattermost-desktop" --strip-components 1

cat <<EOT > "$HOME/.local/share/applications/mattermost-desktop.desktop"
[Desktop Entry]
Type=Application
Version=$MATTERMOST_VERSION
Name=Mattermost
Comment=Mattermost is a secure, open source platform for communication, collaboration, and workflow orchestration across tools and teams.
Path=$HOME/.local/share/mattermost-desktop
Exec=$HOME/.local/share/mattermost-desktop/mattermost-desktop
Icon=$HOME/.local/share/mattermost-desktop/app_icon.png
Terminal=false
Categories=Office;Network;WebBrowser;
EOT
echo "# Mattermost Desktop Application End"
fi

if [[ "$install_postman" == "Y" || "$install_postman" == "y" ]]; then
echo "# Postman Install Start"

rm -rf "$HOME/.local/share/Postman"
mkdir -p "$HOME/.local/share/Postman"

if [ ! -f "$HOME/tmp/postman.tar.gz" ]; then
    wget "$POSTMAN_DOWNLOAD_URL" -O "$HOME/tmp/postman.tar.gz"
fi

tar -zxf "$HOME/tmp/postman.tar.gz" -C "$HOME/.local/share/Postman" --strip-components 1

cat <<EOT > "$HOME/.local/share/applications/Postman.desktop"
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=$HOME/.local/share/Postman/app/Postman %U
Icon=$HOME/.local/share/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOT

echo "# Postman Install END"
fi

if [[ "$install_neovim" == "Y" || "$install_neovim" == "y" ]]; then
echo "# Install neovim Start"

rm -rf "$HOME/.local/share/nvim/" "$HOME/.local/bin/nvim"
mkdir -p "$HOME/.local/share/nvim/"

if [ ! -f "$HOME/tmp/nvim-$NEOVIM_VERSION.tar.gz" ]; then
    wget "$NEOVIM_DOWNLOAD_URL" -O "$HOME/tmp/nvim-$NEOVIM_VERSION.tar.gz"
fi

tar -zxf "$HOME/tmp/nvim-$NEOVIM_VERSION.tar.gz" -C "$HOME/.local/share/nvim/" --strip-components 1
ln -s "$HOME/.local/share/nvim/bin/nvim" "$HOME/.local/bin/nvim"
echo "# Install neovim END"
fi

if [[ "$install_jq" == "Y" || "$install_jq" == "y" ]]; then
echo "# JQ Install Start"

rm -rf "$HOME/.local/bin/jq"

if [ ! -f "$HOME/tmp/jq-$JQ_VERSION" ]; then
    wget "$JQ_DOWNLOAD_URL" -O "$HOME/tmp/jq-$JQ_VERSION"
fi
cp "$HOME/tmp/jq-$JQ_VERSION" "$HOME/.local/bin/jq"
chmod +x "$HOME/.local/bin/jq"
echo "# JQ Install end"
fi

if [[ "$install_go" == "Y" || "$install_go" == "y" ]]; then
echo "# GO Install Start"

rm -rf "$HOME/.local/share/go"
mkdir -p "$HOME/.local/share/go"

if [ ! -f "$HOME/tmp/go-$GO_VERSION.linux.tar.gz" ]; then
    wget "$GO_DOWNLOAD_URL" -O "$HOME/tmp/go-$GO_VERSION.linux.tar.gz"
fi

tar -zxf "$HOME/tmp/go-$GO_VERSION.linux.tar.gz" -C "$HOME/.local/share/go" --strip-components 1

echo "# GO Install End"
fi


if [[ "$install_jdk" == "Y" || "$install_jdk" == "y" ]]; then
echo "# JDK Install Start"

rm -rf "$HOME/.local/share/java"
mkdir -p "$HOME/.local/share/java"

if [ ! -f "${HOME}/tmp/jdk-${JDK_VERSION}.linux.tar.gz" ]; then
    wget "${JDK_DOWNLOAD_URL}" -O "${HOME}/tmp/jdk-${JDK_VERSION}.linux.tar.gz"
fi

tar -zxf "${HOME}/tmp/jdk-${JDK_VERSION}.linux.tar.gz" -C "$HOME/.local/share/java" --strip-components 1

echo "# JDK Install End"
fi

if [[ "$install_maven" == "Y" || "$install_maven" == "y" ]]; then
echo "# Maven Install Start"

rm -rf "$HOME/.local/share/maven"
mkdir -p "$HOME/.local/share/maven"

if [ ! -f "${HOME}/tmp/mvn-${MAVEN_VERSION}.linux.tar.gz" ]; then
    wget "${MAVEN_DOWNLOAD_URL}" -O "${HOME}/tmp/mvn-${MAVEN_VERSION}.linux.tar.gz"
fi

tar -zxf "${HOME}/tmp/mvn-${MAVEN_VERSION}.linux.tar.gz" -C "$HOME/.local/share/maven" --strip-components 1

echo "# Maven Install End"
fi

if [[ "$install_node_js" == "Y" || "$install_node_js" == "y" ]]; then
echo "# Node JS Install Start"

rm -rf "$HOME/.local/share/node"
mkdir -p "$HOME/.local/share/node"

if [ ! -f "${HOME}/tmp/nodejs-${NODE_JS_VERSION}.linux.tar.xz" ]; then
    wget "${NODE_JS_DOWNLOAD_URL}" -O "${HOME}/tmp/nodejs-${NODE_JS_VERSION}.linux.tar.xz"
fi

tar -xf "${HOME}/tmp/nodejs-${NODE_JS_VERSION}.linux.tar.xz" -C "$HOME/.local/share/node" --strip-components 1

echo "# Node JS Install End"
fi

if [[ "$install_ncurses" == "Y" || "$install_ncurses" == "y" ]]; then
echo "# Ncurses Install Start"

rm -rf "$HOME/.local/share/ncurses" "$HOME/tmp/source/ncurses"
mkdir -p "$HOME/.local/share/ncurses" "$HOME/tmp/source/ncurses"

if [ ! -f "${HOME}/tmp/ncurses-${NCURSES_VERSION}.linux.tar.gz" ]; then
    wget "${NCURSES_DOWNLOAD_URL}" -O "${HOME}/tmp/ncurses-${NCURSES_VERSION}.linux.tar.gz"
fi

tar -zxf "${HOME}/tmp/ncurses-${NCURSES_VERSION}.linux.tar.gz" -C "$HOME/tmp/source/ncurses" --strip-components 1

cd "$HOME/tmp/source/ncurses"
"./configure" --prefix="$HOME/.local" --with-shared --without-debug --enable-widec
make
make install
echo "# Ncurses Install end"
fi

if [[ "$install_zsh" == "Y" || "$install_zsh" == "y" ]]; then
echo "# ZSH Install Start"

rm -rf "$HOME/tmp/source/zsh"
mkdir -p "$HOME/tmp/source/zsh"

if [ ! -f "${HOME}/tmp/zsh-${ZSH_VERSION}.linux.tar.xz" ]; then
    wget "${ZSH_DOWNLOAD_URL}" -O "${HOME}/tmp/zsh-${ZSH_VERSION}.linux.tar.xz"
fi

tar -xf "${HOME}/tmp/zsh-${ZSH_VERSION}.linux.tar.xz" -C "$HOME/tmp/source/zsh" --strip-components 1

cd "$HOME/tmp/source/zsh"
"./configure" --prefix="$HOME/.local" --with-shared --without-debug --enable-widec
make
make install
echo "# ZSH Install end"
fi

if [[ "$install_openssl" == "Y" || "$install_openssl" == "y" ]]; then
echo "# Openssl Install Start"

rm -rf "$HOME/tmp/source/openssl"
mkdir -p "$HOME/tmp/source/openssl"

if [ ! -f "${HOME}/tmp/openssl-${OPENSSL_VERSION}.linux.tar.gz" ]; then
    wget "${OPENSSL_DOWNLOAD_URL}" -O "${HOME}/tmp/openssl-${OPENSSL_VERSION}.linux.tar.gz"
fi

tar -zxf "${HOME}/tmp/openssl-${OPENSSL_VERSION}.linux.tar.gz" -C "$HOME/tmp/source/openssl" --strip-components 1

cd "$HOME/tmp/source/openssl"
"./Configure" --prefix="$HOME/.local" shared zlib
make
make install
echo "# Openssl Install end"
fi
