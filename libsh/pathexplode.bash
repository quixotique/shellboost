# Bash functions for unpacking file paths
# vim:sts=4 sw=4 ts=8 et
# Copyright 2015 Andrew Bettison
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

path_explode_array() {
    local __path __exploded __arrayvar IFS
    __path="${1?}"
    __arrayvar="${2?}"
    IFS=/
    set -- $__path
    IFS=' '
    __exploded=()
    if [ $# -gt 0 -a -z "$1" ]; then
        __exploded+=(/)
        while [ $# -gt 0 -a -z "$1" ]; do
        shift
        done
    fi
    while [ $# -gt 0 ]; do
        __exploded+=("$1")
        shift
        if [ $# -gt 0 ]; then
            __exploded+=(/)
            while [ $# -gt 0 -a -z "$1" ]; do
                shift
            done
        elif [ "${__path%/}" != "$__path" ]; then
            __exploded+=(/)
        fi
    done
    eval $__arrayvar='("${__exploded[@]}")'
}

path_explode_index() {
    local a n
    path_explode_array "$1" a
    n=$(($2+0))
    [ $n -lt ${#a[*]} ] && echo "${a[$n]}"
}

path_common_prefix() {
    local arg prefix argprefix n an IFS
    path_explode_array "${1?}" prefix
    n=${#prefix[*]}
    shift
    IFS=
    for arg; do
        path_explode_array "$arg" argprefix
        an=${#argprefix[*]}
        while [ $an -gt $n ]; do
            an=$((an-1))
            unset argprefix[$an]
        done
        while [ $n -gt 0 -a \( $n -gt $an -o "${prefix[*]}" != "${argprefix[*]}" \) ]; do
            n=$((n-1))
            unset argprefix[$n]
            unset prefix[$n]
        done
    done
    echo "${prefix[*]}"
}
