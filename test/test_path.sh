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

assert path_component /a/b/c/d 0
assert [ $(path_component /a/b/c/d 0) = a ]
assert path_component /a/b/c/d 1
assert [ $(path_component /a/b/c/d 1) = b ]
assert path_component /a/b/c/d 2
assert [ $(path_component /a/b/c/d 2) = c ]
assert path_component /a/b/c/d 3
assert [ $(path_component /a/b/c/d 3) = d ]
assert ! path_component /a/b/c/d 4
assert ! path_component /a/b/c/d 5

assert [ "$IFS" = "$origIFS" ]

assert path_component_separator /a/b/ 0
assert [ $(path_component_separator /a/b/ 0) = / ]
assert path_component_separator /a/b/ 1
assert [ $(path_component_separator /a/b/ 1) = a ]
assert path_component_separator /a/b/ 2
assert [ $(path_component_separator /a/b/ 2) = / ]
assert path_component_separator /a/b/ 3
assert [ $(path_component_separator /a/b/ 3) = b ]
assert path_component_separator /a/b/ 4
assert [ $(path_component_separator /a/b/ 4) = / ]
assert ! path_component_separator /a/b/ 5
assert ! path_component_separator /a/b/ 6

assert [ "$IFS" = "$origIFS" ]

assert [ $(path_common_prefix /a/b/e /a/b/c/d) = /a/b/ ]
assert [ $(path_common_prefix /a/b/c /d/e/f) = / ]
assert [ $(path_common_prefix /a/b/c/ /a/b/c/) = /a/b/c/ ]
assert [ $(path_common_prefix /d/e/f /d/e/f) = /d/e/f ]
assert [ $(path_common_prefix /g/h/i/ /g/h/i) = /g/h/i ]

assert [ "$IFS" = "$origIFS" ]

