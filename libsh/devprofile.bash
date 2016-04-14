# Bash functions for developer profile
# vim:sts=4 sw=4 ts=8 et
# Copyright 2015-2016 Andrew Bettison
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

# A valid devprofile name is the name of any immediate sub-directory of $HOME
# that contains either a .bash_profile or .profile file:

_is_valid_devprofile() {
    [ -r "$HOME/$1/.bash_profile" -o -r "$HOME/$1/.profile" ]
}

echo_current_devprofile() {
    local devprofile=$(
        if [ "$DEVPROFILE" = - ]; then
            true
        elif [ -n "$DEVPROFILE" ]; then
            echo "$DEVPROFILE"
        else
            cd -P "$HOME/etc/devprofile" >/dev/null 2>/dev/null || return 1
            echo "${PWD##*/}"
        fi
    ) || return $?
    if [ -z "$devprofile" ]; then
        return 0
    elif _is_valid_devprofile "$devprofile"; then
        echo "$devprofile"
        return 0
    fi
    echo "Current devprofile invalid: $devprofile" >&2
    return 2
}

set_current_devprofile() {
    local devprofile="${1?}"
    if [ "$devprofile" != - ] && ! _is_valid_devprofile "$devprofile"; then
        return 1
    fi
    case "$devprofile" in
    -)
        rm -rf "$HOME/etc/devprofile"
        ;;
    *)
        ( mkdir -p "$HOME/etc" &&
                cd "$HOME/etc" &&
                rm -f devprofile &&
                ln -s -f "../$devprofile" devprofile ) || return $?
        ;;
    esac
    _init_current_devprofile
    return 0
}

_init_devprofile_directory() {
    local dir="${1?}"
    if [ -r "$dir/.bash_profile" ]; then
        . "$dir/.bash_profile"
        return 0
    elif [ -r "$dir/.profile" ]; then
        . "$dir/.profile"
        return 0
    fi
    return 1
}

# Invoked by .bash_profile
_init_current_devprofile() {
    case $(builtin type -t __undo_profile) in
    function)
        __undo_profile
        #unset -f __undo_profile
        ;;
    esac
    if [ "$DEVPROFILE" = - ]; then
        true
    elif [ -n "$DEVPROFILE" ] && _is_valid_devprofile "$DEVPROFILE"; then
        _init_devprofile_directory "$HOME/$DEVPROFILE"
    else
        _init_devprofile_directory "$HOME/etc/devprofile"
    fi
}

# For argument completion.
_complete_devprofiles() {
    local __had_nullglob=false
    shopt -q nullglob && __had_nullglob=true
    shopt -s nullglob
    local __prof
    for __prof in "$HOME/$2"*/.bash_profile "$HOME/$2"*/.profile ; do
        __prof=${__prof%/.*profile}
        __prof=${__prof##*/}
        COMPREPLY+=("$__prof")
    done
    $__had_nullglob || shopt -u nullglob
}
