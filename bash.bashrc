#shellcheck disable=SC1090
#shellcheck disable=SC1091

# System-wide .bashrc file f'or interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return
# This should do the same as the above, just a different way to be sure
[[ $- != *i* ]] && return

export HISTCONTROL=ignoreboth:erasedups
HISTSIZE='' HISTFILESIZE='' # Infinite history
HISTIGNORE='rm *:git reset*'

# Prepend cd to directory names automatically
shopt -s autocd 2> /dev/null
# Correct spelling errors during tab-completion
shopt -s dirspell 2> /dev/null
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell 2> /dev/null
# Turn on recursive globbing (enables ** to recurse all directories)
shopt -s globstar 2> /dev/null

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# This allows you to bookmark your favorite places across the file system
# Define a variable containing a path and you will be able to cd into it regardless of the directory you're in
shopt -s cdable_vars

[[ -f /etc/bash/aliases.bash ]] && source /etc/bash/aliases.bash
[[ -f /etc/bash/globals.bash ]] && source /etc/bash/globals.bash
[[ -f /etc/bash/less_colors ]] && source /etc/bash/less_colors
[[ -f /etc/dircolors ]] && eval "$(dircolors -b /etc/dircolors)"

[[ -f "${HOME}/.bashrc" ]] && source "${HOME}/.bashrc"
[[ -f "${HOME}/.bash_aliases" ]] && source "${HOME}/.bash_aliases"
[[ -f "${HOME}/.bash_globals" ]] && source "${HOME}/.bash_globals"
[[ -f "${HOME}/.profile" ]] && source "${HOME}/.profile"
[[ -f "${HOME}/.bash_profile" ]] && source "${HOME}/.bash_profile"

# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

if [ "${TERM}" != "linux" ] && [ -f /etc/bash/ps1.bash ] && source /etc/bash/ps1.bash; then
    export PROMPT_COMMAND=prompt_command
else
    export PROMPT_COMMAND=fallback_prompt_command
fi

function fallback_prompt_command() {
    PS1="[\[$(tput setaf 3)\]${USER}\[$(tput sgr0)\]]-[\[$(tput setaf 2)\]$(dirs)\[$(tput sgr0)\]]\$ "
}

