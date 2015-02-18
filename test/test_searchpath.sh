case $0 in */*)D="${0%/*}";;*)D=.;;esac
. $D/../libsh/searchpath.sh
. $D/../libsh/assert.sh

X=a:b:c
assert searchpath_contains X a
assert searchpath_contains X b
assert searchpath_contains X c
assert searchpath_contains X x y a z
assert ! searchpath_contains X d

unset X
searchpath_append X a
assert [ $X = a ]

X=a:b:c
searchpath_append X d
assert [ $X = a:b:c:d ]

X=a:b:c:d
searchpath_append X d
assert [ $X = a:b:c:d ]

X=a:b:c:d
searchpath_append X b
assert [ $X = a:b:c:d ]

X=a:b:c:d
searchpath_append_force X b
assert [ $X = a:c:d:b ]

X=a:b:c
searchpath_append X b e f c d
assert [ $X = a:b:c:e:f:d ]

X=a:b:c
searchpath_append_force X b e f c d
assert [ $X = a:b:e:f:c:d ]

X=a:b:c
searchpath_prepend X d
assert [ $X = d:a:b:c ]

X=a:b:c:d
searchpath_prepend X a
assert [ $X = a:b:c:d ]

X=a:b:c:d
searchpath_prepend X b
assert [ $X = a:b:c:d ]

X=a:b:c:d
searchpath_prepend_force X b
assert [ $X = b:a:c:d ]

X=a:b:c
searchpath_prepend X b e f c d
assert [ $X = e:f:d:a:b:c ]

X=a:b:c
searchpath_prepend_force X b e f c d
assert [ $X = b:e:f:c:d:a ]

X=a:b:c:d
searchpath_remove X a c
assert [ $X = b:d ]
