# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)

shopt -s extdebug

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


# define $LFS variable for "Linux From Scratch"
export LFS=/mnt/lfs


# add user's HOME binaries to PATH
if [[ -d ${HOME}/bin ]]; then
    case ":${PATH}:" in
        *":${HOME}/bin:"*) ;;
        *) PATH="${HOME}/bin${PATH:+:${PATH}}";;
    esac
fi


# add binaries under ~/.local/bin to $PATH environment variable
if [[ -d ${HOME}/.local/bin ]]; then
    case ":${PATH}:" in
        *"${HOME}/.local/bin"*) ;;
        *) PATH="${HOME}/.local/bin${PATH:+:${PATH}}" ;;
    esac
fi


# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# export my "would-be" value of $VIMRUNTIME for use outside of vim
export VIMRUNTIME="/usr/local/share/vim/vim80"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

stty -ixon

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# enable Powerline
if type powerline >/dev/null 2>&1; then
    export POWERLINE_DIR="${HOME}/.local/lib/python2.7/site-packages/powerline"
    export POWERLINE_CONFIG="${HOME}/.local/lib/python2.7/site-packages/powerline/config_files"

    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    . ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export EDITOR='/usr/bin/vim.gnome'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
#alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export NVM_DIR="$HOME/.nvm"
[[ -s $NVM_DIR/nvm.sh ]] && . "$NVM_DIR/nvm.sh"  # this loads nvm


# enable tab-completion of haskell-stack commands
# eval "$(stack --bash-completion-script stack)"

# jenv init -
#export PATH="/home/steven/.jenv/shims:${PATH}"
#source "/home/steven/.jenv/libexec/../completions/jenv.bash"
#
#jenv rehash 2>/dev/null
#export JENV_LOADED=1
#unset JAVA_HOME
#
#jenv () {
#    typeset command
#    command="$1"
#    if [ "$#" -gt 0 ]; then
#        shift
#    fi
#
#    case "$command" in
#        enable-plugin|rehash|shell|shell-options)
#            eval `jenv "sh-$command" "$@"`;;
#        *)
#            command jenv "$command" "$@";;
#    esac
#}


# configure OPAM for use:
. ~/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

# source bash functions
. ~/.bash_functions


# add perl binaries to $PATH environment variable
if [[ -d ${HOME}/perl5/bin ]]; then
    case ":${PATH}:" in
        *":${HOME}/perl5/bin:"*) ;;
        *) PATH="${HOME}/perl5/bin${PATH:+:${PATH}}";;
    esac
fi


# add perl6 (via https://github.com/tadzik/rakudobrew) binaries to $PATH
if [[ -d ${HOME}/.rakudobrew/bin ]]; then
    case ":${PATH}:" in
        *":${HOME}/.rakudobrew/bin:"*) ;;
        *) PATH="${HOME}/.rakudobrew/bin${PATH:+:${PATH}}";;
    esac
fi


# define other environment variables for perl5 libraries
PERL5LIB="${HOME}/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="${HOME}/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"${HOME}/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=${HOME}/perl5"; export PERL_MM_OPT;


# add $PYENV_ROOT environment variable and put pyenv binaries in $PATH
if [[ -d ${HOME}/.pyenv ]]; then
    export PYENV_ROOT="${HOME}/.pyenv"
    case ":${PATH}:" in
        *":${PYENV_ROOT}/bin:"*) ;;
        *) PATH="${PYENV_ROOT}/bin${PATH:+:${PATH}}" ;;
    esac
fi


export GITHUB_AUTH_TOKEN='1b1d89a8a98ca979ff350c46b5ff33a944353e1f'


# call `pyenv init` to enable shims & autocompletion in shell
eval "$(pyenv init -)"


[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "${HOME}/.rvm/scripts/rvm" ]] && source "${HOME}/.rvm/scripts/rvm"

# Helps prevent rvm's 'Warning! PATH is not properly set up...' message about path to gems
export PATH="${GEM_HOME}/bin:$PATH"

# remove duplicate entries from $PATH environment variable
PATH=$(echo "${PATH}" | awk -v RS=':' -v ORS=":" '!a[$1]++{if (NR > 1) printf ORS; printf $a[$1]}')
export PATH
