set -ex
MATTERMOST_VERSION=5.0.2
mkdir -p "$HOME/tmp/" "$HOME/.local/bin" "$HOME/.local/share/mattermost-desktop"
if [ ! -f "$HOME/tmp/bw-linux.zip" ]; then
    wget https://github.com/bitwarden/cli/releases/download/v1.20.0/bw-linux-1.20.0.zip -O $HOME/tmp/bw-linux.zip
fi
unzip -o $HOME/tmp/bw-linux.zip -d $HOME/.local/bin/
chmod +x $HOME/.local/bin/bw

if [ ! -f "$HOME/tmp/mattermost-desktop-$MATTERMOST_VERSION-linux-x64.tar.gz" ]; then
    wget "https://releases.mattermost.com/desktop/$MATTERMOST_VERSION/mattermost-desktop-$MATTERMOST_VERSION-linux-x64.tar.gz?src=dl" -O "$HOME/tmp/mattermost-desktop-$MATTERMOST_VERSION-linux-x64.tar.gz"
fi

tar -zxvf "$HOME/tmp/mattermost-desktop-$MATTERMOST_VERSION-linux-x64.tar.gz" -C "$HOME/.local/share/mattermost-desktop" --strip-components 1

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
