# $1 reference to segment array
# $2 reference to segmentStyle array
# $3 segment
function printSegment() {
    [ -z "$3" ] && tput sgr0 && return
    local -n _segment=$1
    local -n _segmentStyle=$2

    local value="${_segment["$3"]}"
    [ -z "${value}" ] && value="$3"

    local style="${_segmentStyle["$3"]}"
    local escapedStyle
    [ -n "${style}" ] && \
        read -ra style <<<"${style}" && \
        escapedStyle="\[$(tput setaf "${style[@]}")\]"

    echo -en "${escapedStyle}${value}\[$(tput sgr0)\]"
}

