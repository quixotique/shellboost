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

echo_devprofile_that_contains_path() {
    local toplevel_real home_real
    toplevel_real="$(/usr/bin/realpath "$toplevel")" || return $?
    home_real="$(/usr/bin/realpath "$HOME")" || return $?
    case "$toplevel_real/" in
    "$home_real"/*/*)
        local devprofile="${toplevel_real#"$home_real"/}"
        devprofile="${devprofile%%/*}"
        if _is_valid_devprofile "$devprofile"; then
            echo "$devprofile"
            return 0
        fi
        ;;
    esac
    return 1
}

set_current_devprofile() {
    local devprofile="${1?}"
    _is_valid_devprofile_arg "$devprofile" || return 1
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
    init_devprofile
}

# Invoked by .bash_profile and bin/git
init_devprofile() {
    case $(builtin type -t __undo_profile) in
    function)
        __undo_profile
        #unset -f __undo_profile
        ;;
    esac
    if [ "$DEVPROFILE" = - ]; then
        return 0
    elif ${DEVPROFILE+:} false; then
        _init_devprofile_directory "$HOME/$DEVPROFILE"
    elif [ -L "$HOME/etc/devprofile" ]; then
        _init_devprofile_directory "$HOME/etc/devprofile"
    else
        return 0 # no current profile
    fi
}

run_in_devprofile() {
    local devprofile="${1?}"
    shift
    if ! _is_valid_devprofile_arg "$devprofile"; then
        echo "Invalid devprofile: $devprofile" >&2
        return 1
    fi
    ( export DEVPROFILE="$devprofile"; init_devprofile && "$@" )
}

# For argument completion.
complete_devprofiles() {
    local cur prev words cword
    _init_completion || return
    case $cword in
    1)
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
        ;;
    *)
        # Perform normal command completion in the devprofile's environment,
        # mainly to pick up its $PATH.
        if _is_valid_devprofile_arg "${words[1]}"; then
            local __ifs="$IFS"
            IFS='
'
            COMPREPLY=($( (
                export DEVPROFILE="${words[1]}"
                init_devprofile 
                _command_offset 2
                echo "${COMPREPLY[*]}"
                )))
            IFS="$__ifs"
        fi
        ;;
    esac
}

# Private functions, only to be invoked within this source file.

_is_valid_devprofile() {
    [ -r "$HOME/$1/.bash_profile" -o -r "$HOME/$1/.profile" ]
}

_is_valid_devprofile_arg() {
    [ "$1" == - ] || _is_valid_devprofile "$1"
}

_init_devprofile_directory() {
    local dir="${1?}"
    if [ -r "$dir/.bash_profile" ]; then
        . "$dir/.bash_profile"
    elif [ -r "$dir/.profile" ]; then
        . "$dir/.profile"
    else
        return 1
    fi
    return 0
}
