case $0 in */*)D="${0%/*}";;*)D=.;;esac
. $D/../libsh/path.sh
. $D/../libsh/assert.sh

assert [ $(path_trimsep /a/b) = /a/b ]
assert [ $(path_trimsep /a/b/c/) = /a/b/c ]
assert [ $(path_trimsep ../../) = ../.. ]
assert [ $(path_trimsep /) = / ]
assert [ $(path_trimsep ///) = / ]

assert [ $(path_addsep /a/b) = /a/b/ ]
assert [ $(path_addsep /a/b/c/) = /a/b/c/ ]
assert [ $(path_addsep ../..) = ../../ ]
assert [ $(path_addsep /) = / ]
assert [ $(path_addsep ///) = / ]

assert [ $(relpath /a/b/c/d /) = a/b/c/d ]
assert [ $(relpath /a/b/c/d /a/b) = c/d ]
assert [ $(relpath /a/b/c/d /a/b/) = c/d ]
assert [ $(relpath /a/b/c/d /a/e) = ../b/c/d ]
assert [ $(relpath /a/b/c/d /e/f) = ../../a/b/c/d ]
