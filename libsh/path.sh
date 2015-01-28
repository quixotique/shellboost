# Shell functions for manipulating file paths
# vim:sts=3 sw=3 ts=8 et
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
   .) echo "$PWD";;
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

path_simplify() {
   local p
   case "$1" in
   //*) path_simplify "${1#/}";;
   /.) echo /;;
   /..) echo /;;
   *?/) echo "$(path_addsep "$(path_simplify "$(path_trimsep "${1%/}")")")";;
   *?/.) path_simplify "${1%/.}";;
   *?/..)
      p="$(path_simplify "${1%/..}")"
      case "$p" in
      .) echo "..";;
      ..) echo "../..";;
      *?/..) echo "$p/..";;
      *?/*) echo "${p%/*}";;
      /) echo /;;
      /..) echo /;;
      /*) echo /;;
      *) echo .;;
      esac
      ;;
   *?/*?)
      p="$(path_simplify "${1%/*}")"
      case "$p" in
      .) echo "${1##*/}";;
      *) echo "$(path_addsep "$p")${1##*/}";;
      esac
      ;;
   .) echo .;;
   ..) echo ..;;
   *) echo "$1";;
   esac
}

relpath() {
   local path="$(path_simplify "$(abspath "$1")")"
   local base="$(path_addsep "$(path_simplify "$(abspath "${2-.}")")")"
   local down=
   local up=
   while [ -n "$base" ]; do
      down="${path#"$base"}"
      [ "$down" != "$path" ] && break
      down="${path#"${base%/}"}"
      [ "$down" != "$path" ] && break
      base="${base%/*/}/"
      up="..${up:+/}$up"
   done
   echo "${up}${up:+${down:+/}}$down"
}
