# .profile
# vim:sts=4 sw=4 et
# Bourne shell (not just Bash!) login initialisation

# Set PATH if we can.
[ -r $HOME/.setpath ] && . $HOME/.setpath

# GNOME window manager.
#WINDOW_MANAGER=/usr/bin/openbox export WINDOW_MANAGER

# Suppress the following WARNING **: Couldn't register with accessibility bus:
# Did not receive a reply. Possible causes include: the remote application did
# not send a reply, the message bus security policy blocked the reply, the reply
# timeout expired, or the network connection was broken.
export NO_AT_BRIDGE=1

# General application settings.
#HEADROOM_HOME=$HOME/headroom export HEADROOM_HOME
BYCB_HOME=$HOME/Vault/Australia/BYCB export BYCB_HOME
EDITOR=$HOME/bin/mygvim export EDITOR
PAGER=/usr/bin/less export PAGER
CDPATH=.:$HOME export CDPATH
GROFF_TMAC_PATH=$HOME/lib:$BYCB_HOME/tmac:/usr/lib/groff/tmac export GROFF_TMAC_PATH
MM_CHARSET=utf-8 export MM_CHARSET
LESS=-R export LESS
LESSCHARSET=utf-8 export LESSCHARSET
PERL5LIB=$HOME/lib/perl5 export PERL5LIB
TMPDIR=/tmp export TMPDIR
DEBFULLNAME='Andrew Bettison' export DEBFULLNAME
DEBEMAIL='andrew@iverin.com.au' export DEBEMAIL
PYTHONPATH="$HOME/lib/python:$HOME/.local/lib/python" export PYTHONPATH
SIX_SOURCE="$HOME/Vault/contacts/nlist.txt" export SIX_SOURCE
SIX_LOCAL=SA export SIX_LOCAL
export ROWS
export COLUMNS

LS_OPTIONS='--color=auto' export LS_OPTIONS
eval "`dircolors`"

unset CVS_RSH

# Vim settings
unset VIMRC_SWITCH
unset CSCOPE_DB
