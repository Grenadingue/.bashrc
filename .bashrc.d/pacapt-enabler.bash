#!/bin/bash

if [ "${DISTRIB}" != "Arch Linux" ]; then

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
