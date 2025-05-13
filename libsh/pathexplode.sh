# Shell functions for unpacking file paths
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

__shellboost_include libsh/text.sh || return $?

path_explode_eval() {
    local path exploded IFS
    path="${1?}"
    IFS=/
    set -- $path
    exploded=
    if [ $# -gt 0 -a -z "$1" ]; then
        exploded=/
        while [ $# -gt 0 -a -z "$1" ]; do
            shift
        done
    fi
    while [ $# -gt 0 ]; do
        exploded="$exploded${exploded:+ }$(quoted "$1")"
        shift
        if [ $# -gt 0 ]; then
            exploded="$exploded /"
            while [ $# -gt 0 -a -z "$1" ]; do
                shift
            done
        elif [ "${path%/}" != "$path" ]; then
            exploded="$exploded /"
        fi
    done
    echo "$exploded"
}

path_explode_index() {
    local a n IFS
    a="$(path_explode_eval "$1")"
    n=$(($2 + 1))
    IFS=' '
    eval set -- "$a"
    [ $n -le $# ] && eval echo \$$n
}

path_common_prefix() {
    local path prefix newprefix n pathcomp prefixcomp
    prefix="${1?}"
    shift
    for path; do
        newprefix=
        n=0
        while pathcomp="$(path_explode_index "$path" $n)" && prefixcomp="$(path_explode_index "$prefix" $n)" && [ "$pathcomp" = "$prefixcomp" ]; do
            newprefix="$newprefix$prefixcomp"
            n=$((n+1))
        done
        prefix="$newprefix"
    done
    echo "$prefix"
}
