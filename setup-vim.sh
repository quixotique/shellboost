#!/bin/bash
# vim:sts=4 sw=4 et
# Install third party software packages needed by Vim
# Copyright 2020 Andrew Bettison

source "$HOME/.bash_profile"
__shellboost_include libsh/script.sh || exit $?

usage() {
    echo "$0 [-f|--force] [-n|--dry-run]"
}

set -e

opt_dry_run=false
opt_force=false

while [[ $# -gt 0 ]]; do
    case "$1" in
    '-?'|-h|--help)
        usage
        exit 0
        ;;
    -f|--force)
        opt_force=true
        shift
        ;;
    -n|--dry-run)
        opt_dry_run=true
        shift
        ;;
    -*)
        fatal_usage "unsupported option: $1"
        ;;
    *)
        break
        ;;
    esac
done
[[ $# -eq 0 ]] || fatal_usage "spurious arguments: $*"

fetch() {
    local dst="${1?}"
    local url="${2?}"
    [[ $dst = */ ]] && dst="$dst${url##*/}"
    if $opt_force || [ ! -e $dst ]; then
        run curl --fail --location --silent --show-error --create-dirs -o "$dst" "$url"
    fi
}

git_clone() {
    local dst="${1?}"
    local url="${2?}"
    local stem="${url##*/}"
    local stem="${stem%.git}"
    [[ $dst = */ ]] && dst="$dst$stem"
    if $opt_force || [ ! -d $dst/.git ]; then
        [[ -d "$dst" ]] || run mkdir -p "$dst"
        run git clone "$url" "$dst"
    fi
}

fetch     ~/.vim/autoload/ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
git_clone ~/.vim/package/  git@github.com:quixotique/vim-delta.git
