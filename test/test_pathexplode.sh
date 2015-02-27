origIFS="$IFS"
set -e
case $0 in */*)D="${0%/*}";;*)D=.;;esac
export SHELLBOOST="$D/.."
. "$SHELLBOOST/libsh/include.sh"
__shellboost_include libsh/pathexplode.sh || return $?
__shellboost_include libsh/assert.sh || return $?
set +e

set -x

assert [ "$IFS" = "$origIFS" ]

assert [ "$(path_explode_eval /a/b/)" = "/ a / b /" ]
assert [ "$(path_explode_eval "/a b/c$/d*e;")" = "/ 'a b' / 'c$' / 'd*e;'" ]
eval set -- $(path_explode_eval "/a b/c$/d*e;")
assert [ $# -eq 6 ]
assert [ "$1" = / ]
assert [ "$2" = 'a b' ]
assert [ "$3" = / ]
assert [ "$4" = 'c$' ]
assert [ "$5" = / ]
assert [ "$6" = 'd*e;' ]

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

assert [ $(path_common_prefix /a/b/e /a/b/c/d) = /a/b/ ]
assert [ $(path_common_prefix /a/b/c /d/e/f) = / ]
assert [ $(path_common_prefix /a/b/c/ /a/b/c/) = /a/b/c/ ]
assert [ $(path_common_prefix /d/e/f /d/e/f) = /d/e/f ]
assert [ $(path_common_prefix /g/h/i/ /g/h/i) = /g/h/i ]

assert [ "$IFS" = "$origIFS" ]
