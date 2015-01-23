# .bashrc
# vim:sts=4 sw=4 et
# Bash shell per-invocation initialisation

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

# Development profile.

# User command to view/set current profile.
p() {
    case $# in
    0) cat "$HOME/etc/profile" 2>/dev/null; return 0;;
    esac
    case $(builtin type -t __undo_profile) in
    function)
        __undo_profile
        unset -f __undo_profile
        ;;
    esac
    mkdir -p $HOME/etc
    echo "$1" >|$HOME/etc/profile
    . $HOME/.profile
}

# Invoked by .profile
_init_devprofile() {
    export PROFILE=$(cat $HOME/etc/profile 2>/dev/null || true)
    test -n "$PROFILE" -a -r "$HOME/$PROFILE/.profile" && . "$HOME/$PROFILE/.profile"
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
