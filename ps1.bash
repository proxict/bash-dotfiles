#shellcheck disable=SC1090
#shellcheck disable=SC1091

function _reset() { echo -ne "\[$(tput sgr0)\]"; }
function _fg() { echo -ne "\[$(tput setaf "$1")\]"; }
function _bg() { echo -ne "\[$(tput setab "$1")\]"; }
function _fgbg() { _fg "$1"; _bg "$2"; }
function _bold() { echo -ne "\[$(tput bold)\]"; }

PS1_SEPARATOR=${PS1_SEPARATOR:-"\uE0B0"}
PS1_INCLUDE_HOSTNAME=${PS1_INCLUDE_HOSTNAME:-true}
PS1_MULTILINE=${PS1_MULTILINE:-true}
PS1_ERROR_FG=${PS1_ERROR_FG:-0}
PS1_ERROR_BG=${PS1_ERROR_BG:-1}
PS1_USERNAME_FG=${PS1_USERNAME_FG:-0}
PS1_USERNAME_BG=${PS1_USERNAME_BG:-12}
PS1_AT_FG=${PS1_AT_FG:-0}
PS1_HOSTNAME_FG=${PS1_HOSTNAME_FG:-0}
PS1_DIR_FG=${PS1_DIR_FG:-11}
PS1_DIR_BG=${PS1_DIR_BG:-8}
PS1_GIT_FG=${PS1_GIT_FG:-15}
PS1_GIT_BG=${PS1_GIT_BG:-5}

_PS1_FIRST_BLOCK="Y"
function __ps1_draw_separator() {
    [ "${_PS1_FIRST_BLOCK}" = "N" ] && PS1+="$(echo -en "${PS1_SEPARATOR}")" || _PS1_FIRST_BLOCK="N"
}

function _ps1_block_line_end() {
    PS1+="$(echo -en "${PS1_SEPARATOR}")"
    _PS1_FIRST_BLOCK="Y"
}

function _ps1_block_error() {
    [ "$1" -eq 0 ] && return
    PS1+="$(_bg "${PS1_ERROR_BG}")" && __ps1_draw_separator
    PS1+="$(_fg "${PS1_ERROR_FG}") $(echo -en "\uea87") $1 $(_reset; _fg "${PS1_ERROR_BG}")"
}

function _ps1_block_username() {
    PS1+="$(_bg "${PS1_USERNAME_BG}")" && __ps1_draw_separator
    PS1+="$(_bold; _fg "${PS1_USERNAME_FG}") ${USER}"
    if [ -n "${SSH_CLIENT}" ] || [ "${PS1_INCLUDE_HOSTNAME}" = true ]; then
        PS1+="$(_fg "${PS1_AT_FG}")@$(_fg "${PS1_HOSTNAME_FG}")${HOSTNAME}"
    fi
    PS1+=" $(_reset; _fg "${PS1_USERNAME_BG}")"
}

function _ps1_block_directory() {
    PS1+="$(_bg "${PS1_DIR_BG}")" && __ps1_draw_separator
    PS1+="$(_fg "${PS1_DIR_FG}") ${DIRS} $(_reset; _fg "${PS1_DIR_BG}")"
}

function _ps1_block_git() {
    local GIT_BRANCH
    GIT_BRANCH="$(git branch --show-current 2>/dev/null)" || return

    PS1+="$(_bg "${PS1_GIT_BG}")" && __ps1_draw_separator

    local GIT_STATUS
    GIT_STATUS="$(git status -s | cut -c-2 | sort -u)"

    local GIT_STATUS_STR=""
    echo "${GIT_STATUS}" | grep '^M $' &>/dev/null && GIT_STATUS_STR+="$(echo -ne "\u2714")"
    echo "${GIT_STATUS}" | grep '^ M$' &>/dev/null && GIT_STATUS_STR+="$(echo -ne "\u2717")"
    echo "${GIT_STATUS}" | grep '??' &>/dev/null && GIT_STATUS_STR+="*"
    [ -n "${GIT_STATUS_STR}" ] && GIT_STATUS_STR=" ${GIT_STATUS_STR}"

    PS1+="$([ "${GIT_BRANCH}" = "master" ] && _bold)$(_fg "${PS1_GIT_FG}") $(echo -en "\uE0A0") ${GIT_BRANCH}${GIT_STATUS_STR} $(_reset; _fg "${PS1_GIT_BG}")"
}

function prompt_command() {
    local EXIT="$?"

    DIRS="$(dirs)"
    [ "${DIRS}" = '~' ] && DIRS="$(echo -en "\uf015")"

    PS1=""

    _ps1_block_error "${EXIT}"
    _ps1_block_username
    _ps1_block_directory
    _ps1_block_git
    _ps1_block_line_end

    # Prompt
    if [ "${PS1_MULTILINE}" = true ]; then
        PS1+="\n$(_reset)$(echo -en "\uf054") "
    else
        PS1+="$(_reset) "
    fi
}

