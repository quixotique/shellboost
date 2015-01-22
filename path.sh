# Shell functions for manipulating $PATH and other variables
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

# path_contains NAME [ value1 [ value2 ... ] ]
# Returns true if any of value1 or value2 etc. are in $NAME
path_contains() {
   local __var __path __arg __element __IFS
   __var="$1"
   shift
   eval __path=\"\$$__var\"
   __IFS="$IFS"
   IFS=:
   for __element in $__path; do
      for __arg; do
         if [ "$__arg" = "$__element" ]; then
            IFS="$__IFS"
            return 0
         fi
      done
   done
   IFS="$__IFS"
   return 1
}

# path_append NAME [ value1 [ value2 ... ] ]
# Appends value1, value2 etc. to $NAME if not already somewhere in $NAME
path_append() {
   local __var __arg
   __var="$1"
   shift
   for __arg; do
      path_contains $__var "$__arg" || eval $__var=\"\$$__var\${$__var:+:}\$__arg\"
   done
}

# path_append_force NAME [ value1 [ value2 ... ] ]
# Appends value1, value2 etc. to $NAME after removing value1, value2 etc.
# from anywhere else in $NAME
path_append_force() {
   path_remove "$@"
   path_append "$@"
}

# path_prepend NAME [ value1 [ value2 ... ] ]
# Prepends value1, value2 etc. to $NAME if not already somewhere in $NAME
path_prepend() {
   local __var __i __arg
   __var="$1"
   shift
   __i=$#
   while [ $__i -gt 0 ]; do
      eval __arg=\"\$$__i\"
      path_contains $__var "$__arg" || eval $__var=\"\$__arg\${$__var:+:}\$$__var\"
      __i=$((__i - 1))
   done
}

# path_prepend_force NAME [ value1 [ value2 ... ] ]
# Prepends value1, value2 etc. to $NAME after removing value1, value2 etc.
# from anywhere else in $NAME
path_prepend_force() {
   path_remove "$@"
   path_prepend "$@"
}

# path_remove NAME [ value1 [ value2 ... ] ]
# Removes value1, value2 etc. from $NAME
path_remove() {
   local __var __path __newpath __arg __element __IFS
   __var="$1"
   shift
   eval __path=\"\$$__var\"
   __newpath=
   __IFS="$IFS"
   IFS=:
   for __element in $__path; do
      for __arg; do
         [ "$__arg" = "$__element" ] && continue 2
      done
      __newpath="$__newpath${__newpath:+:}$__element"
   done
   IFS="$__IFS"
   eval $__var=\"\$__newpath\"
}
