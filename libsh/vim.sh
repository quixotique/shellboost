# Shell functions for Vim command-line completion
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

__shellboost_include libsh/feature.sh || return $?
__have_completion || return 0
__shellboost_include libsh/cd.sh || return $?
__shellboost_include libsh/text.sh || return $?

# Redefine this function to support different development file layouts
_tags_file() {
    _nearest_tags_file
}

_nearest_tags_file() {
    ( cd_up_until [ -f tags ] && echo "$PWD/tags" )
}

_vim_search_tags() {
    local tagsfile pattern limit regex
    pattern="${1?}"
    tagsfile="${2?}"
    limit="${3:-100}"
    regex="$(escape \\ '.?*+{[()|\' "$pattern")"
    sed -n -e "/^$regex/s/\t.*//p" "$tagsfile"
}

_complete_vim_bash() {
    local cur prev
    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}
    case "$prev" in
    -t)
        if tags_file="$(_tags_file)" && [ -f "$tags_file" -a -n "$cur" ]; then
            COMPREPLY=( $(_vim_search_tags "$cur" "$tags_file" ) )
        fi
        ;;
    esac
}

_complete_vim_excludelist='*.@(o|O|so|SO|so.!(conf)|SO.!(CONF)|a|A|rpm|RPM|deb|DEB|gif|GIF|jp?(e)g|JP?(E)G|mp3|MP3|mp?(e)g|MP?(E)G|avi|AVI|asf|ASF|ogg|OGG|class|CLASS)'

complete -F _complete_vim_bash -f -X "$_complete_vim_excludelist" vi vim gvim rvim view rview rgvim rgview gview
