#!/usr/bin/env bash
#
# ~/.bashrc
#

if [ -f "/etc/bashrc" ]; then
	source /etc/bashrc
fi

if [ -f /etc/bash.bashrc ]; then
	source /etc/bash.bashrc
fi

if [ -f /usr/local/bin/zsh ]; then
	export SHELL=/usr/local/bin/zsh
	exec /usr/local/bin/zsh -l
fi

[ -f "$HOME/.exporterrc" ] && source $HOME/.exporterrc
[ -f "$HOME/.aliasrc" ] && source $HOME/.aliasrc

if [ -f "$HOME/.dotfiles/linode_cli_completion.sh" ]; then
	source "$HOME/.dotfiles/linode_cli_completion.sh"
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export BASH_IT="$HOME/.bash_it"
if [ -f "$BASH_IT/bash_it.sh" ]; then
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
fi

if hash powerline-shell &>/dev/null && [[ ! -f "$BASH_IT/bash_it.sh" ]]; then
	function _update_ps1() {
		PS1=$(powerline-shell $?)
	}
	if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
		PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
	fi
fi
