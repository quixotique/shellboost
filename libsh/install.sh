# Shell functions for installing shellboost
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

__shellboost_include libsh/script.sh

usage() {
    echo "$0 [-f|--force] [-n|--dry-run]"
}

opt_verbose=true

parse_command_line() {
    opt_force=false
    while [ $# -gt 0 ]; do
        case "$1" in
        '-?'|-h|--help) usage; exit 0;;
        -f|--force)     opt_force=true; shift;;
        -n|--dry-run)   opt_dry_run=true; shift;;
        -*)             fatal_usage "unsupported option: $1";;
        *)              break;;
        esac
    done
    [ $# -eq 0 ] || fatal_usage "spurious arguments: $*"
}

link() {
    local src="${1?}"
    local dst="${2?}"
    local linked=false
    [ -e "$src" ]
    if $opt_force || [ ! -e "$dst" ]; then
        local dir="${dst%/*}"
        if [ "$dir" != "$dst" ]; then
            src="$HOME/$src"
            if [ ! -d "$dir" ]; then
                run mkdir -p "$dir"
            fi
        fi
        run ln -s -f -r "$src" "$dst"
        linked=true
    fi
    if ! $linked && [ ! "$dst" -ef "$src" ]; then
        log "not linked: $src -> $dst"
    fi
}
