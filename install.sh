#!/bin/bash

usage() {
    echo "$0 [-f|--force]"
}

set -e

opt_force=false
while [ $# -gt 0 ]; do
    case "$1" in
    '-?'|-h|--help)
        usage
        exit 0
        ;;
    -f|--force)
        opt_force=true
        shift
        ;;
    -*)
        echo "$0: unsupported option: $1" >&2
        exit 1
        ;;
    *)
        break
        ;;
    esac
done
if [ $# -ne 0 ]; then
    echo "$0: spurious arguments: $*" >&2
    exit 1
fi

install() {
    local src="${1?}"
    local dst="${2?}"
    [ -e "$src" ]
    if $opt_force || [ ! -e "$dst" ]; then
        echo "link $dst  ->  $src"
        ln -s -f "$src" "$dst"
    fi
}

cd "${HOME?}"
install etc/shellboost/env/bash_profile .bash_profile
install etc/shellboost/env/bashrc       .bashrc
install etc/shellboost/env/gitconfig    .gitconfig
install etc/shellboost/env/gitexclude   .gitexclude
install etc/shellboost/env/hgrc         .hgrc
install etc/shellboost/env/profile      .profile
install etc/shellboost/env/setpath      .setpath
install etc/shellboost/env/vimrc        .vimrc
