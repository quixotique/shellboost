# Bash functions for common scripting idioms
# vim:sts=4 sw=4 ts=8 et
# Copyright 2020 Andrew Bettison
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

# Create duplicate file descriptors 101 for stdout and 102 for stderr, so that
# the script's messages still go to the script's output even within a block
# that redirects or quashes stdout/stderr, eg: 'run cd /foo/bar >/dev/null'

exec 101>&1 102>&2

log() {
    echo "$@" >&101
}

opt_dry_run=false

run() {
    { echo -n +; printf ' %q' "$@"; echo; } >&101
    if ! ${opt_dry_run:-false}; then
        "$@"
    fi
}

error() {
    echo "${0##*/}: $1" >&102
}

fatal() {
    error "$1"
    exit 1
}

fatal_usage() {
    error "$1"
    usage >&102
    exit 1
}
