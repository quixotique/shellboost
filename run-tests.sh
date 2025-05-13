#!/bin/sh

set -e

case $0 in */*)D="${0%/*}";;*)D=.;;esac

run_test() {
    local log
    log="/tmp/${2##*/}.log"
    if "$@" >"$log" 2>&1; then
        echo "Pass: $1 $2"
    else
        echo "Fail: $1 $2 -- see $log"
    fi
}

status=0
for script in "$D/test/"*.sh "$D/test/"*.bash; do
    case $script in
    *.bash)
        run_test /bin/bash "$script" || status=1
        ;;
    *.sh)
        run_test /bin/bash "$script" || status=1
        run_test /bin/sh "$script" || status=1
        ;;
    esac
done

exit $status
