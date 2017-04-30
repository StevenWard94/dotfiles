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


describe_pkg () {
    if [[ $# < 1 ]]; then
        echo "Usage: $0 package-name"
        return 1
    fi

    for pkg in "$@"; do
        apt-cache show "${pkg}" | sed -rn '/^Description(-en)?:/,/^[-A-Za-z]+:/{/^Description(-en)?:/{p;n};/^[-A-Za-z]+:/{q};p}'
        echo -e "\n----- --- ----- --- ----- --- -----\n"
    done
    return 0
}


# vim:ft=sh:syn=sh:
