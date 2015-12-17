# .profile
# vim:sts=4 sw=4 et
# Bourne shell (not just Bash!) login initialisation

# Test if shellboost is installed in some well-known places, if we don't
# already know.
if [ ! -f "$SHELLBOOST/etc/shellboost/libsh/include.sh" -a -f "$HOME/etc/shellboost/libsh/include.sh" ]; then
   export SHELLBOOST="$HOME/etc/shellboost"
   . "$SHELLBOOST/libsh/include.sh"
fi

# Set $PATH.
[ -r $HOME/.setpath ] && . $HOME/.setpath

# Suppress the following WARNING **: Couldn't register with accessibility bus:
# Did not receive a reply. Possible causes include: the remote application did
# not send a reply, the message bus security policy blocked the reply, the reply
# timeout expired, or the network connection was broken.
export NO_AT_BRIDGE=1

# General application settings.
#export HEADROOM_HOME=$HOME/headroom
export BYCB_HOME=$HOME/Vault/Australia/BYCB
export EDITOR=/usr/bin/vim
[ -x "$SHELLBOOST/bin/gvim-nofork" ] && export EDITOR="$SHELLBOOST/bin/gvim-nofork" 
export PAGER=/usr/bin/less
export GROFF_TMAC_PATH=$HOME/lib:$BYCB_HOME/tmac:/usr/lib/groff/tmac
export MM_CHARSET=utf-8
export LESS=-R
export LESSCHARSET=utf-8
export PERL5LIB=$HOME/lib/perl5
export TMPDIR=/tmp
export DEBFULLNAME='Andrew Bettison'
export DEBEMAIL='andrew@iverin.com.au'
export PYTHONPATH="$HOME/lib/python:$HOME/.local/lib/python"
export SIX_SOURCE="$HOME/Vault/contacts/nlist.txt"
export SIX_LOCAL=SA
export ROWS
export COLUMNS

export LS_OPTIONS='--color=auto'
[ -x /usr/bin/dircolours ] && eval "$(/usr/bin/dircolors)"

unset CVS_RSH
unset CVSROOT

# Vim settings
unset VIMRC_SWITCH
unset CSCOPE_DB

# Mercurial settings
unset HGRC_SWITCH

__shellboost_include libsh/vim.sh

# GNOME window manager.
#export WINDOW_MANAGER=/usr/bin/openbox

