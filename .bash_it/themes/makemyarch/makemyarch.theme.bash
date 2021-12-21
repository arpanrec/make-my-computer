# shellcheck shell=bash
# shellcheck disable=SC2034 # Expected behavior for themes.
# shellcheck disable=SC2154 #TODO: fix these all.

SCM_THEME_PROMPT_DIRTY=" ${red}✗"
SCM_THEME_PROMPT_CLEAN=" ${bold_green}✓"
SCM_THEME_PROMPT_PREFIX=" ${green}|"
SCM_THEME_PROMPT_SUFFIX="${green}|"

GIT_THEME_PROMPT_DIRTY=" ${red}✗"
GIT_THEME_PROMPT_CLEAN=" ${bold_green}✓"
GIT_THEME_PROMPT_PREFIX=" ${green}|"
GIT_THEME_PROMPT_SUFFIX="${green}|"

RVM_THEME_PROMPT_PREFIX="|"
RVM_THEME_PROMPT_SUFFIX="|"

__bobby_clock() {
	if [ "${THEME_SHOW_CLOCK_CHAR}" == "true" ]; then
		printf '%s' "$(clock_char)"
	fi
	printf '%s' "$(clock_prompt)"
}

__exitcode() {
	[ "${THEME_SHOW_EXITCODE}" != "true" ] && return
	if [[ $exitcode -gt 0 ]]; then printf "${bold_red}⛔ ${exitcode}" ;
	else printf "${bold_green}👌 ${exitcode}"; fi
}

function prompt_command() {
	exitcode="$?"
	PS1="\n$(__exitcode)\n$(__bobby_clock)"
	PS1+="${yellow}$(virtualenv_prompt) "
	PS1+="${purple}👽 \u ${white}@ ${green}🖥 \h ${white}in ${bold_orange} 🗄 \w "
	PS1+="${bold_cyan}$(scm_prompt_char_info) "
	PS1+="\n${green}> ${reset_color}"
}

THEME_SHOW_CLOCK_CHAR=${THEME_SHOW_CLOCK_CHAR:-"true"}
THEME_CLOCK_CHAR_COLOR=${THEME_CLOCK_CHAR_COLOR:-"$red"}
THEME_CLOCK_COLOR=${THEME_CLOCK_COLOR:-"$bold_cyan"}
THEME_CLOCK_FORMAT=${THEME_CLOCK_FORMAT:-"%Y-%m-%d %H:%M:%S"}

safe_append_prompt_command prompt_command
