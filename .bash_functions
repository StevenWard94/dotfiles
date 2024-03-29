########################################################################################
#  File:        ~/dotfiles/.bash_functions                                             #
#  Author:      Steven Ward <stevenward94@gmail.com>                                   #
#  URL:         https://github.com/StevenWard94/dotfiles                               #
#  Last Change: 2022 Jun 7                                                             #
########################################################################################

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
        apt-cache show "${pkg}" | sed -rn '/^(Package|Version):/p'
        if dpkg -s "${pkg}" >/dev/null 2>&1; then
            dpkg -s "${pkg}" | sed -rn '/^Status:/p'
        else
            echo "Status: not installed"
        fi
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


# function to quickly jump to a specific site-packages directory
cd_py_pkgs () {
    local site_pkgs_path="/home/steven/.local/lib/python3.9/site-packages"

    if [[ "$#" < 1 ]]; then
        if cd "${site_pkgs_path}"; then
            return 0
        else
            printf "ERROR: Failed to change working directory to target: %s\n" "${site_pkgs_path}" >&2
            printf "Make sure that site-packages path defined in function exists and matches latest python version\n" >&2
            printf "${HOME}/.bash_functions: cd_py_pkgs ()\n" >&2
            return 1
        fi
    else
        local pkg_folder_name="$1"
        local pkg_folder_path="${site_pkgs_path}/$1"

        if cd "${pkg_folder_path}"; then
            return 0
        else
            printf "ERROR: Failed to change working directory to target: %s\n" "${pkg_folder_path}\n" >&2
            printf "Make sure that site-packages path specified in function exists and matches latest python version\n" >&2
            printf "NOTE: Package names do not always match the corresponding directory name\n" >&2
            return 1
        fi
    fi
    return 2
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


# Some functions for performing simple operations w/ bc more concisely

calc () {
    # general calculator - simply feeds a "here string" to bc
    bc <<< "$@"
}

quotient () {
    if (("$#" < 2)); then
        if (("$#" == 1)); then
            echo "$1"
            return 1
        else
            echo "0"
            return 2
        fi
    elif (("$#" == 2)); then
        echo "$(calc $1/$2)"
        return 0
    else
        local part_quotient
        part_quotient=$(calc "$1/$2")
        shift 2
        echo "$(quotient $part_quotient $@)"
    fi
    return 0
}
alias divide='quotient'

product () {
    if (("$#" < 2)); then
        if (("$#" == 1)); then
            echo "$1"
            return 1
        else
            echo "0"
            return 2
        fi
    elif (("$#" == 2)); then
        echo "$(calc $1*$2)"
        return 0
    else
        local part_product
        part_product=$(calc "$1*$2")
        shift 2
        echo "$(product $part_product $@)"
    fi
    return 0
}
alias multiply='product'

# NOTE: `sum` already exists as /usr/bin/sum, so...add...
add () {
    if (("$#" < 2)); then
        if (("$#" == 1)); then
            echo "$1"
            return 1
        else
            echo "0"
            return 2
        fi
    elif (("$#" == 2)); then
        echo "$(calc $1+$2)"
        return 0
    else
        local part_sum
        part_add=$(calc "$1+$2")
        shift 2
        echo "$(add $part_sum $@)"
    fi
    return 0
}

subtract () {
    if (("$#" < 2)); then
        if (("$#" == 1)); then
            echo "$1"
            return 1
        else
            echo "0"
            return 2
        fi
    elif (("$#" == 2)); then
        echo "$(calc $1-$2)"
        return 0
    else
        local part_difference
        part_difference=$(calc "$1-$2")
        shift 2
        echo "$(subtract $part_difference $@)"
    fi
    return 0
}
alias difference='subtract'


# Get file name of disk device(s) containing file(s)
findpart () {

    if [[ $# < 1 ]]; then
        findpart "${PWD}"
    elif [[ $# == 1 ]]; then
        if [[ -e $1 ]]; then
            df -P "$1" | awk '/^\/dev/ {print $1}'
        else
            printf 'findpart: %s: No such file or directory\n' "$1"
            return 1
        fi
    else
    local file_not_found_flag
        for filename in $@; do
            if [[ -e ${filename} ]]; then
                printf '%s: %s\n' "${filename}" "$(df -P ${filename} | awk '/^\/dev/ {print $1}')"
            else
                printf 'findpart: %s: No such file or directory\n' "${filename}"
                file_not_found_flag='TRUE'
            fi
        done
        [[ -n ${file_not_found_flag} ]] && return 1 || return 0
    fi
}


# Execute a crude "trace" for bash - for use w/ `trap`: `trap trace DEBUG`
trace () {
    echo "TRACE" \
         "${BASH_SOURCE[1]}:${BASH_LINENO[0]}:${FUNCNAME[1]}:" \
         "$BASH_COMMAND"
}


tmux_new_session () {
    local tmux_ls
    tmux_ls=$(tmux ls 2>/dev/null | sed 's/:.*$//')

    if [[ -z $(echo ${tmux_ls} | grep -E '^misc$') ]]; then
        tmux new-session -s misc
    else
        tmux attach-session -t misc
    fi
}


# function to quickly print a selection of lines from piped output
lines () {
    sed -n "$1,$2p"
}


# wrapper for find to set `-regextype egrep`
find () {
    args=
    for arg in $*
    do
        case $arg in
            -iregex|-regex)
                args="$args -regextype egrep $arg"
                ;;
            *)
                args="$args $arg"
                ;;
        esac
    done
    set -f
    command find $args
    set +f
}


project_doc () {
    local path_pattern="/home/steven/lib/cpp.d/CSC-3102/proj?"
    if [[ ${PWD} == ${path_pattern} ]]; then
        xdg-open csc3102proj??s19.pdf
    else
        echo "path_pattern: error: document not found in current directory" >&2
        return 1
    fi
}


# Returns 0 if package is installed; else 1
pkg_installed () {
    pkgname=$1
    if dpkg --get-selections | grep -q "^${pkgname}[^[:space:]]*[[:space:]]*install$" >/dev/null; then
        return 0
    else
        return 1
    fi
}


# Simple utility for getting info from /var/log/dpkg.log
apt-history () {
    case "$1" in
        install)
            cat /var/log/dpkg.log | grep 'install '
            ;;
        upgrade|remove)
            cat /var/log/dpkg.log | grep $1
            ;;
        rollback)
            cat /var/log/dpkg.log | grep upgrade | \
                grep "$2" -A10000000 | \
                grep "$3" -B10000000 | \
                awk '{print $4"="$5}'
            ;;
        *)
            cat /var/log/dpkg.log
            ;;
    esac
}



# vim:ft=sh:syn=sh:
