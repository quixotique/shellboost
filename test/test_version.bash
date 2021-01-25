case $0 in */*)D="${0%/*}";;*)D=.;;esac
. $D/../libsh/version.bash
. $D/../libsh/assert.sh

set -x

export LANG=C # locale to use ASCII lexical order

# Degenerate cases
assert   compare_versions ret 0 0 ; assert [ $ret -eq 0 ]
assert   compare_versions ret '' '' ; assert [ $ret -eq 0 ]
assert ! compare_versions ret '' 'A' ; assert [ $ret -eq -1 ]
assert ! compare_versions ret 'B' '' ; assert [ $ret -eq 1 ]

# Lexical
assert ! compare_versions ret 'A' 'B' ; assert [ $ret -eq -1 ]
assert ! compare_versions ret 'a' 'B' ; assert [ $ret -eq 1 ]
assert ! compare_versions ret 'ABC' 'ABD' ; assert [ $ret -eq -1 ]
assert   compare_versions ret 'A.B' 'A.B' ; assert [ $ret -eq 0 ]
assert ! compare_versions ret 'A.B' 'B.B' ; assert [ $ret -eq -1 ]
assert ! compare_versions ret 'A.C' 'B.B' ; assert [ $ret -eq -1 ]
assert ! compare_versions ret 'B.C' 'B.B' ; assert [ $ret -eq 1 ]

# Numeric
assert   compare_versions ret 0 0 ; assert [ $ret -eq 0 ]
assert ! compare_versions ret 1 2 ; assert [ $ret -eq -1 ]
assert ! compare_versions ret 1.0 1.1 ; assert [ $ret -eq -1 ]
assert ! compare_versions ret 1.0 1-1 ; assert [ $ret -eq 1 ] # in ASCII . comes after - 
assert   compare_versions ret 3.11.505 3.11.505 ; assert [ $ret -eq 0 ]
assert ! compare_versions ret 3.11.505 3.11.506 ; assert [ $ret -eq -1 ]
assert ! compare_versions ret 3.11.505 3.11.504 ; assert [ $ret -eq 1 ]
assert ! compare_versions ret 3.11.505 3.12.505 ; assert [ $ret -eq -1 ]
assert   compare_versions ret 3.01.505 3.1.505 ; assert [ $ret -eq 0 ]
assert ! compare_versions ret 3.00.505 3.1.505 ; assert [ $ret -eq -1 ]

# Mixture
assert ! compare_versions ret -1 1  ; assert [ $ret -eq -1 ]
assert ! compare_versions ret a1 1  ; assert [ $ret -eq -1 ]
assert ! compare_versions ret 1  -1 ; assert [ $ret -eq 1 ]
assert ! compare_versions ret 1  a1 ; assert [ $ret -eq 1 ]
assert   compare_versions ret foo-1.2.3   foo-01.02.03   ; assert [ $ret -eq 0 ]
assert ! compare_versions ret foo-1.2.4   foo-01.02.03   ; assert [ $ret -eq 1 ]
assert ! compare_versions ret foo-1.2.3-x foo-01.02.03   ; assert [ $ret -eq 1 ]
assert ! compare_versions ret foo-1.2.3-x foo-01.02.03-y ; assert [ $ret -eq -1 ]
assert ! compare_versions ret foo-1.2.3   foo-01.02.03-y ; assert [ $ret -eq -1 ]

# Helpers
assert [ "$(highest_version 1.40 4.1 4.0 1.35)" = 4.1 ]
assert [ "$(lowest_version  1.40 4.1 4.0 1.35)" = 1.35 ]
