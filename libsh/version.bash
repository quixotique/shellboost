# Shell functions for manipulating text
# vim:sts=3 sw=3 ts=8 et
# Copyright 2021 Andrew Bettison
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

# compare_versions VAR LHS RHS
#
# Compare two strings LHS and RHS as version numbers and set the VAR variable
# accordingly:
#   VAR=-1 if LHS is older (less) than RHS
#   VAR=1  if LHS is newer (greater) than RHS
#   VAR=0  if LHS is the same (equal) as RHS
#
# The LHS and RHS strings are compared by considering each as a sequence of
# alternating numerical and non-numerical parts, eg:
#   gdal-3.1.11-3a  -->  gdal-  3  .  1  .  11  -  3  a
#
# These parts are then compared such that:
#  - two numerical parts are compared numerically by interpreting them as
#    non-negative decimal integers
#  - two non-numerical parts are compared lexically using the current locale
#  - a numerical part is always considered to be newer (greater) than a
#    non-numerical part
#
# Return a zero exit status if VAR=0; this does not necessarily mean that LHS
# and RHS are lexically identical, because version comparison ignores leading
# zeroes.
#
compare_versions() {
    local -n var="${1?}"
    local lhs="${2?}"
    local rhs="${3?}"
    var=0
    local __had_extglob=false
    shopt -q extglob && __had_extglob=true
    shopt -s extglob
    local lhspart lhsrem lhsnum rhspart rhsnum rhsrem
    while [[ -n $lhs && -n $rhs ]]; do
        # Consume leading decimal numbers from lhs and rhs
        lhsrem="${lhs##+([0-9])}"
        rhsrem="${rhs##+([0-9])}"
        lhsnum="${lhs%$lhsrem}"
        rhsnum="${rhs%$rhsrem}"
        if [[ -n $lhsnum && -n $rhsnum ]]; then
            var=$((lhsnum < rhsnum ? -1 : lhsnum > rhsnum ? 1 : 0))
            [[ $var -ne 0 ]] && break
        elif [[ $rhsnum ]]; then
            # if lhs starts with non-numeric and rhs with numeric, then lhs < rhs
            var=-1
            break
        elif [[ $lhsnum ]]; then
            # if lhs starts with numeric and rhs with nonnumeric, then lhs > rhs
            var=1
            break
        else
            # Consume leading non-numbers from lhs and rhs
            lhsrem="${lhs##+([!0-9])}"
            rhsrem="${rhs##+([!0-9])}"
            lhspart="${lhs%$lhsrem}"
            rhspart="${rhs%$rhsrem}"
            if [[ $lhspart < $rhspart ]]; then
                var=-1
                break
            elif [[ $lhspart > $rhspart ]]; then
                var=1
                break
            fi
        fi
        lhs="$lhsrem"
        rhs="$rhsrem"
    done
    # if lhs has suffix that rhs does not, then lhs > rhs
    if ((var == 0)); then
        if [[ -n $lhs ]]; then
            var=1
        elif [[ -n $rhs ]]; then
            var=-1
        fi
    fi
    $__had_extglob || shopt -u extglob
    return $((var == 0 ? 0 : 1))
}

lowest_version() {
    [[ $# -eq 0 ]] && return 1
    local lowest="$1"
    shift
    local arg __cmp
    for arg; do
        compare_versions __cmp "$lowest" "$arg"
        [[ $__cmp -gt 0 ]] && lowest="$arg"
    done
    echo "$lowest"
    return 0
}

highest_version() {
    [[ $# -eq 0 ]] && return 1
    local highest="$1"
    shift
    local arg __cmp
    for arg; do
        compare_versions __cmp "$highest" "$arg"
        [[ $__cmp -lt 0 ]] && highest="$arg"
    done
    echo "$highest"
    return 0
}
