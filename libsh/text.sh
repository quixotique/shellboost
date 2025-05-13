# Shell functions for manipulating text
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

# Echo args3..N with an escape character arg1 inserted before all characters in
# the set arg2, ie, that would match the glob construction [arg2].
escape() {
   local esc chars escaped rest char
   esc="${1?}"
   chars="${2?}"
   shift 2
   escaped=
   for arg; do
      escaped="$escaped "
      while [ -n "$arg" ]; do
         rest="${arg#?}"
         char="${arg%"$rest"}"
         case $char in
         [$chars]) escaped="$escaped$esc$char";;
         *)        escaped="$escaped$char";;
         esac
         arg="$rest"
      done
   done
   printf '%s\n' "${escaped# }"
}

# Turn all arguments into shell quoted strings which can safely be used as eval
# arguments.
quoted() {
   local quoted esctilde rest char
   quoted=
   for arg; do
      quoted="$quoted "
      esctilde='\'
      while [ -n "$arg" ]; do
         rest="${arg#?}"
         char="${arg%"$rest"}"
         case $char in
         [A-Za-z0-9_/.:+%-]) quoted="$quoted$char";;
         \~)                 quoted="$quoted$esctilde$char";;
         *)                  quoted="$quoted\\$char";;
         esac
         arg="$rest"
         esctilde=
      done
   done
   printf '%s\n' "${quoted# }"
}

# Strip characters from start of argument.  If no chars given, default is whitespace.
# lstrip arg [chars]
lstrip() {
   local text chars ntext
   text="$1"
   chars="${2:- 	
}"
   while true; do
      ntext="${text#["$chars"]}"
      [ "$ntext" = "$text" ] && break
      text="$ntext"
   done
   printf '%s\n' "$ntext"
}

# Strip characters from end of argument.  If no chars given, default is whitespace.
# rstrip arg [chars]
rstrip() {
   local text chars ntext
   text="$1"
   chars="${2:- 	
}"
   while true; do
      ntext="${text%["$chars"]}"
      [ "$ntext" = "$text" ] && break
      text="$ntext"
   done
   printf '%s\n' "$ntext"
}

# Strip characters from start and end of argument.  If no chars given, default
# is whitespace.
# strip arg [chars]
strip() {
   rstrip "$(lstrip "$1" "$2")" "$2"
}
