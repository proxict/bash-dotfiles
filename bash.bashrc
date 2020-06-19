# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return
# This should do the same as the above, just a different way to be sure
[[ $- != *i* ]] && return

if [[ -f /etc/bash/bash_ps1 ]]; then
    source /etc/bash/bash_ps1
    export PROMPT_COMMAND=prompt_command
else
    export PROMPT_COMMAND=fallback_prompt_command
fi

#if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#  exec tmux -u -2
#fi

export HISTCONTROL=ignoreboth:erasedups
HISTSIZE= HISTFILESIZE= # Infinite history
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

[[ -f /etc/bash/aliases ]] && . /etc/bash/aliases
[[ -f /etc/bash/bash_globals ]] && . /etc/bash/bash_globals
[[ -f /etc/bash/less_colors ]] && . /etc/bash/less_colors
[[ -f /etc/dircolors ]] && eval "$(dircolors -b /etc/dircolors)"

[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases
[[ -f ~/.bash_globals ]] && . ~/.bash_globals
[[ -f ~/.profile ]] && . ~/.profile
[[ -f ~/.bash_profile ]] && . ~/.bash_profile

# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
    function command_not_found_handle {
        # check because c-n-f could've been removed in the meantime
        if [ -x /usr/lib/command-not-found ]; then
            /usr/lib/command-not-found -- "$1"
            return $?
        elif [ -x /usr/share/command-not-found/command-not-found ]; then
            /usr/share/command-not-found/command-not-found -- "$1"
            return $?
        else
            printf "%s: command not found\n" "$1" >&2
            return 127
       fi
    }
fi

function fallback_prompt_command() {
    local EXIT="$?"
    # colors!
    local red="\[\e[0;31m\]"
    local lightGray="\[\e[0;37m\]"
    local straightLine="\342\224\200"
    local lightGrayEx="\[\x1b[38;2;220;220;220m\]"
    local lightBlueEx="\[\x1b[38;2;102;217;239m\]"
    local lightMagentaEx="\[\x1b[38;2;249;38;114m\]"
    local lightPurpleEx="\[\x1b[38;2;174;129;255m\]"
    local lightGreenEx="\[\x1b[38;2;166;226;46m\]"
    local resetEx="\[\x1b[0m\]"

    user="$(printf ${lightBlueEx}${USER}${resetEx})"
    at="$(printf ${lightPurpleEx}@${resetEx})"
    hostname="$(printf ${lightMagentaEx}${HOSTNAME}${resetEx})"
    dir="$(printf ${lightGrayEx}[${lightGreenEx}$(dirs)${lightGrayEx}]${resetEx})"

    error=""
    if [ $EXIT != 0 ]; then
        error="[${red}${EXIT}${lightGray}]${straightLine}"
    fi

    PS1="${error}[${user}${at}${hostname}]-${dir}\$ "
}
