# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

#echo "------------------------------------------------------------------"
#echo "test: [[ -n \${BASH_VERSION} ]]  //  BASH_VERSION = ${BASH_VERSION}"
if [[ -n ${BASH_VERSION} ]]; then
#    echo -e "result: TRUE\n"
#    echo "test: [[ -f \${HOME}/.bashrc ]]  //  \$HOME/.bashrc -> ${HOME}/.bashrc"
    # include .bashrc if it exists
    if [[ -f ${HOME}/.bashrc ]]; then
#        echo -e "result: TRUE\n"
#        echo "source: ${HOME}/.bashrc"
        . "${HOME}/.bashrc"
#    else
#        echo -e "result: FALSE\n"
#        echo "ERROR: file not found: ${HOME}/.bashrc"
#        echo "SKIP: source: ${HOME}/.bashrc"
    fi
#else
#    echo -e "result: FALSE\n"
#    echo "ERROR: variable contains empty string: \$BASH_VERSION"
#    echo "SKIP: check for \${HOME}/.bashrc"
#    echo "SKIP: source: ${HOME}/.bashrc"
fi

shopt -s dotglob

#echo "LOADED ~/.bash_profile!" 

