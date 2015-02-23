# Shell functions for testing the presence of features
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

# Test if we have Bash arrays
__have_arrays() {
   ( eval '__array_test=(a b c) && [ ${__array_test[1]} = b ]' 2>/dev/null )
}

# Test if we have Bash full substitution variable expansion
__have_var_full_subst() {
   ( a=12345 eval '[ "${a//[135]/x}" = x2x4x ]' 2>/dev/null )
}

# Test if we have Bash command-line completion
__have_completion() {
    case $(type complete) in
    'complete is a shell builtin') return 0;;
    esac
    return 1
}
