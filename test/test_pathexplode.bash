origIFS="$IFS"
set -e
case $0 in */*)D="${0%/*}";;*)D=.;;esac
export SHELLBOOST="$D/.."
. "$SHELLBOOST/libsh/include.sh"
__shellboost_include libsh/pathexplode.bash || return $?
__shellboost_include libsh/assert.sh || return $?
set +e

set -x

assert [ "$IFS" = "$origIFS" ]

assert path_explode_array /a/b/ A
assert [ ${#A[*]} -eq 5 ]
assert [ "${A[0]}" = / ]
assert [ "${A[1]}" = a ]
assert [ "${A[2]}" = / ]
assert [ "${A[3]}" = b ]
assert [ "${A[4]}" = / ]
assert path_explode_array "/a b/c$/d*e;" B
assert [ ${#B[*]} -eq 6 ]
assert [ "${B[0]}" = / ]
assert [ "${B[1]}" = 'a b' ]
assert [ "${B[2]}" = / ]
assert [ "${B[3]}" = 'c$' ]
assert [ "${B[4]}" = / ]
assert [ "${B[5]}" = 'd*e;' ]

assert [ "$IFS" = "$origIFS" ]

assert path_explode_index /a/b/ 0
assert [ $(path_explode_index /a/b/ 0) = / ]
assert path_explode_index /a/b/ 1
assert [ $(path_explode_index /a/b/ 1) = a ]
assert path_explode_index /a/b/ 2
assert [ $(path_explode_index /a/b/ 2) = / ]
assert path_explode_index /a/b/ 3
assert [ $(path_explode_index /a/b/ 3) = b ]
assert path_explode_index /a/b/ 4
assert [ $(path_explode_index /a/b/ 4) = / ]
assert ! path_explode_index /a/b/ 5
assert ! path_explode_index /a/b/ 6

assert [ "$IFS" = "$origIFS" ]

assert [ "$(path_common_prefix /a/b/e /a/b/c/d)" = /a/b/ ]
assert [ "$(path_common_prefix /a/b/c /d/e/f)" = / ]
assert [ "$(path_common_prefix /a/b/c/ /a/b/c/)" = /a/b/c/ ]
assert [ "$(path_common_prefix /d/e/f /d/e/f)" = /d/e/f ]
assert [ "$(path_common_prefix /g/h/i/ /g/h/i)" = /g/h/i ]

assert [ "$IFS" = "$origIFS" ]

