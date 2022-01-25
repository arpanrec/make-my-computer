#!/usr/bin/env bash
set -e

pre_pro=( wget unzip tar pip3 )
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

mkdir -p "$TEMP_DOWNLOAD_PATH" "$SOURCE_PACKAGE_PATH"

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

rm -rf "$PATH_TO_LOCAL_PREFX/bin/bw"

if [ ! -f "$TEMP_DOWNLOAD_PATH/bw-linux-$BITWARDEN_CLI_VERSION.zip" ]; then
    wget "$BITWARDEN_CLI_DOWNLOAD_URL" -O "$TEMP_DOWNLOAD_PATH/bw-linux-$BITWARDEN_CLI_VERSION.zip"
fi

unzip -o "$TEMP_DOWNLOAD_PATH/bw-linux-$BITWARDEN_CLI_VERSION.zip" -d "$PATH_TO_LOCAL_PREFX/bin/"
chmod +x "$PATH_TO_LOCAL_PREFX/bin/bw"
echo "# Bitwarden CLI Install END"
fi

if [[ "$install_mattermost" == "Y" || "$install_mattermost" == "y" ]]; then
echo "# Mattermost Desktop Application Start"
mkdir -p "$PATH_TO_LOCAL_PREFX/share/mattermost-desktop"

if [ ! -f "$TEMP_DOWNLOAD_PATH/mattermost-desktop-$MATTERMOST_VERSION.tar.gz" ]; then
wget "$MATTERMOST_DOWNLOAD_URL" -O "$TEMP_DOWNLOAD_PATH/mattermost-desktop-$MATTERMOST_VERSION.tar.gz"
fi

tar -zxf "$TEMP_DOWNLOAD_PATH/mattermost-desktop-$MATTERMOST_VERSION.tar.gz" -C "$PATH_TO_LOCAL_PREFX/share/mattermost-desktop" --strip-components 1

cat <<EOT > "$PATH_TO_LOCAL_PREFX/share/applications/mattermost-desktop.desktop"
[Desktop Entry]
Type=Application
Version=$MATTERMOST_VERSION
Name=Mattermost
Comment=Mattermost is a secure, open source platform for communication, collaboration, and workflow orchestration across tools and teams.
Path=$PATH_TO_LOCAL_PREFX/share/mattermost-desktop
Exec=$PATH_TO_LOCAL_PREFX/share/mattermost-desktop/mattermost-desktop
Icon=$PATH_TO_LOCAL_PREFX/share/mattermost-desktop/app_icon.png
Terminal=false
Categories=Office;Network;WebBrowser;
EOT
echo "# Mattermost Desktop Application End"
fi

if [[ "$install_postman" == "Y" || "$install_postman" == "y" ]]; then
echo "# Postman Install Start"

rm -rf "$PATH_TO_LOCAL_PREFX/share/Postman"
mkdir -p "$PATH_TO_LOCAL_PREFX/share/Postman"

if [ ! -f "$TEMP_DOWNLOAD_PATH/postman.tar.gz" ]; then
    wget "$POSTMAN_DOWNLOAD_URL" -O "$TEMP_DOWNLOAD_PATH/postman.tar.gz"
fi

tar -zxf "$TEMP_DOWNLOAD_PATH/postman.tar.gz" -C "$PATH_TO_LOCAL_PREFX/share/Postman" --strip-components 1

cat <<EOT > "$PATH_TO_LOCAL_PREFX/share/applications/Postman.desktop"
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=$PATH_TO_LOCAL_PREFX/share/Postman/app/Postman %U
Icon=$PATH_TO_LOCAL_PREFX/share/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOT

echo "# Postman Install END"
fi

if [[ "$install_neovim" == "Y" || "$install_neovim" == "y" ]]; then
echo "# Install neovim Start"

rm -rf "$PATH_TO_LOCAL_PREFX/share/nvim/" "$PATH_TO_LOCAL_PREFX/bin/nvim"
mkdir -p "$PATH_TO_LOCAL_PREFX/share/nvim/"

