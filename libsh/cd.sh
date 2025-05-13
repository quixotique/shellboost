# Shell functions for changing current working directory
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

__run() {
    if [ "$1" = '!' ]; then
        shift
        __run "$@" && return 1
        return 0
    fi
    "$@"
}

cd_up_until() {
    local dir
    dir="$PWD"
    while true; do
        __run "$@" && return 0
        [ "$PWD" = / ] && break
        cd .. >/dev/null || break
    done
    cd "$dir" >/dev/null
    return 1
}

cd_down_until() {
    if [ "$PWD" = / ]; then
        __run "$@" && return 0
    else
        local dir
        dir="${PWD##*/}"
        cd .. >/dev/null
        cd_down_until "$@" && return 0
        __run "$@" && return 0
        cd "$dir" >/dev/null
    fi
    return 1
}
