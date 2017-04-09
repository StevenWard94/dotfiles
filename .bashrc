# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# add user's HOME binaries to PATH
if [[ -d $HOME/bin ]]; then
    PATH="$HOME/bin:${PATH}"
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
export VIMRUNTIME="/usr/share/vim/vim74"

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
if [[ -f ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh ]]; then
    source ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
fi
if type powerline >/dev/null 2>&1; then
    export POWERLINE_DIR='/home/steven/.local/lib/python2.7/site-packages/powerline'
    export POWERLINE_CONFIG='/home/steven/.local/lib/python2.7/site-packages/powerline/config_files'
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

# source script to handle adding necessary directories to PATH
if [[ -r $HOME/.path.init ]]; then
    source "$HOME/.path.init"
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


##################
# CUSTOM FUNCTIONS
##################

# convenience function for mkdir followed by cd
mkcd () {
    if mkdir -p "$1"; then
        cd "$1"
    fi
}


# convenience function for archive extraction
extract () {
    if [[ -z $1 ]]; then
        # display usage message if parameters are omitted
        echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    else
        if [[ -f $1 ]]; then
            local nameInLowercase=$(echo "$1" | awk '{print tolower($0)}')
            case "$nameInLowercase" in
                *.tar.bz2)   tar -xvjf ./"$1"    ;;
                *.tar.gz)    tar -xvzf ./"$1"    ;;
                *.tar.xz)    tar -xvJf ./"$1"    ;;
                *.lzma)      unlzma ./"$1"       ;;
                *.bz2)       bunzip2 ./"$1"      ;;
                *.rar)       unrar x -ad ./"$1"  ;;
                *.gz)        gunzip ./"$1"       ;;
                *.tar)       tar -xvf ./"$1"     ;;
                *.tbz2)      tar -xvjf ./"$1"    ;;
                *.tgz)       tar -xvzf ./"$1"    ;;
                *.zip)       unzip ./"$1"        ;;
                *.Z)         uncompress ./"$1"   ;;
                *.7z)        7z x ./"$1"         ;;
                *.xz)        unxz ./"$1"         ;;
                *.exe)       cabextract ./"$1"   ;;
                *)           echo "extract: '$1' - unknown archive method" ;;
            esac
        else
            echo "extract: '$1' - file does not exist"
        fi
    fi
}


# convenience function for converting markdown and then displaying it
md () {
    if [[ -z $1 ]]; then
        # display usage message if no file is given
        echo "Usage: md <file>"
    else
        if [[ -f $1 ]]; then
            pandoc "$1" | lynx -nocolor -stdin
        else
            echo "Error: md: '$1' - file does not exist"
        fi
    fi
}


# function to determine whether a PPA has already been added to APT's sources
apt_locate_repo () {
    if [[ -z $1 ]]; then
        echo "Error: apt_locate_repo requires at least one PPA name argument"
    else
        for ppa in "$@"; do
            regex='^\s*[^#].*'$ppa'.*'
            search_result=("$(grep -El $regex /etc/apt/sources.list /etc/apt/sources.list.d/*)")
            if [[ -z $search_result ]]; then
                echo "ppa: $ppa not found in apt sources"
            else
                echo "ppa: $ppa found in file(s):"
                for file in "${search_result[@]}"; do
                    echo "    $file"
                done
            fi
            echo ""
        done
    fi
}


# functions for converting line-endings in files between dos & unix standards
dos_to_unix () {
    if (( $# < 1 )); then
        echo "--------------------"
        echo "USAGE: $0 [OPTIONAL BACKUP SUFFIX] FILE"
        return 1
    fi

    local suffix
    local filename

    if (( $# == 1 )); then
        suffix='.dos.fmt~'
        filename="$1"
    else
        suffix="$1"
        filename="$2"
    fi

    sed --in-place="${suffix}" 's/$//' "${filename}"
    return 0
}

unix_to_dos () {
    if (( $# < 1 )); then
        echo "--------------------"
        echo "USAGE: $0 [OPTIONAL BACKUP SUFFIX] FILE"
        return 1
    fi

    local suffix
    local filename

    if (( $# == 1 )); then
        suffix='.unix.fmt~'
        filename="$1"
    else
        suffix="$1"
        filename="$2"
    fi

    sed --in-place="${suffix}" 's/$//' "${filename}"
    return 0
}


#sed_range () {
#    if (( $# < 1 )); then
#        echo "ERROR: INVALID: $0 $*"
#        echo "USAGE: $0 RANGE-START [RANGE-END] [FILE]"
#        return 1
#    fi
#
#    local rng_start
#    local rng_end
#    local filename
#
#    rng_start="$1"
#    if (( $# < 3 )); then
#        rng_end="${2:-}"
#        filename='-'
#}



PATH="/home/steven/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/steven/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/steven/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/steven/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/steven/perl5"; export PERL_MM_OPT;
