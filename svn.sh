# Shell functions for working with Subversion
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

# Edit a Subversion checked out and modified file in Vim diff mode, with the
# original on the left and the modified local copy on the right.
svnvi()
{
    local working_label
    local other_label
    local working_path
    local other_path
    local script_tmp=${TMPDIR:-/tmp}/svnvi-script$$
    local other_tmp=${TMPDIR:-/tmp}/svnvi-tmp$$
    cat >|$script_tmp <<EOF
#!/bin/bash
q="'\\\\''"
echo "other_label='\${3//\'/\$q}'" >&3
echo "working_label='\${5//\'/\$q}'" >&3
echo "other_path='\${6//\'/\$q}'" >&3
echo "working_path='\${7//\'/\$q}'" >&3
/bin/cp -- "\$6" $other_tmp
EOF
    chmod +x $script_tmp
    eval "`svn diff --diff-cmd $script_tmp \"$@\" 3>&1 >/dev/null`"
    stat=$?
    rm -f $script_tmp
    if [ $stat -ne 0 ]; then
        return $stat
    fi
    if [ ! -f $other_tmp ]; then
        echo "No modifications."
        return 0
    fi
    chmod 0400 $other_tmp
    if [ -r "$other_path" ]; then
        ${DIFFEDITOR:-vimdiff} "$other_path" "$working_path"
    else
        ${DIFFEDITOR:-vimdiff} $other_tmp "$working_path"
    fi
    rm -f $other_tmp
}
