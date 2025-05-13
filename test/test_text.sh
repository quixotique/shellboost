case $0 in */*)D="${0%/*}";;*)D=.;;esac
. $D/../libsh/text.${0##*.}
. $D/../libsh/assert.sh

set -x

assert [ "$(escape : 1-9 abc)" = abc ]
assert [ "$(escape : 1-9 a1b2c)" = 'a:1b:2c' ]
assert [ "$(escape \\ \''\\"!@#$%^&*() ' '"quo\tes" '\''and'\'' m#eta^*char@!s')" = '\"quo\\tes\"\ \'\''and\'\''\ m\#eta\^\*char\@\!s' ]

assert [ "$(quoted a)" = a ]
assert [ "$(quoted a b c)" = "a b c" ]
assert [ "$(quoted '/a/b-c/d_e.f')" = '/a/b-c/d_e.f' ]
assert [ "$(quoted '%a^b_c,d.e:f')" = '%a\^b_c\,d.e:f' ]
assert [ "$(quoted '$a')" = '\$a' ]
assert [ "$(quoted '*')" = '\*' ]
assert [ "$(quoted '~')" = '\~' ]
assert [ "$(quoted '!a')" = '\!a' ]
assert [ "$(quoted '\')" = '\\' ]
assert [ "$(quoted "o'brien")" = "o\\'brien" ]
assert [ "$(quoted "'a'")" = "\\'a\\'" ]
assert [ "$(quoted "'\$a\$b\$c'")" = "\\'"'\$a\$b\$c'"\\'" ]
assert [ "$(quoted "$(quoted '~')")" = '\\~' ]

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
