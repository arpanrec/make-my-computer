if [ -f "$HOME/.dotfiles/bashsecrets.sh" ]; then
	source "$HOME/.dotfiles/bashsecrets.sh"
fi

if [ -f "$HOME/.dotfiles/linode_cli_completion.sh" ]; then
	source "$HOME/.dotfiles/linode_cli_completion.sh"
fi

if [ command -v javac &>/dev/null ]; then
	javacexecpath=$(readlink -f "$(which javac)")
	export JAVA_HOME=${javacexecpath::-10}
elif [ command -v java &>/dev/null ]; then
	echo "Java compiler not installed which is not recommended, Using java instead"
	javaexecpath=$(readlink -f "$(which java)")
	export JAVA_HOME=${javaexecpath::-9}
else
	echo "Java not installed, please install java"
fi

if [ -f "$HOME/.local/share/maven/bin/mvn" ]; then
	export PATH=$HOME/.local/share/maven/bin:$PATH
fi

if command -v mvn &>/dev/null; then
	mvnexecpath=$(readlink -f "$(which mvn)")
	export M2_HOME=${mvnexecpath::-8}
	export MAVEN_HOME=${M2_HOME}
else
	echo "maven not installed, please install maven"
fi

export PATH=$HOME/.local/bin:$PATH
GPG_TTY="$(tty)"
export GPG_TTY

if hash vim &>/dev/null; then
	export EDITOR=vim
fi

alias ls="ls --color=auto"
alias ll="ls --color=auto -alrh"
alias df="sudo df -h"
#alias ssh="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
alias sftp="sftp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
alias codesudo="sudo code --user-data-dir=/tmp/vscode-root-user-data-dir --no-sandbox"
alias config='git --git-dir="$HOME/.dotfiles/bare" --work-tree=$HOME'
print imported common