if [ ! -f "$TEMP_DOWNLOAD_PATH/nvim-$NEOVIM_VERSION.tar.gz" ]; then
    wget "$NEOVIM_DOWNLOAD_URL" -O "$TEMP_DOWNLOAD_PATH/nvim-$NEOVIM_VERSION.tar.gz"
fi

tar -zxf "$TEMP_DOWNLOAD_PATH/nvim-$NEOVIM_VERSION.tar.gz" -C "$PATH_TO_LOCAL_PREFX/share/nvim/" --strip-components 1
ln -s "$PATH_TO_LOCAL_PREFX/share/nvim/bin/nvim" "$PATH_TO_LOCAL_PREFX/bin/nvim"
echo "# Install neovim END"
fi

if [[ "$install_jq" == "Y" || "$install_jq" == "y" ]]; then
echo "# JQ Install Start"

rm -rf "$PATH_TO_LOCAL_PREFX/bin/jq"

if [ ! -f "$TEMP_DOWNLOAD_PATH/jq-$JQ_VERSION" ]; then
    wget "$JQ_DOWNLOAD_URL" -O "$TEMP_DOWNLOAD_PATH/jq-$JQ_VERSION"
fi
cp "$TEMP_DOWNLOAD_PATH/jq-$JQ_VERSION" "$PATH_TO_LOCAL_PREFX/bin/jq"
chmod +x "$PATH_TO_LOCAL_PREFX/bin/jq"
echo "# JQ Install end"
fi

if [[ "$install_go" == "Y" || "$install_go" == "y" ]]; then
echo "# GO Install Start"

rm -rf "$PATH_TO_LOCAL_PREFX/share/go"
mkdir -p "$PATH_TO_LOCAL_PREFX/share/go"

if [ ! -f "$TEMP_DOWNLOAD_PATH/go-$GO_VERSION.linux.tar.gz" ]; then
    wget "$GO_DOWNLOAD_URL" -O "$TEMP_DOWNLOAD_PATH/go-$GO_VERSION.linux.tar.gz"
fi

tar -zxf "$TEMP_DOWNLOAD_PATH/go-$GO_VERSION.linux.tar.gz" -C "$PATH_TO_LOCAL_PREFX/share/go" --strip-components 1

echo "# GO Install End"
fi


if [[ "$install_jdk" == "Y" || "$install_jdk" == "y" ]]; then
echo "# JDK Install Start"

rm -rf "$PATH_TO_LOCAL_PREFX/share/java"
mkdir -p "$PATH_TO_LOCAL_PREFX/share/java"

if [ ! -f "$TEMP_DOWNLOAD_PATH/jdk-${JDK_VERSION}.linux.tar.gz" ]; then
    wget "${JDK_DOWNLOAD_URL}" -O "$TEMP_DOWNLOAD_PATH/jdk-${JDK_VERSION}.linux.tar.gz"
fi

tar -zxf "$TEMP_DOWNLOAD_PATH/jdk-${JDK_VERSION}.linux.tar.gz" -C "$PATH_TO_LOCAL_PREFX/share/java" --strip-components 1

echo "# JDK Install End"
fi

if [[ "$install_maven" == "Y" || "$install_maven" == "y" ]]; then
echo "# Maven Install Start"

rm -rf "$PATH_TO_LOCAL_PREFX/share/maven"
mkdir -p "$PATH_TO_LOCAL_PREFX/share/maven"

if [ ! -f "$TEMP_DOWNLOAD_PATH/mvn-${MAVEN_VERSION}.linux.tar.gz" ]; then
    wget "${MAVEN_DOWNLOAD_URL}" -O "$TEMP_DOWNLOAD_PATH/mvn-${MAVEN_VERSION}.linux.tar.gz"
fi

tar -zxf "$TEMP_DOWNLOAD_PATH/mvn-${MAVEN_VERSION}.linux.tar.gz" -C "$PATH_TO_LOCAL_PREFX/share/maven" --strip-components 1

echo "# Maven Install End"
fi

