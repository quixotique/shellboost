case $0 in */*)D="${0%/*}";;*)D=.;;esac
. $D/../libsh/time.bash
. $D/../libsh/assert.sh

set -x

assert   is_duration 0s
assert   is_duration 0m
assert   is_duration 0h
assert   is_duration 0d
assert   is_duration 0w
assert   is_duration 000000s
assert   is_duration 15s
assert   is_duration 15000s
assert   is_duration 1w2d3h4m5s
assert ! is_duration 0
assert ! is_duration 59
assert ! is_duration 0S
assert ! is_duration 1sec
assert ! is_duration ''

assert [ $(duration_to_minutes 0s) -eq 0 ]
assert [ $(duration_to_minutes 000s) -eq 0 ]
assert [ $(duration_to_minutes 1s) -eq 1 ]
assert [ $(duration_to_minutes 30s) -eq 1 ]
assert [ $(duration_to_minutes 1m30s) -eq 2 ]
assert [ $(duration_to_minutes 10m0s) -eq 10 ]
assert [ $(duration_to_minutes 1h30m) -eq 90 ]
assert [ $(duration_to_minutes 1d1h1m1s) -eq 3662 ]
assert [ $(duration_to_minutes 1w1s) -eq 25201 ]
