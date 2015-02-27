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
