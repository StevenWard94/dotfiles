alias ls='ls --color=always'
alias la='ls -A'
alias ll='ls -alF'
alias l='ls -CF'
alias dirs='ls -Ad -- */'

alias grep='grep --color=always'
alias fgrep='fgrep --color=always'
alias egrep='egrep --color=always'

# 'alert' alias for use with long-running commands, like so:
#   `sleep 10; alert`
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# add "autocorrect" for `cd..` to `cd ..`
alias cd..='cd ..'

# shortcuts for moving up in directory structure
alias ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ...='cd ../../..'
alias ..4='cd ../../../..'
alias ....='cd ../../../..'
alias ..5='cd ../../../../..'
alias .....='cd ../../../../..'

# start bc calculator with math library
alias bc='bc -l'

# always create parent directories when necessary
alias mkdir='mkdir -pv'

# use colordiff for file comparisons
alias diff='colordiff'

# pretty-print output from 'mount' command
alias mount='mount | column -t'

# some "new" commands
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%r"'
alias today='date +"%x"'

# stop 'ping' command after 10 ECHO_REQUEST packets
alias pings='ping -c 10'
# don't run with 1 second intervals
alias qping='ping -c 100 -s.2'

# show open ports
alias ports='netstat -tulanp'

# shorthand to start clojure REPL
alias repl='lein repl'

# autocorrect for 'apt-get' commands w/o root priveleges
alias apt-get='sudo apt-get'

# shorthand for 'stack ghci' to open haskell repl
alias ghci='stack ghci'

# shorthand to execute apt-get update followed by dist-upgrade
alias apt-update='sudo apt-get update && sudo apt-get dist-upgrade -y'

# shorthand to quickly perform apt-cache operations
alias find-pkg='apt-cache search --names-only'
alias show-pkg='apt-cache show'

# use 'pinfo' to view info pages by default
alias info='pinfo'

# mzscheme crashes - use racket implementation instead
alias mzscheme='racket'

# make different "pips" always refer to a specific python version
alias pip2='python2.7 -m pip'
alias pip3='python3.5 -m pip'

# shortcut to update all python packages installed w/ 'pip'
alias pip2-update="python2.7 -m pip freeze --local | sed '/^-e/d;s/=.*//' | xargs -n1 sudo -H python2.7 -m pip install --upgrade"
alias pip3-update="python3.5 -m pip freeze --local | sed '/^-e/d;s/=.*//' | xargs -n1 sudo -H python3.5 -m pip install --upgrade"

# always run tmux with 256-color support
alias tmux='tmux -2'

# always display color escape sequences in pager
alias less='less -R'

# shortcuts for converting line endings
alias unix2dos='unix_to_dos'
alias dos2unix='dos_to_unix'
#alias unix2dos="perl -pi -e 's/\r\n|\n|\r/\r\n/g'"
#alias dos2unix="perl -pi -e 's/\r\n|\n|\r/\n/g'"

# shortcuts for sed 'print' functions defined in ~/.bashrc
