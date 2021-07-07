# Shell functions for manipulating time and duration
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

__had_extglob=false
shopt -q extglob && __had_extglob=true
shopt -s extglob

# is_duration <text>
#
# Return 0 if the given <text> is a duration, eg: 1h30m, 3w2d, 500s
#
is_duration() {
    [[ $1 =~ ^([0-9]+[smhdw])+$ ]]
}

# duration_to_minutes <text>
#
# Print the number of minutes in the duration <text>, rounded up to the nearest minute.
#
duration_to_minutes() {
    local __had_extglob=false
    shopt -q extglob && __had_extglob=true
    shopt -s extglob
    local duration="$1"
    local minutes=0
    is_duration "$duration" || fatal "invalid duration: $duration"
    while [[ ${#duration} -ne 0 ]]; do
        local remain="${duration#+([0-9])[shmdw]}"
        local part="${duration%$remain}"
        duration="$remain"
        case $part in
        +(0)s) ;;
        *s) let minutes+=1;;
        *m) let minutes+=${part%?};;
        *h) let minutes+=${part%?}*60;;
        *d) let minutes+=${part%?}*60*60;;
        *w) let minutes+=${part%?}*60*60*7;;
        *) fatal "bad duration part: $part"
        esac
    done
    echo $minutes
    $__had_extglob || shopt -u extglob
}

$__had_extglob || shopt -u extglob
unset __had_extglob
