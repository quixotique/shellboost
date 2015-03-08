# .bash_profile
# vim:sts=4 sw=4 et
# Bash shell per-invocation initialisation

# Work out where shellboost is installed and bootstrap shellboost's include
# system.  If readlink(1) is not installed, this will fail and fall back to
# the logic in .profile
export SHELLBOOST="$(readlink -q -e "${BASH_SOURCE[0]}" 2>/dev/null)" 2>/dev/null
if [ -f "$SHELLBOOST/libsh/include.sh" ]; then
    source "$SHELLBOOST/libsh/include.sh"
else
    unset SHELLBOOST
    __shellboost_include() { echo "Failure: __shellboost_include $1" >&2; return 1; }
fi

# Source initialisation scripts.
test -r $HOME/.bashrc && source $HOME/.bashrc
test -r $HOME/.profile && source $HOME/.profile

# Source current development profile, if there is one.
case $(builtin type -t _init_devprofile) in
function)
    _init_devprofile
    ;;
esac

# User specific environment and startup programs

unset USERNAME

# ABO settings
# TODO These should be placed in the ABO repository and sourced from here

# Prevent Bash from always breaking completion words on ':' so that
# account names containing ':' can be completed like usual
COMP_WORDBREAKS=${COMP_WORDBREAKS//:}

# Prevent Bash from always breaking completion words on '=' so that --select
# arguments starting with '=' can be completed as a list of tags.
COMP_WORDBREAKS=${COMP_WORDBREAKS//=}

complete -C 'abo compa' acc stmt
complete -o nospace -C 'pyabo compa' pyabo
