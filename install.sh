#!/bin/bash

set -e

# Bootstrap shellboost.
if [[ ! -f $SHELLBOOST/libsh/include.sh && -r ${0%/*}/libsh/include.sh ]]; then
   export SHELLBOOST="${0%/*}"
fi

. "$SHELLBOOST/libsh/include.sh" || exit $?
__shellboost_include libsh/script.sh || exit $?
__shellboost_include libsh/install.sh || exit $?

if [ "$SHELLBOOST" != "$here" ]; then
    runf export SHELLBOOST="$here"
fi

parse_command_line "$@"

runf cd "${HOME?}"
link "$SHELLBOOST/env/bash_profile"         .bash_profile
link "$SHELLBOOST/env/bashrc"               .bashrc
link "$SHELLBOOST/env/gitconfig"            .gitconfig
link "$SHELLBOOST/env/gitexclude"           .gitexclude
link "$SHELLBOOST/env/hgrc"                 .hgrc
link "$SHELLBOOST/env/profile"              .profile
link "$SHELLBOOST/env/setpath"              .setpath
link "$SHELLBOOST/env/xsessionrc"           .xsessionrc
link "$SHELLBOOST/env/XCompose"             .XCompose
link "$SHELLBOOST/env/vimrc"                .vimrc
link "$SHELLBOOST/env/openbox_rc.xml"       .config/openbox/rc.xml
link "$SHELLBOOST/env/openbox_environment"  .config/openbox/environment
link "$SHELLBOOST/env/tmate.conf"           .tmate.conf
