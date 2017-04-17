#!/bin/bash

command_exists()
{
    command -v $1 >/dev/null 2>&1
}

if ! command_exists pacman; then

    if [ "${OS}" == "Microsoft Windows" ] || [ "${OS}" == "${AIX}" ] ||
       [ "${OS}" == "Unknown" ]; then
	echo "Warning: nor pacman nor pacapt are available on this system"
	return 1
    fi

    mkdir -p ~/bin
    if [ ! -f ~/bin/pacman ]; then
	ln -s ~/.bashrc.d/pacapt/pacapt ~/bin/pacman
    fi

fi

return 0
