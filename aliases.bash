# make sure these aliases also work with sudo
alias sudo='sudo '

# The default behavior of su is to remain within the current directory and to maintain
# the environmental variables of the original user (rather than switch to those of
# the new user).
# 'su -l' switches from the current directory to the home directory of the new user
# (e.g., to /root in the case of the root user) by logging in as that user.
# Also, it changes the environmental variables to those of the new user as
# dictated by their ~/.bashrc. That is, the current directory and environment
# will be changed to what would be expected if the new user had actually logged-on
# to a new session (rather than just taking over an existing session).
# https://wiki.archlinux.org/index.php/Su
alias su='su -l'

alias ls='ls --color=auto --group-directories-first'
alias l='ls -lh'
alias ll='ls -l'
alias lll='ls -lhAF'
alias llll='ls -lAF'
alias grep='grep --color=auto'
alias bd='. bd -si'

# Avoid making irreversible mistakes
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

alias vim='nvim'

