#
# ~/.bashrc
#

# If not running interactively, don't do anything

if command -v javac &> /dev/null ; then
	javacexecpath=$(readlink -f $(which javac))
	export JAVA_HOME=${javacexecpath::-9}
elif command -v java &> /dev/null ; then
	echo "Java compiler not installed which is not recommended, Using java instead"
	javaexecpath=$(readlink -f $(which java))
	export JAVA_HOME=${javaexecpath::-9}
else
	echo "Java not installed, please install java"
fi

if command -v mvn &> /dev/null ; then
	mvnexecpath=$(readlink -f $(which mvn))
	export M2_HOME=${mvnexecpath::-8}
	export MAVEN_HOME=${M2_HOME}
else
	echo "maven not installed, please install maven"
fi

alias ls='ls --color=auto'
alias ll='ls --color=auto -alrh'
alias df='sudo df -h'
alias ssh='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias sftp='sftp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias codesudo="sudo code --user-data-dir=$HOME/.vscode-root --no-sandbox"
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/bare --work-tree=$HOME'

[[ $- != *i* ]] && return

export BASH_IT="$HOME/.bash_it"
export BASH_IT_THEME='makemyarch'
export BASH_IT_REMOTE='https://github.com/arpanrec/bash-it'
export BASH_IT_DEVELOPMENT_BRANCH='master'
unset MAILCHECK
export IRC_CLIENT='irssi'
export TODO="t"
export BASH_IT_COMMAND_DURATION=true
export COMMAND_DURATION_MIN_SECONDS=1
export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1
export THEME_SHOW_EXITCODE=true
source "$BASH_IT/bash_it.sh"
