# aliases for opening textbooks in LSU/fall_2019
# IE 3302 [Stats]
alias open-stats-textbook='xdg-open /home/steven/Documents/LSU/fall_2019/ie-3302/probability-and-statistics_9ed.pdf'
alias stats-textbook='open-stats-textbook'
alias stats-text='open-stats-textbook'
alias stats-txt='open-stats-textbook'
# CSC 4402 [Database Systems]
alias open-4402-textbook='xdg-open /home/steven/Documents/LSU/fall_2019/csc-4402/database-system-concepts_7ed.pdf'
alias open-db-textbook='open-4402-textbook'
alias db-text='open-4402-textbook'
alias db-txt='open-4402-textbook'
# cd to current semester/courses
alias cd-lsu='cd /home/steven/Documents/LSU/fall_2019'
alias cd-stats='cd /home/steven/Documents/LSU/fall_2019/ie-3302'
alias cd-stat='cd-stats'
alias cd-database-systems='cd /home/steven/Documents/LSU/fall_2019/csc-4402'
alias cd-dbs='cd-database-systems'
alias cd-operating-systems='cd /home/steven/Documents/LSU/fall_2019/csc-4103'
alias cd-os='cd-operating-systems'

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

# shortcut to list all users (usually the same as `cut -d: -f1 /etc/passwd`)
alias getusers='getent passwd | cut -d: -f1'
alias showusers='getent passwd | cut -d: -f1'
alias lsusers='getent passwd | cut -d: -f1'

# pretty-print output from 'mount' command
alias mount='mount | column -t'

# some "new" commands
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%r"'
alias today='date +"%x"'

# print date in 'yyyymmdd' format (e.g., 20180312)
alias date-Ymd='date +%Y%m%d'

# print date in RFC 3339 format with 'T' instead of a space before the time
alias rfc-date="date --rfc-3339=seconds | sed 's/ /T/'"

# stop 'ping' command after 10 ECHO_REQUEST packets
alias pings='ping -c 10'
# don't run with 1 second intervals
alias qping='ping -c 100 -s.2'

# show open ports
alias ports='netstat -tulanp'

# shorthand to start clojure REPL
alias repl='lein repl'

# shorthand to quickly perform apt-cache operations
alias find-pkg='apt-cache search --names-only'
alias show-pkg='apt-cache show'
# alternate name for the 'show_pkg_brief' function in ~/.bash_functions
alias show-pkg-brief='show_pkg_brief'
# alternate name for the 'describe_pkg' function in ~/.bash_functions
alias describe-pkg='describe_pkg'

# use 'pinfo' to view info pages by default
alias info='pinfo'

# mzscheme crashes - use racket implementation instead
alias mzscheme='racket'

# make different "pips" always refer to a specific python version (uses default symlink for python/python3 - should be pyenv shims)
# these are unnecessary because 'pip2' & 'pip3' are already defined by the corresponding pyenv shims 
#alias pip2='python2 -m pip'
#alias pip3='python3 -m pip'

## shortcuts to update all python (2.7 or 3) packages installed w/ pip
# aliases for pip using python2.7 (i.e., pip2)
alias update-pip2="python2 -m pip freeze --local | sed '/^-e/d;s/=.*//' | xargs -n1 python2 -m pip install --upgrade"
alias upgrade-pip2='update-pip2'
alias pip2-update='update-pip2'
alias pip2-upgrade='update-pip2'
# aliases for pip using python3 (i.e., pip3)
# pip 22.3 no longer allows 'freeze' formatting with 'outdated' so this now throws an error
#alias update-pip3="python3 -m pip list --outdated --format=freeze | sed '/^-e/d;s/=.*//' | xargs -n1 python3 -m pip install -U"
# new solution: use 'json' formatting and then reformat the output with jq to look like 'freeze' format
alias update-pip3="python3 -m pip list --outdated --format=json | jq -r '.[] | .name+\"=\"+.latest_version' | sed '/^-e/d;s/=.*//' | xargs -n1 python3 -m pip install --upgrade"
alias upgrade-pip3='update-pip3'
alias pip3-update='update-pip3'
alias pip3-upgrade='update-pip3'
# slightly more specific invocations of pydoc (no clue if this even matters...)
alias py2doc='python2 -m pydoc'
alias py3doc='python3 -m pydoc'
# go to site-packages for latest python (path needs to be manually updated along with python version)
alias cd-python-packages='cd_py_pkgs'
alias cd-python3-packages='cd-python-packages'
alias cd-py-packages='cd-python-packages'
alias cd-py-pkgs='cd-python-packages'

