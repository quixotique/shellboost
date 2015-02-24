case $0 in */*)D="${0%/*}";;*)D=.;;esac
. $D/../libsh/cd.sh
. $D/../libsh/assert.sh

[ -d "$TMPDIR" -a -w "$TMPDIR" ] || TMPDIR=/tmp

fixture() {
   set -e
   rm -rf "$TMPDIR/shellboost/test"
   mkdir -p "$TMPDIR/shellboost/test"
   cd "$TMPDIR/shellboost/test"
   mkdir -p a/b/c/d/e/f/g/h
   cd a
   echo >foo
   cd b
   echo >bar
   cd c
   echo >foo
   echo >fizz
   cd d/e
   echo >buzz
   cd f/g/h
   set +e
}

fixture >/dev/null

assert [ "$( cd_up_until [ -f foo ] && echo "$PWD" )" = "$TMPDIR/shellboost/test/a/b/c" ]
assert [ "$( cd_up_until [ -f buzz ] && echo "$PWD" )" = "$TMPDIR/shellboost/test/a/b/c/d/e" ]
assert [ "$( cd_up_until [ "$(echo *)" = '*' ] && echo "$PWD" )" = "$TMPDIR/shellboost/test/a/b/c/d/e/f/g/h" ]
assert [ "$( cd_up_until true && echo "$PWD" )" = "$PWD" ]
assert [ "$( cd_up_until false && echo Yes; echo "$PWD" )" = "$PWD" ]

assert [ "$( cd_down_until [ -f foo ] && echo "$PWD" )" = "$TMPDIR/shellboost/test/a" ]
assert [ "$( cd_down_until [ -f buzz ] && echo "$PWD" )" = "$TMPDIR/shellboost/test/a/b/c/d/e" ]
assert [ "$( cd_down_until eval [ "\"\${PWD##*/}\"" = 'b' ] && echo "$PWD" )" = "$TMPDIR/shellboost/test/a/b" ]
assert [ "$( cd_down_until true && echo "$PWD" )" = / ]
assert [ "$( cd_down_until false && echo Yes; echo "$PWD" )" = "$PWD" ]
