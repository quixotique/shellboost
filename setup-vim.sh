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

run() {
   echo "$@"
   "$@"
}

cd "${HOME?}"
if $opt_force || [ ! -r .vim/autoload/pathogen.vim ]; then
   run mkdir -p .vim/autoload .vim/bundle &&
      run curl -LSo .vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
fi
