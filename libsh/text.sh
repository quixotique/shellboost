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

# Turn all arguments into shell quoted strings which can safely be used as eval
# arguments.
quoted() {
   local space pre escaped
   space=
   for arg; do
      if [ "${arg#*[!A-Za-z0-9_/.,:+%^-]}" = "$arg" ]; then
         printf '%s' "$space$arg"
      else
         escaped=
         # treat leading single-quote specially (for neatness, not correctness)
         pre="${arg#\'}"
         [ "$pre" != "$arg" ] && escaped="\\'"
         arg="$pre"
         while [ -n "$arg" ]; do
            pre="${arg%%\'*}"
            [ "$pre" = "$arg" -o "$pre'" = "$arg" ] && break
            if [ "${pre#*[!A-Za-z0-9_/.,:+%^-]}" = "$pre" ]; then
               escaped="$escaped$pre\\'"
            else
               escaped="$escaped'$pre'\\'"
            fi
            arg="${arg#*\'}"
         done
         # treat trailing single-quote specially (for neatness, not correctness)
         pre="${arg%\'}"
         if [ "${pre#*[!A-Za-z0-9_/.,:+%^-]}" = "$pre" ]; then
            escaped="$escaped$pre"
         else
            escaped="$escaped'$pre'"
         fi
         [ "$pre" != "$arg" ] && escaped="$escaped\\'"
         printf '%s' "$space$escaped"
      fi
      space=' '
   done
   echo
}

