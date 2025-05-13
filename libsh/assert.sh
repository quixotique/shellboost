# Shell functions for unit tests
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

__run() {
   if [ "$1" = '!' ]; then
      shift
      if __run "$@"; then
         return 1
      else
         return 0
      fi
   fi
   "$@"
}

assert() {
   if ! __run "$@"; then
      printf '%s\n' "assertion failed: $*" >&2
      exit 3
   fi
}