# always run tmux with 256-color support
alias tmux='tmux -2'
# aliases for my 'tmux_new_session' function [see: ~/dotfiles/.bash_functions]
alias tmux-new='tmux_new_session'
alias new-session='tmux_new_session'
# shorthand for `tmux ls`
alias t-ls='tmux ls'
alias tmux-ls='t-ls'
alias tmux-l='t-ls'

# always display color escape sequences in pager
alias less='less -R'

# shortcuts for converting line endings
alias unix2dos='unix_to_dos'
alias dos2unix='dos_to_unix'
#alias unix2dos="perl -pi -e 's/\r\n|\n|\r/\r\n/g'"
#alias dos2unix="perl -pi -e 's/\r\n|\n|\r/\n/g'"

# shortcuts for sed 'print' functions defined in ~/.bashrc
# TODO: COMPLETE FUNCTIONS AND ALIASES AS MENTIONED ABOVE

# alias for my ~/bin/date-sort scripts
alias newest='/home/steven/bin/date-sort | head -n1'
alias last-change='/home/steven/bin/date-sort | head -n1'
alias date-sort='/home/steven/bin/date-sort'
alias sort-date='/home/steven/bin/date-sort'

###############################
## ALIASES FOR `stat` COMMAND

# Output: '{filename}: {octal-access-mode}  -  Owner: {User}({uid}) in Group: {Group}({gid})'
alias mode='stat -c "%n: %a  -  Owner: %U(%u) in Group: %G(%g)"'

# Output:
#        {filename -> optional-link-target}
#            {User}:{Group}  -  {letter-access-mode} ({octal-access-mode})
alias mode-twoline='stat --printf="%N\n    %U:%G  -  %A (%a)\n"'
alias mode-two=mode-twoline
alias mode-2=mode-twoline

alias mode-delim='stat --printf="%N\n    %U:%G  -  %A (%a)\n ---  ---  ---  ---  ---\n"'
alias mode-three=mode-delim
alias mode-3=mode-delim

###############################


# shortcuts to remove executables in 'bin/' directory, the 'build/' directory
#   (and/or its contents), or both (which also executes `cd build`
alias clear-bin='rm -v bin/*'
alias rm-bins='clear-bin'
alias rm-bin='clear-bin'

alias rm-build-dir='rm -rdf build'
alias clean-build-dir='rm -rdf build/*'
alias rm-build-files='clean-build-dir'

alias reset-build='rm -v bin/* && rm -rdf build/* && cd build'
alias reset-last-build='reset-build'
alias rm-build='reset-build'
alias rm-last-build='reset-build'
alias clean-last-build='reset-build'
alias clean-build='reset-build'
alias new-build='reset-build'

# shortcut to print search paths to/for included headers
alias gcc-include-paths='gcc -H'
alias gcc-hpaths='gcc-include-paths'
alias clang-include-paths='clang -H'
alias clang-hpaths='clang-include-paths'

# abbreviate (4 lines) output from `vim --version`
alias vim-version="vim --version | sed -rn '1,3p;4s/^([^.]+)(\..*)$/\1/p'"
alias vim--version='vim-version'
alias vim-v='vim-version'
alias vim-V='vim-version'
alias vim--V='vim-version'
alias vim--v='vim-version'

# shorthand to open the MIPS Assembly and Runtime Simulator (MARS)
alias Mars='java -jar /home/steven/Documents/LSU/spring_2019/csc-3501/MARS/Mars.jar'
alias run-mars='Mars'

# shorthand for `octave --no-gui` to force the octave CLI
alias octave-cli='octave --no-gui'
alias octave-term='octave-cli'
alias octave-shell='octave-cli'

# getting battery info
alias battery-info="upower -i $(upower -e | grep --color=never 'BAT')"
alias battery-brief='battery-info | grep -E "state|to\ full|percentage"'

# autocorrect when I forget 'sudo' with 'fdisk'
alias fdisk="sudo fdisk"

# shorthand for 'xdg-open' command
alias open="xdg-open"

# use ghci-color instad of basic ghci
alias ghci="ghci-color"
