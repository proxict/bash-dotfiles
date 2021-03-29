#!/bin/bash

parse_git_branch() {
    GITSTATUS="$(git status 2> /dev/null)"
    if [[ "$(echo "${GITSTATUS}" | grep "Changes to be committed")" != "" ]]; then
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1***)/'
    elif [[ "$(echo "${GITSTATUS}" | grep "Changes not staged for commit")" != "" ]]; then
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1**)/'
    elif [[ "$(echo "${GITSTATUS}" | grep "Untracked")" != "" ]]; then
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1*)/'
    elif [[ "$(echo "${GITSTATUS}" | grep "nothing to commit")" != "" ]]; then
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
    else
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1?)/'
    fi
}

