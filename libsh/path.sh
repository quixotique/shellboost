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
   */*) printf '%s\n' "${1%/*}";;
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
    */) path_trimsep "${1%/}";; *) printf '%s\n' "$1";;
    esac
}

path_addsep() {
    case "$1" in
    /) echo /;;
    */) path_addsep "${1%/}";;
    *) printf '%s\n' "$1/";;
    esac
}

path_simplify() {
   local p
   case "$1" in
   //*) path_simplify "${1#/}";;
   /.) echo /;;
   /..) echo /;;
   *?/) printf '%s\n' "$(path_addsep "$(path_simplify "$(path_trimsep "${1%/}")")")";;
   *?/.) path_simplify "${1%/.}";;
   *?/..)
      p="$(path_simplify "${1%/..}")"
      case "$p" in
      .) echo "..";;
      ..) echo "../..";;
      *?/..) printf '%s\n' "$p/..";;
      *?/*) printf '%s\n' "${p%/*}";;
      /) echo /;;
      /..) echo /;;
      /*) echo /;;
      *) echo .;;
      esac
      ;;
   *?/*?)
      p="$(path_simplify "${1%/*}")"
      case "$p" in
      .) printf '%s\n' "${1##*/}";;
      *) printf '%s\n' "$(path_addsep "$p")${1##*/}";;
      esac
      ;;
   .) echo .;;
   ..) echo ..;;
   *) printf '%s\n' "$1";;
   esac
}

try_realpath_physical() {
   if [ -x /usr/bin/realpath ] && /usr/bin/realpath --physical "$1" 2>/dev/null; then
      :
   else (
      if cd -P "$1" 2>/dev/null; then
         echo "$PWD"
      elif [ "${1%/*}" != "$1" -a ! -d "$1" -a ! -L "$1" ] && cd -P "${1%/*}" 2>/dev/null; then
         printf '%s\n' "$(path_addsep "$PWD")${1##*/}"
      else
         return 1
      fi
   ) fi
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
   printf '%s\n' "${up}${up:+${down:+/}}$down"
}
