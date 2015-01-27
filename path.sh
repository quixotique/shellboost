# Shell functions for manipulating file paths
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

dirpath() {
   case "$1" in
   */*) echo "${1%/*}";;
   *) echo .;;
   esac
}

abspath() {
   case "$1" in
   /*) echo "$1";;
   *) echo "$PWD/$1";;
   esac
}

path_trimsep() {
    case "$1" in
    /) echo /;;
    */) path_trimsep "${1%/}";;
    *) echo "$1";;
    esac
}

path_addsep() {
    case "$1" in
    /) echo /;;
    */) path_addsep "${1%/}";;
    *) echo "$1/";;
    esac
}

relpath() {
   local path="$(abspath "$1")"
   local base="$(path_addsep "$(abspath "${2:-.}")")"
   local down=
   local up=
   while [ -n "$base" ]; do
      down="${path#"$base"}"
      [ "$down" != "$path" ] && break
      base="$(path_addsep "${base%/*/}")"
      up="../$up"
   done
   echo "${up}$down"
}
