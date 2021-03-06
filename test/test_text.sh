case $0 in */*)D="${0%/*}";;*)D=.;;esac
. $D/../libsh/text.sh
. $D/../libsh/assert.sh

set -x

assert [ "$(quoted a)" = a ]
assert [ "$(quoted a b c)" = "a b c" ]
assert [ "$(quoted /a/b-c/d_e.f)" = /a/b-c/d_e.f ]
assert [ "$(quoted %a^b_c,d.e:f)" = %a^b_c,d.e:f ]
assert [ "$(quoted '$a')" = "'\$a'" ]
assert [ "$(quoted '*')" = "'*'" ]
assert [ "$(quoted '~')" = "'~'" ]
assert [ "$(quoted '!a')" = "'!a'" ]
assert [ "$(quoted '\')" = "'\'" ]
assert [ "$(quoted "o'brien")" = "o\\'brien" ]
assert [ "$(quoted "'a'")" = "\\'a\\'" ]
assert [ "$(quoted "'\$a\$b\$c'")" = "\\''\$a\$b\$c'\\'" ]
assert [ "$(quoted "$(quoted '~')")" = "\''~'\'" ]

assert [ "$(lstrip a)" = a ]
assert [ "$(lstrip 'a  ')" = 'a  ' ]
assert [ "$(lstrip '  a')" = a ]
assert [ "$(lstrip '  a  ')" = 'a  ' ]
assert [ "$(lstrip 'a b')" = 'a b' ]
assert [ "$(lstrip ' 	a')" = a ]
assert [ "$(lstrip '	 
a')" = a ]

assert [ "$(rstrip a)" = a ]
assert [ "$(rstrip 'a  ')" = a ]
assert [ "$(rstrip '  a')" = '  a' ]
assert [ "$(rstrip '  a  ')" = '  a' ]
assert [ "$(rstrip 'a b')" = 'a b' ]
assert [ "$(rstrip 'a	 ')" = a ]
assert [ "$(rstrip 'a	 
')" = a ]

assert [ "$(strip a)" = a ]
assert [ "$(strip 'a  ')" = a ]
assert [ "$(strip '  a')" = a ]
assert [ "$(strip '  a  ')" = a ]
assert [ "$(strip 'a b')" = 'a b' ]
assert [ "$(strip 'a	 ')" = a ]
assert [ "$(strip 'a	 
')" = a ]
