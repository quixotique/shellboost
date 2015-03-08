# .bashrc
# vim:sts=4 sw=4 et
# Bash shell per-invocation initialisation

# Test if shellboost is installed in some well-known places, if we don't
# already know.

if [ ! -f "$SHELLBOOST/etc/shellboost/libsh/include.sh" -a -f "$HOME/etc/shellboost/libsh/include.sh" ]; then
   export SHELLBOOST="$HOME/etc/shellboost"
   . "$SHELLBOOST/libsh/include.sh"
fi

# Source global definitions

if [ -f /etc/bash.bashrc ]; then
    source /etc/bash.bashrc
fi

# If our PATH has been clobbered (probably by su), correct it if we can.

case $PATH in
*:$HOME/bin:* | $HOME/bin:* | *:$HOME/bin) ;;
*) [ -f $HOME/.setpath ] && source $HOME/.setpath;;
esac

# Prompts.

PS1='\h:\w'
case $TERM in
xterm*)
    PS1="$PS1"'\[\033]2;\h \w\007\]'
    ;;
esac
if [ -w / ]; then
    PS1="$PS1 # "
else
    PS1="$PS1 \$ "
fi
PS2='> '
export PS1 PS2

# Command-line editing mode.

set -o emacs
set +o vi

# Shell behaviour preferences.

set -o notify
set -o noclobber
set +o nounset
set +o ignoreeof

# Quick-type commands.

lspath=$(which ls)
alias ls="$lspath \$LS_OPTIONS"
alias l="$lspath \$LS_OPTIONS -C"
alias ll="$lspath \$LS_OPTIONS -lH"
unset lspath

# Useful development functions.

alias grep='grep --color=auto'

# Preferred editors.

alias vi=gvim
alias vidiff=gvimdiff

# Development profile (only in Bash).

# User command to view/set current profile.
p() {
    case $# in
    0) cat "$HOME/etc/devprofile" 2>/dev/null; return 0;;
    esac
    case $(builtin type -t __undo_profile) in
    function)
        __undo_profile
        unset -f __undo_profile
        ;;
    esac
    mkdir -p $HOME/etc
    echo "$1" >|$HOME/etc/devprofile
    . $HOME/.bash_profile
}

# Invoked by .bash_profile
_init_devprofile() {
    export PROFILE=$(cat $HOME/etc/devprofile 2>/dev/null || true)
    if [ -n "$PROFILE" ]; then
        if [ -r "$HOME/$PROFILE/.bash_profile" ]; then
           . "$HOME/$PROFILE/.bash_profile"
        elif [ -r "$HOME/$PROFILE/.profile" ]; then
           . "$HOME/$PROFILE/.profile"
        fi
    fi
}

# For argument completion.
_complete_devprofiles() {
    local __had_nullglob=false
    shopt -q nullglob && __had_nullglob=true
    shopt -s nullglob
    local __prof
    for __prof in $HOME/$2*/.profile; do
        __prof=${__prof%/.profile}
        __prof=${__prof##*/}
        COMPREPLY+=("$__prof")
    done
    $__had_nullglob || shopt -u nullglob
}

complete -F _complete_devprofiles p

# Mail reading completion

complete -C mh-folder-names mail save scan rmf
