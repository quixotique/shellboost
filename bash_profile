# .bash_profile
# vim:sts=4 sw=4 et
# Bash shell per-invocation initialisation

test -r $HOME/.bashrc && source $HOME/.bashrc
test -r $HOME/.profile && source $HOME/.profile

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