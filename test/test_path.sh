origIFS="$IFS"
case $0 in */*)D="${0%/*}";;*)D=.;;esac
. $D/../libsh/path.sh
. $D/../libsh/assert.sh

set -x

assert [ "$IFS" = "$origIFS" ]

assert [ $(path_trimsep /a/b) = /a/b ]
assert [ $(path_trimsep /a/b/c/) = /a/b/c ]
assert [ $(path_trimsep ../../) = ../.. ]
assert [ $(path_trimsep /) = / ]
assert [ $(path_trimsep ///) = / ]

assert [ "$IFS" = "$origIFS" ]

assert [ $(path_addsep /a/b) = /a/b/ ]
assert [ $(path_addsep /a/b/c/) = /a/b/c/ ]
assert [ $(path_addsep ../..) = ../../ ]
assert [ $(path_addsep /) = / ]
assert [ $(path_addsep ///) = / ]

assert [ "$IFS" = "$origIFS" ]

assert [ $(path_simplify a) = a ]
assert [ $(path_simplify a/b) = a/b ]
assert [ $(path_simplify a//b) = a/b ]
assert [ $(path_simplify a/////b) = a/b ]
assert [ $(path_simplify a/.) = a ]
assert [ $(path_simplify a/..) = . ]
assert [ $(path_simplify a/../..) = .. ]
assert [ $(path_simplify a/./..) = . ]
assert [ $(path_simplify ../a) = ../a ]
assert [ $(path_simplify ./a) = a ]
assert [ $(path_simplify ../a) = ../a ]
assert [ $(path_simplify a/./b/./././c) = a/b/c ]
assert [ $(path_simplify a/b/c/d/../../e/f) = a/b/e/f ]
assert [ $(path_simplify /./.././a) = /a ]
assert [ $(path_simplify /a/b/../../../../c) = /c ]
assert [ $(path_simplify a/b/../d/../e/./../../f/g) = f/g ]
assert [ $(path_simplify a/) = a/ ]
assert [ $(path_simplify ../a/) = ../a/ ]
assert [ $(path_simplify a/b/../c/) = a/c/ ]
assert [ $(path_simplify /) = / ]
assert [ $(path_simplify //) = / ]
assert [ $(path_simplify ////////) = / ]
assert [ $(path_simplify /.) = / ]

assert [ "$IFS" = "$origIFS" ]

assert [ $(relpath /a/b/c/d /) = a/b/c/d ]
assert [ $(relpath /a/b/c/d /a/b) = c/d ]
assert [ $(relpath /a/b/c/d /a/b/) = c/d ]
assert [ $(relpath /a/b/c/d /a/e) = ../b/c/d ]
assert [ $(relpath /a/b/c/d /e/f) = ../../a/b/c/d ]
assert [ $(relpath /a/b /a/b/c/d) = ../.. ]
assert [ $(relpath /a/b/c/e /a/b/c/d) = ../e ]
assert [ $(relpath /a/b/e /a/b/c/d) = ../../e ]

assert [ "$IFS" = "$origIFS" ]

chmod -R a+x /tmp/a 2>/dev/null
chmod -R a+x /tmp/x 2>/dev/null
rm -rf /tmp/a || exit $?
rm -rf /tmp/x || exit $?

mkdir -p /tmp/a/b/c/d/e
>|/tmp/a/b/c/d/e/f
ln -snf /tmp/a/b/c /tmp/a/b/c1
assert [ $(try_realpath_physical /tmp/a/b/c1/d/e) = /tmp/a/b/c/d/e ]
assert [ $(try_realpath_physical /tmp/a/b/c1/d/e/f) = /tmp/a/b/c/d/e/f ]
assert [ $(try_realpath_physical /tmp/a/b/c1/d/e/non) = /tmp/a/b/c/d/e/non ]
mkdir -p /tmp/x/y
ln -snf /tmp/a/b/c/d/e /tmp/x/y/z
assert [ $(try_realpath_physical /tmp/x/y/z) = /tmp/a/b/c/d/e ]
assert [ $(try_realpath_physical /tmp/x/y/z/f) = /tmp/a/b/c/d/e/f ]
assert [ $(try_realpath_physical /tmp/x/y/z/non) = /tmp/a/b/c/d/e/non ]
chmod a-x /tmp/x/y
assert ! try_realpath_physical /tmp/x/y/z
assert ! try_realpath_physical /tmp/x/y/z/f
chmod a-x /tmp/x
assert ! try_realpath_physical /tmp/x/y/z
assert ! try_realpath_physical /tmp/x/y/z/f

chmod -R a+x /tmp/a
chmod -R a+x /tmp/x
rm -rf /tmp/a || exit $?
rm -rf /tmp/x || exit $?
