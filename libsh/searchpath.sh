# Shell functions for manipulating $PATH and other variables
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

# searchpath_find path name [predicate ...]
#
# Traverses the given path, executing "predicate ... $component/name" for every
# component; if the predicate command returns true, prints $component/name and
# returns true immediately otherwise, returns false after full traversal if no
# test returned true.  If no predicate is supplied, uses "test -x".
#
# Example:
#     searchpath_find "$PATH" awk
# prints
#     /usr/bin/awk
#
searchpath_find() {
    local __path __name __element __IFS
    __path="${1?}"
    __name="${2?}"
    shift 2
    [ $# -ne 0 ] || set -- test -x
    __IFS="$IFS"
    IFS=:
    for __element in $__path; do
        if "$@" "$__element/$__name"; then
            IFS="$__IFS"
            echo "$__element/$__name"
            return 0
        fi
    done
    IFS="$__IFS"
    return 1
}

# searchpath_contains PATHVAR [ value1 [ value2 ... ] ]
# Returns true if any of value1 or value2 etc. are in $PATHVAR
searchpath_contains() {
    local __var __path __arg __element __IFS
    __var="${1?}"
    shift
    eval __path=\"\$$__var\"
    __IFS="$IFS"
    IFS=:
    for __element in $__path; do
        for __arg; do
            if [ "$__arg" = "$__element" ]; then
                IFS="$__IFS"
                return 0
            fi
        done
    done
    IFS="$__IFS"
    return 1
}

# Predicate function for searchpath_find() and searchpath_contains().
executable_not_self() {
    test -x "$1" -a ! \( "$0" -ef "$1" \)
}

# Finds an executable in $PATH with the same name as the script, excluding the
# script itself.  Useful in "wrapper" scripts that need to "chain" to the
# command that they wrap:
#      exec "$(searchpath_chain)" "$@"
searchpath_chain() {
    local __name="${0##*/}"
    if ! searchpath_find "$PATH" "$__name" executable_not_self; then
        echo "not found: $__name" >&2
        exit 1
    fi
}

# searchpath_append PATHVAR [ value1 [ value2 ... ] ]
# Appends value1, value2 etc. to $PATHVAR if not already somewhere in $PATHVAR
searchpath_append() {
    local __var __arg
    __var="${1?}"
    shift
    for __arg; do
        searchpath_contains $__var "$__arg" || eval $__var=\"\$$__var\${$__var:+:}\$__arg\"
    done
}

# searchpath_append_force PATHVAR [ value1 [ value2 ... ] ]
# Appends value1, value2 etc. to $PATHVAR after removing value1, value2 etc.
# from anywhere else in $PATHVAR
searchpath_append_force() {
    searchpath_remove "$@"
    searchpath_append "$@"
}

# searchpath_prepend PATHVAR [ value1 [ value2 ... ] ]
# Prepends value1, value2 etc. to $PATHVAR if not already somewhere in $PATHVAR
searchpath_prepend() {
    local __var __i __arg
    __var="${1?}"
    shift
    __i=$#
    while [ $__i -gt 0 ]; do
        eval __arg=\"\$$__i\"
        searchpath_contains $__var "$__arg" || eval $__var=\"\$__arg\${$__var:+:}\$$__var\"
        __i=$((__i - 1))
    done
}

# searchpath_prepend_force PATHVAR [ value1 [ value2 ... ] ]
# Prepends value1, value2 etc. to $PATHVAR after removing value1, value2 etc.
# from anywhere else in $PATHVAR
searchpath_prepend_force() {
    searchpath_remove "$@"
    searchpath_prepend "$@"
}

# searchpath_remove PATHVAR [ value1 [ value2 ... ] ]
# Removes value1, value2 etc. from $PATHVAR
searchpath_remove() {
    local __var __path __newpath __arg __element __IFS
    __var="${1?}"
    shift
    eval __path=\"\$$__var\"
    __newpath=
    __IFS="$IFS"
    IFS=:
    for __element in $__path; do
        for __arg; do
            [ "$__arg" = "$__element" ] && continue 2
        done
        __newpath="$__newpath${__newpath:+:}$__element"
    done
    IFS="$__IFS"
    eval $__var=\"\$__newpath\"
}

# searchpath_remove_prefixed PATHVAR [ prefix1 [ prefix2 ... ] ]
# Removes all elements starting with prefix1 or prefix2 etc. from $PATHVAR
searchpath_remove_prefixed() {
    local __var __path __newpath __arg __element __IFS
    __var="${1?}"
    shift
    eval __path=\"\$$__var\"
    __newpath=
    __IFS="$IFS"
    IFS=:
    for __element in $__path; do
        for __arg; do
            case "$__element" in
            "$__arg"* ) continue 2;;
            esac
        done
        __newpath="$__newpath${__newpath:+:}$__element"
    done
    IFS="$__IFS"
    eval $__var=\"\$__newpath\"
}
