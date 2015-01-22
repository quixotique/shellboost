case $0 in */*)D="${0%/*}";;*)D=.;;esac
. $D/../path.sh
. $D/../assert.sh

X=a:b:c
assert path_contains X a
assert path_contains X b
assert path_contains X c
assert path_contains X x y a z
assert ! path_contains X d

X=a:b:c
path_append X d
assert [ $X = a:b:c:d ]

X=a:b:c:d
path_append X d
assert [ $X = a:b:c:d ]

X=a:b:c:d
path_append X b
assert [ $X = a:b:c:d ]

X=a:b:c:d
path_append_force X b
assert [ $X = a:c:d:b ]

X=a:b:c
path_append X b e f c d
assert [ $X = a:b:c:e:f:d ]

X=a:b:c
path_append_force X b e f c d
assert [ $X = a:b:e:f:c:d ]

X=a:b:c
path_prepend X d
assert [ $X = d:a:b:c ]

X=a:b:c:d
path_prepend X a
assert [ $X = a:b:c:d ]

X=a:b:c:d
path_prepend X b
assert [ $X = a:b:c:d ]

X=a:b:c:d
path_prepend_force X b
assert [ $X = b:a:c:d ]

X=a:b:c
path_prepend X b e f c d
assert [ $X = e:f:d:a:b:c ]

X=a:b:c
path_prepend_force X b e f c d
assert [ $X = b:e:f:c:d:a ]

X=a:b:c:d
path_remove X a c
assert [ $X = b:d ]