if [[ "$install_node_js" == "Y" || "$install_node_js" == "y" ]]; then
echo "# Node JS Install Start"

rm -rf "$PATH_TO_LOCAL_PREFX/share/node"
mkdir -p "$PATH_TO_LOCAL_PREFX/share/node"

if [ ! -f "$TEMP_DOWNLOAD_PATH/nodejs-${NODE_JS_VERSION}.linux.tar.xz" ]; then
    wget "${NODE_JS_DOWNLOAD_URL}" -O "$TEMP_DOWNLOAD_PATH/nodejs-${NODE_JS_VERSION}.linux.tar.xz"
fi

tar -xf "$TEMP_DOWNLOAD_PATH/nodejs-${NODE_JS_VERSION}.linux.tar.xz" -C "$PATH_TO_LOCAL_PREFX/share/node" --strip-components 1

echo "# Node JS Install End"
fi

if [[ "$install_ncurses" == "Y" || "$install_ncurses" == "y" ]]; then
echo "# Ncurses Install Start"

rm -rf "$SOURCE_PACKAGE_PATH/ncurses"
mkdir -p "$SOURCE_PACKAGE_PATH/ncurses"

if [ ! -f "$TEMP_DOWNLOAD_PATH/ncurses-${NCURSES_VERSION}.linux.tar.gz" ]; then
    wget "${NCURSES_DOWNLOAD_URL}" -O "$TEMP_DOWNLOAD_PATH/ncurses-${NCURSES_VERSION}.linux.tar.gz"
fi

tar -zxf "$TEMP_DOWNLOAD_PATH/ncurses-${NCURSES_VERSION}.linux.tar.gz" -C "$SOURCE_PACKAGE_PATH/ncurses" --strip-components 1

cd "$SOURCE_PACKAGE_PATH/ncurses"
"./configure" --prefix="$PATH_TO_LOCAL_PREFX" --with-shared --without-debug --enable-widec
make
make install
echo "# Ncurses Install end"
fi

if [[ "$install_zsh" == "Y" || "$install_zsh" == "y" ]]; then
echo "# ZSH Install Start"

rm -rf "$SOURCE_PACKAGE_PATH/zsh"
mkdir -p "$SOURCE_PACKAGE_PATH/zsh"

if [ ! -f "$TEMP_DOWNLOAD_PATH/zsh-${ZSH_VERSION}.linux.tar.xz" ]; then
    wget "${ZSH_DOWNLOAD_URL}" -O "$TEMP_DOWNLOAD_PATH/zsh-${ZSH_VERSION}.linux.tar.xz"
fi

tar -xf "$TEMP_DOWNLOAD_PATH/zsh-${ZSH_VERSION}.linux.tar.xz" -C "$SOURCE_PACKAGE_PATH/zsh" --strip-components 1

cd "$SOURCE_PACKAGE_PATH/zsh"
"./configure" --prefix="$PATH_TO_LOCAL_PREFX" --with-shared --without-debug --enable-widec
make
make install
echo "# ZSH Install end"
fi

if [[ "$install_openssl" == "Y" || "$install_openssl" == "y" ]]; then
echo "# Openssl Install Start"

rm -rf "$SOURCE_PACKAGE_PATH/ssl"
mkdir -p "$SOURCE_PACKAGE_PATH/ssl"

if [ ! -f "$TEMP_DOWNLOAD_PATH/ssl-${OPENSSL_VERSION}.linux.tar.gz" ]; then
    wget "${OPENSSL_DOWNLOAD_URL}" -O "$TEMP_DOWNLOAD_PATH/ssl-${OPENSSL_VERSION}.linux.tar.gz"
fi

tar -zxf "$TEMP_DOWNLOAD_PATH/ssl-${OPENSSL_VERSION}.linux.tar.gz" -C "$SOURCE_PACKAGE_PATH/ssl" --strip-components 1

cd "$SOURCE_PACKAGE_PATH/ssl"
"./Configure" --prefix="$PATH_TO_LOCAL_PREFX" shared zlib
make
make install
echo "# Openssl Install end"
fi
