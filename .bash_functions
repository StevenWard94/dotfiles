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
apt_repo_added () {
    if [[ $# < 1 ]]; then
        printf 'ERROR: %s requires at least one ppa/repo name\n' "$0"
        printf 'USAGE: %s [ppa-names...] [other-repos...]\n' "$0"
        return 126
    fi

    (( to_stderr = 0 ))
    for src in "$@"; do
        local regex='^\s*[^#].*'"${src}"
        local search_result=( "$(grep -iEl ${regex} /etc/apt/sources.list /etc/apt/sources.list.d/*)" )
        if [[ -z ${search_result[@]} ]]; then
            >&2 printf 'no matches found for in apt sources for: %s\n' "${src}"
            (( to_stderr++ ))
        else
            printf 'match found in apt source file(s): '
            for file in "${search_result[@]}"; do
                printf ' %s ' "${file}"
            done
            printf '\n'
        fi
    done
    if [[ to_stderr != 0 ]]; then
        return 1
    else
        return 0
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


describe_pkg () {
    if [[ $# < 1 ]]; then
        printf 'Usage: %s [package-name]\n' "$0"
        return 1
    fi

    for pkg in "$@"; do
        apt-cache show "${pkg}" | sed -rn '/^Description(-en)?:/,/^[^: ]+:/{/^Description(-en)?:/{p;n};/^[^: ]+:/{q};p}'
        echo -e "\n----- --- ----- --- ----- --- -----\n"
    done
    return 0
}


show_pkg_brief () {
    if [[ $# < 1 ]]; then
        printf 'USAGE: show_pkg_brief [pkg-names...]\n' >&2
        return 1
    fi

    for pkg in "$@"; do
        apt-cache show "${pkg}" | grep -iE '^(package|version|replaces|provides|breaks|conflicts|(pre-)?depends|suggests|recommends):'
        printf '\n----- --- ----- --- ----- --- -----\n'
    done
    return 0
}


# function to handle activation of python virtual environments
activate () {
    local env_name envs_dir
    if [[ $# < 1 ]]; then
        env_name="${PWD##*/}"
    else
        env_name="$1"
    fi

    envs_dir="${ENVS_DIR:-${WORKON_HOME:-${HOME}/.virtualenvs}}"
    if ! [[ -f ${envs_dir}/${env_name}/bin/activate ]]; then
        printf 'ERROR: VIRTUAL ENVIRONMENT NOT FOUND: %s\n' "${env_name}"
        printf 'PLEASE ENSURE THAT THE ENVIRONMENT DIRECTORY EXISTS: %s\n' "${envs_dir}/${env_name}"
        return 1
    fi

    source "${envs_dir}/${env_name}/bin/activate"
}


# function to handle display of npm package dependencies
#npm_pkg_deps () {
#    local flag_pattern='^--[a-zA-Z]+$'
#    local usage_msg='USAGE: npm_pkg_deps [DEPS-TYPE-FLAG] [PKG-NAME]'
#    if [[ $# < 2 ]]; then
#        if  ! [[ $1 =~ ${flag_pattern} ]]; then
#            printf '%s\n' "${usage_msg}"
#            printf 'DEPENDENCY TYPE FLAG REQUIRED! NONE PROVIDED! --[dependencies | peerDependencies | devDependencies]\n'
#            return 1
#        else
#            printf '%s\n' "${usage_msg}"
#            printf 'NODE.JS PACKAGE NAME REQUIRED! NONE PROVIDED!\n'
#            return 1
#        fi
#    fi
#
#    declare -a node_pkg_names
#    declare -a deps_type_flags
#    while [[ $# > 0 ]]; do
#        if [[ $1 =~ ${flag_pattern} ]]; then
#            flag="$1"
#            case ${flag} in
#                --peerDependencies|--peerdependencies|--PeerDependencies|--peerDeps|--peerdeps|--PeerDeps)
#                    deps_type_flags=peerDependencies
#                    ;;
#                --devDependencies|--devdependencies|--DevDependencies|--devDeps|--devdeps|--DevDeps)
#                    deps_type_flags=devDependencies
#                    ;;
#                --dependencies|--Dependencies|--deps|--Deps)
#                    deps_type_flags=dependencies
#                    ;;
#                --json|--Json|--JSON)
#                    json_fmt=TRUE
#                    ;;
#                *)
#                    ;;
#            esac
#        else
#            node_pkg_names=( "${node_pkg_names[@]}" "$1" )
#        fi
#        shift
#    done
#
# TODO: npm info ${npm_pkg_names} --[ peerDependencies | devDependencies | dependencies ] (--json)?
#
#}


# check if the working directory is in a python virtual environment
is_in_virtenv () {
    return $(python -c 'import sys; print ("1" if hasattr(sys, "real_prefix") else "0")')
}


# vim:ft=sh:syn=sh:
