# Shell functions for manipulating text
# vim:sts=3 sw=3 ts=8 et
# Copyright 2025 Andrew Bettison
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

__restore_extglob="$(shopt -p extglob)"
shopt -s extglob

# Turn all arguments into shell quoted strings which can safely be used as eval
# arguments.
quoted() {
    local var
    printf -v var " %q" "$@"
    printf '%s\n' "${var# }"
}

# Strip characters from start of argument.  If no chars given, default is whitespace.
# lstrip arg [chars]
lstrip() {
    local __restore_extglob="$(shopt -p extglob)"
    shopt -s extglob
    local text="$1"
    local chars="${2:- 	
}"
    echo "${text##*(["$chars"])}"
    eval "$__restore_extglob"
}

# Strip characters from end of argument.  If no chars given, default is whitespace.
# rstrip arg [chars]
rstrip() {
    local __restore_extglob="$(shopt -p extglob)"
    shopt -s extglob
    local text="$1"
    local chars="${2:- 	
}"
    echo "${text%%*(["$chars"])}"
    eval "$__restore_extglob"
}

# Strip characters from start and end of argument.  If no chars given, default
# is whitespace.
# strip arg [chars]
strip() {
   rstrip "$(lstrip "$1" "$2")" "$2"
}

eval "$__restore_extglob"
unset __restore_extglob
