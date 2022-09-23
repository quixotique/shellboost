# Shell functions for including script files
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

__include() {
    local path var
    path="${1?missing arg}"
    var="${2:-__included__$1}"
    while [ "$var" != "${var#*[!A-Za-z0-9_]}" ]; do
        var="${var%%[!A-Za-z0-9_]*}__${var#*[!A-Za-z0-9_]}"
    done
    eval test \"\$$var\" = true && return 0
    . "$path" && eval "$var=true"
}

__shellboost_include() {
    __include "${SHELLBOOST?}/${1?missing arg}" "__shellboost_included__$1"
}

__shellboost_included__libsh__include__sh=true
